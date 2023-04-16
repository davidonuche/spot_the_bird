import 'dart:io';

class BirdModel {
  String birdName;
  String birdDescription;
  double latitude;
  double longtitude;
  File image;

  BirdModel({
    required this.birdName,
    required this.birdDescription,
    required this.latitude,
    required this.longtitude,
    required this.image,
  });
}
