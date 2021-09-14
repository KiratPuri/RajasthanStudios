class PhotosModelClass {
  List<Photos> photos = [];

  PhotosModelClass();

  PhotosModelClass.fromJson(Map<String, dynamic> json) {

    if (json['photos'] != null) {
      photos = [];
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Photos {
 late int id;
 late String photographer;
 late Src src;
 late bool liked;
 late String photographerurl;

  Photos(
      {required this.id,
       required this.photographer,
       required this.src,
       required this.liked,
       required this.photographerurl});

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photographerurl = json["photographer_url"];
    photographer = json['photographer'];
    src = (json['src'] != null ? new Src.fromJson(json['src']) : null)!;
    liked = json['liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photographer'] = this.photographer;
    if (this.src != null) {
      data['src'] = this.src.toJson();
    }
    data['liked'] = this.liked;
    return data;
  }
}

class Src {
 late String medium;
 late String tiny;

  Src(
      {required this.medium,
       required this.tiny});

  Src.fromJson(Map<String, dynamic> json) {
    medium = json['medium'];
    tiny = json['tiny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medium'] = this.medium;
    data['tiny'] = this.tiny;
    return data;
  }
}