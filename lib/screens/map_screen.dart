import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';

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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddBirdScreen(
            image: image!,
            latLng: latLng,
          ),
        ),
      );
      // Push to add bird screen
    } else {
      print("No image selected");
    }
    // Pick Image
    // Go to add bird screen
  }

  @override
  Widget build(BuildContext context) {
    Function()? onTapp;
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
        listener: (previousState, currentState) {
          if (currentState is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error feching location"),
              ),
            );
          }
          if (currentState is LocationLoaded) {
            onTapp = () => _mapController.move(
                LatLng(currentState.latitude, currentState.longtitude), 15);
          }
        },
        child: FlutterMap(
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
              onMapReady: onTapp!()),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              retinaMode: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.navigation_rounded),
        onPressed: () {
          BlocProvider.of<LocationCubit>(context).getLocation();
        },
      ),
    );
  }
}
