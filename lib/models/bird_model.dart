import 'dart:io';

class BirdModel {
  String birdName;
  String birdDescription;
  double latitude;
  double longtitude;
  File image;
  /// Id of the bird post to be used in SQL Table.
  int? id;

  BirdModel({
    required this.birdName,
    required this.birdDescription,
    required this.latitude,
    required this.longtitude,
    required this.image,
    this.id,
  });
}
