class ExerciseDetailModel {
  String? sId;
  String? title;
  String? vimeoId;
  String? thumbnail;
  String? description;
  String? guide;
  List<String>? categories;
  List<UsedEquipments>? usedEquipments;
  List<RelatedExercises>? relatedExercises;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Files>? files;

  ExerciseDetailModel(
      {this.sId,
      this.title,
      this.vimeoId,
      this.thumbnail,
      this.description,
      this.guide,
      this.categories,
      this.usedEquipments,
      this.relatedExercises,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.files});

  ExerciseDetailModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    vimeoId = json['vimeoId'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    guide = json['guide'];
    categories = json['categories'].cast<String>();
    if (json['usedEquipments'] != null) {
      usedEquipments = <UsedEquipments>[];
      json['usedEquipments'].forEach((v) {
        usedEquipments!.add(UsedEquipments.fromJson(v));
      });
    }
    if (json['relatedExercises'] != null) {
      relatedExercises = <RelatedExercises>[];
      json['relatedExercises'].forEach((v) {
        relatedExercises!.add(RelatedExercises.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['vimeoId'] = vimeoId;
    data['thumbnail'] = thumbnail;
    data['description'] = description;
    data['guide'] = guide;
    data['categories'] = categories;
    if (usedEquipments != null) {
      data['usedEquipments'] = usedEquipments!.map((v) => v.toJson()).toList();
    }
    if (relatedExercises != null) {
      data['relatedExercises'] = relatedExercises!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UsedEquipments {
  String? sId;
  String? title;
  String? thumbnail;
  String? description;
  String? link;
  List<String>? collections;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UsedEquipments(
      {this.sId, this.title, this.thumbnail, this.description, this.link, this.collections, this.createdAt, this.updatedAt, this.iV});

  UsedEquipments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    link = json['link'];
    collections = json['collections'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['thumbnail'] = thumbnail;
    data['description'] = description;
    data['link'] = link;
    data['collections'] = collections;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class RelatedExercises {
  String? sId;
  String? title;
  String? vimeoId;
  String? thumbnail;
  String? description;
  List<String>? categories;
  String? guide;
  List<String>? relatedExercises;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<String>? usedEquipments;

  RelatedExercises(
      {this.sId,
      this.title,
      this.vimeoId,
      this.thumbnail,
      this.description,
      this.categories,
      this.guide,
      this.relatedExercises,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.usedEquipments});

  RelatedExercises.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    vimeoId = json['vimeoId'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    categories = json['categories'].cast<String>();
    guide = json['guide'];
    relatedExercises = json['relatedExercises'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    usedEquipments = json['usedEquipments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['vimeoId'] = vimeoId;
    data['thumbnail'] = thumbnail;
    data['description'] = description;
    data['categories'] = categories;
    data['guide'] = guide;
    data['relatedExercises'] = relatedExercises;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['usedEquipments'] = usedEquipments;
    return data;
  }
}

class Files {
  String? quality;
  String? rendition;
  String? type;
  int? width;
  int? height;
  String? link;
  String? createdTime;
  double? fps;
  int? size;
  dynamic md5;
  String? publicName;
  String? sizeShort;

  Files(
      {this.quality,
      this.rendition,
      this.type,
      this.width,
      this.height,
      this.link,
      this.createdTime,
      this.fps,
      this.size,
      this.md5,
      this.publicName,
      this.sizeShort});

  Files.fromJson(Map<String, dynamic> json) {
    quality = json['quality'];
    rendition = json['rendition'];
    type = json['type'];
    width = json["width"];
    height = json["height"];
    link = json['link'];
    createdTime = json['created_time'];
    fps = double.parse(json['fps'].toString());
    size = int.parse(json['size'].toString());
    md5 = json['md5'];
    publicName = json['public_name'];
    sizeShort = json['size_short'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quality'] = quality;
    data['rendition'] = rendition;
    data['type'] = type;
    data['width'] = width;
    data['height'] = height;
    data['link'] = link;
    data['created_time'] = createdTime;
    data['fps'] = fps;
    data['size'] = size;
    data['md5'] = md5;
    data['public_name'] = publicName;
    data['size_short'] = sizeShort;
    return data;
  }
}
