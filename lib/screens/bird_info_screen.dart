import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/models/bird_model.dart';
import '../bloc/bird_post_cubit.dart';

class BirdInfoScreen extends StatelessWidget {
  static const String routeName = "/bird_info_screen";
  // final BirdModel birdModel;
  // const BirdInfoScreen({required this.birdModel, super.key});

  @override
  Widget build(BuildContext context) {
    final BirdModel birdModel =
        ModalRoute.of(context)!.settings.arguments as BirdModel;
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
            child: Text(
              birdModel.birdName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: Text(
              birdModel.birdDescription,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BirdPostCubit>().deletePost(birdModel);
              Navigator.of(context).pop();
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
