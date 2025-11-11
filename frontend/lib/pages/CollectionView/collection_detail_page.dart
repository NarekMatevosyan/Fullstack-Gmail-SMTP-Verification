import 'package:bbb/components/common_streak_with_notification.dart';
import 'package:bbb/models/collections.dart';
import 'package:bbb/models/equipment.dart';
import 'package:bbb/providers/data_provider.dart';
import 'package:bbb/utils/screen_util.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:bbb/values/clip_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class CollectionDetailPage extends StatefulWidget {
  const CollectionDetailPage({super.key});

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  DataProvider? dataProvider;
  UserDataProvider? userData;

  @override
  void initState() {
    dataProvider = Provider.of<DataProvider>(
      context,
      listen: false,
    );

    userData = Provider.of<UserDataProvider>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final collection =
          ModalRoute.of(context)!.settings.arguments as Collections;
      loadCollectionData(collection);
    });
    super.initState();
  }

  void loadCollectionData(Collections collection) async {
    await dataProvider?.fetchOneCollection(collection.id);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget equipmentCard(String title, String imageurl, String description, String link) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          _launchURL(link); // Launch the external URL when tapped
        },
        child: Container(          
          decoration: const BoxDecoration(
              // color: Color(0xFF000000),
              ),
          child: Stack(
            children: [
              Container(
                width: ScreenUtil.horizontalScale(100),
                height: ScreenUtil.verticalScale(11),
                margin: const EdgeInsets.symmetric(
                    vertical: 15), // Padding around the background
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil.verticalScale(7)),
                  ),
                ),
                child: const SizedBox
                    .expand(), // Ensure the background takes up all available space
              ),
              Positioned(
                left: 20,
                top: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: imageurl.isNotEmpty
                  ? Image.network(imageurl.startsWith('https://storage.cloud.google.com/')
                    ? imageurl.replaceFirst('https://storage.cloud.google.com/', 'https://storage.googleapis.com/')
                    : imageurl,
                    width: ScreenUtil.verticalScale(11) + 10,
                    height: ScreenUtil.verticalScale(11) + 10,
                    fit: BoxFit.cover,)
                  : Image.asset(
                    'assets/img/warm-up-placeholder.png',
                    width: ScreenUtil.verticalScale(11) + 10,
                    height: ScreenUtil.verticalScale(11) + 10,
                    fit: BoxFit.cover,
                  )
                ),
              ),
              Positioned(
                left: ScreenUtil.verticalScale(11) +
                    45, // Adjust position based on image size and padding
                top: ScreenUtil.verticalScale(3.5) + 5, // Adjust as needed
                child: SizedBox(
                  width: media.width / 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.verticalScale(2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.verticalScale(2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final collectionData = ModalRoute.of(context)!.settings.arguments as Collections?;
    var media = MediaQuery.of(context).size;
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: media.height / 2.35,
                          width: media.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: collectionData!.photo.isNotEmpty
                              ? NetworkImage(
                                  collectionData.photo.startsWith('https://storage.cloud.google.com/')
                                      ? collectionData.photo.replaceFirst('https://storage.cloud.google.com/', 'https://storage.googleapis.com/')
                                      : collectionData.photo,
                                )
                              :  const AssetImage('assets/img/back.jpg'),
                              fit: BoxFit.cover,
                              opacity: 1,
                            ),
                          ),
                        ),
                        Container(
                          height: media.height / 2,
                          width: media.width,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          left:ScreenUtil.horizontalScale(4),
                                        ),
                                        decoration: const BoxDecoration(
                                          color:Color(0XFFd18a9b),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SizedBox(
                                          width: ScreenUtil.horizontalScale(10), // Size of the circle
                                          height:ScreenUtil.horizontalScale(10),
                                          child: IconButton(
                                            padding: EdgeInsets.zero, // Removes the default padding
                                            icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white,),
                                            onPressed: () => Navigator.pop(context),
                                            iconSize: ScreenUtil.verticalScale(4), // Icon size remains the same
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Collection',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.verticalScale(3),
                                        ),
                                      ),
                                      const CommonStreakWithNotification()
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil.horizontalScale(5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: ScreenUtil.horizontalScale(10)),
                                      SizedBox(
                                        width: ScreenUtil.horizontalScale(60),
                                        child: Text(
                                          collectionData.title.isNotEmpty ? collectionData.title : 'Collection Title',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil.horizontalScale(8.5),
                                            fontWeight: FontWeight.bold,
                                            height: 1.35,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.height / 2.79,
                          width: media.width,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: ClipPath(
                              clipper: DiagonalClipper(),
                              child: Container(
                                height: media.height / 11,
                                width: media.width / 6,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                

                Consumer<DataProvider>(builder: (context, dataProvider, child) {
                  final List<Equipment> equipments = dataProvider.oneCollection.equipments
                    .map<Equipment>((e) => Equipment.fromJson(e)) // or `e as Equipment`
                    .toList();
                  return equipments.isNotEmpty
                    ? Container(
                      margin: EdgeInsets.only(top: media.height / 2.8),
                      child: Container(
                        width: media.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ScreenUtil.horizontalScale(15)),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: media.height / 19, right: 20, left:20),
                          child: Column(
                            children: equipments.map((equipment) {
                              return Column(
                                children: [
                                  const SizedBox(height: 14),
                                  equipmentCard(
                                    equipment.title,
                                    equipment.thumbnail,
                                    equipment.description,
                                    equipment.link,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                    : Container(
                      margin: EdgeInsets.only(top: media.height / 2.8),
                      child: Container(
                        width: media.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ScreenUtil.horizontalScale(15)),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: media.height / 19, right: 20, left:20),
                          child: const SizedBox(
                            height: 100,
                          )
                        ),
                      ),
                    );
                }),                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.black54),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(maxWidth: media.width / 1.4),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}