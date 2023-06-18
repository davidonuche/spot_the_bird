import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/bird_info_screen.dart';
import 'add_bird_screen.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});
  final MapController _mapController = MapController();
  Future<void> _getImageAndCreatePost({
    required BuildContext context,
    required LatLng latLng,
  }) async {
    File? image;
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 40);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      Navigator.of(context).pushNamed(AddBirdScreen.routeName, arguments: {
        "LatLng" : latLng,
        "image" : image,
      });
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => AddBirdScreen(
      //       image: image!,
      //       latLng: latLng,
      //     ),
      //   ),
      // );
    } else {
      print("No image selected");
    }
    // Pick Image
    // Go to add bird screen
  }

  @override
  Widget build(BuildContext context) {
    void Function()? onMapReady;
    return Scaffold(
        body: BlocConsumer<BirdPostCubit, BirdPostState>(
          listener: (prevState, currState) {
            if (currState.status == BirdPostStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  content: const Text(
                      "Error has occured while doing operations with bird posts"),
                ),
              );
            }
          },
          buildWhen: (prevState, currState) =>
              (prevState.status != currState.status),
          builder: (context, BirdPostState) => FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                onLongPress: (position, latLng) {
                  // Picks image and goes to add bird screen where we create bird post
                  _getImageAndCreatePost(context: context, latLng: latLng);
                },
                center: LatLng(0, 0),
                zoom: 15,
                maxZoom: 17,
                minZoom: 3.5,
                onMapReady: onMapReady),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                retinaMode: true,
              ),
              MarkerLayer(
                markers: BirdPostState.birdPosts
                    .map(
                      (post) => Marker(
                        width: 55,
                        height: 55,
                        point: LatLng(post.latitude, post.longtitude),
                        builder: (context) => GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(BirdInfoScreen.routeName, arguments: post),
                          child: Image.asset("assets/bird_icon.png"),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.navigation_rounded),
          onPressed: () {
            BlocProvider.of<LocationCubit>(context).getLocation();
          },
        ));
  }
}
