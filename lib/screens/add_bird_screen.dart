import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

class AddBirdScreen extends StatefulWidget {
  final File image;
  final LatLng latLng;
  AddBirdScreen({required this.image, required this.latLng});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  String? name;
  String? description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Bird"),
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).padding.top,
              height: MediaQuery.of(context).size.width / 1.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TextField(
              onChanged: (value) {
                if (value != "") {
                  name = value;
                }
              },
              // decoration: InputDecoration(
              //   hintText: "Name",
              // ),
            ),
            TextField(
              onChanged: (value) {
                if (value != "") {
                  description = value;
                }
              },
              // decoration: InputDecoration(
              //   hintText: "Description",
              // ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO:- Add bird to post
            if (name != null && description != null) {
              name = null;
              description = null;
            }
            // TODO:- Pop the screen
          },
          child: Icon(Icons.add),
        ));
  }
}
