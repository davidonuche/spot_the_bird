import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/models/bird_model.dart';

class AddBirdScreen extends StatefulWidget {
  static const String routeName = "/add_bird_screen";
  // final File image;
  // final LatLng latLng;
  // AddBirdScreen({required this.image, required this.latLng});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  final _formKey = GlobalKey<FormState>();
  late final FocusNode _descriptionFocusNode;
  String? name;
  String? description;
  void _submit(BuildContext context, LatLng latLng, File image) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    context.read<BirdPostCubit>().addBirdPost(
          BirdModel(
            birdName: name!,
            birdDescription: description!,
            latitude: latLng.latitude,
            longtitude: latLng.longitude,
            image: image,
          ),
        );

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final LatLng latLng = args["latLng"] as LatLng;
    final File image = args["image"] as File;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Bird"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).padding.top,
                height: MediaQuery.of(context).size.width / 1.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Bird Name...",
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  if (value.length < 2) {
                    return "Enter longer name...";
                  }
                  return null;
                },
              ),
              TextFormField(
                focusNode: _descriptionFocusNode,
                decoration: InputDecoration(
                  hintText: "Add Bird Description...",
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(context, latLng, image),
                onSaved: (value) {
                  description = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  if (value.length < 2) {
                    return "Enter longer name...";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _submit(context, latLng, image),
      ),
    );
  }
}
