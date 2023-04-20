import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spot_the_bird/models/bird_model.dart';
import 'package:equatable/equatable.dart';
part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(BirdPostState(
          birdPosts: [],
          status: BirdPostStatus.initial,
        ));
  Future<void> getPosts() async {
    try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<BirdModel> birdPosts = [];
    List<String>? birdPostsJsonStringList = prefs.getStringList("birdPosts");
    if (birdPostsJsonStringList != null) {
      for (String postJsonData in birdPostsJsonStringList) {
        final Map<String, dynamic> data =
            jsonDecode(postJsonData) as Map<String, dynamic>;
        final String birdName = data["birdName"] as String;
        final String birdDescription = data["birdDescription"] as String;
        final double latitude = data["latitude"] as double;
        final double longitude = data["longtitude"] as double;
        // Retriving file image
        final String path = data["filePath"] as String;
        final File imageFile = File(path);
        birdPosts.add(BirdModel(
            birdName: birdName,
            birdDescription: birdDescription,
            latitude: latitude,
            longtitude: longitude,
            image: imageFile));
      }
    
    }
    emit(state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loading));
    } catch (_) {
      emit(state.copyWith(status: BirdPostStatus.error));
    }
  }

  Future<void> addBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));
    List<BirdModel> posts = [];
    posts.addAll(state.birdPosts);
    posts.add(birdModel);
    _saveToSharedPrefs(posts);
    emit(state.copyWith(birdPosts: posts, status: BirdPostStatus.postAdded));
  }

  Future<void> deletePost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));
    List<BirdModel> posts = List.from(state.birdPosts, growable: true);
    posts.remove(birdModel);
    // TODO:- Save data to disk here
    _saveToSharedPrefs(posts);
    emit(state.copyWith(birdPosts: posts, status: BirdPostStatus.postRemoved));
  }

  Future<void> _saveToSharedPrefs(List<BirdModel> posts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> jsonDataList = posts
        .map((post) => json.encode({
              "birdName": post.birdName,
              "birdDescription": post.birdDescription,
              "latitude": post.latitude,
              "longtitude": post.longtitude,
              "filePath": post.image.path,
            }))
        .toList();

    prefs.setStringList("birdPosts", jsonDataList);
  }
}
