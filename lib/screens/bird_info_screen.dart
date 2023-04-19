import 'package:flutter/material.dart';
import 'package:spot_the_bird/models/bird_model.dart';

class BirdInfoScreen extends StatelessWidget {
  final BirdModel birdModel;
  const BirdInfoScreen({required this.birdModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(birdModel.birdName),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.4,
            child: Image.file(
              birdModel.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(birdModel.birdName, style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: Text(birdModel.birdDescription, style: Theme.of(context).textTheme.headlineSmall,),
          ),
          ElevatedButton(onPressed: null, child: Text("Delete"))
        ],
      ),
    );
  }
}
