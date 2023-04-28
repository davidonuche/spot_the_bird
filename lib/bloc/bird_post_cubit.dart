import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spot_the_bird/models/bird_model.dart';
import 'package:equatable/equatable.dart';
import 'package:spot_the_bird/services/database_helper.dart';
part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(BirdPostState(
          birdPosts: [],
          status: BirdPostStatus.initial,
        ));
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> getPosts() async {
    try {
      List<BirdModel> birdPosts = [];
      final List<Map<String, dynamic>> allRows = await _dbHelper.QueryAllRows();
      if (allRows.isEmpty) {
        print("Rows are empty");
      } else {
        print("Rows have data");
        for (Map<String, dynamic> row in allRows) {
          //final File imageFile = File.fromRawPath(row[DatabaseHelper.picture]);
          final Directory directory = await getApplicationDocumentsDirectory();
          final String path = "${directory.path}/${row["id"]}.png";
          final File imageFile = File(path);
          imageFile.writeAsBytes(row[DatabaseHelper.picture]);
          birdPosts.add(
            BirdModel(
              birdName: row[DatabaseHelper.birdName],
              birdDescription: row[DatabaseHelper.birdDescription],
              latitude: row[DatabaseHelper.latitude],
              longtitude: row[DatabaseHelper.longitude],
              id: row["id"],
              image: imageFile,
            ),
          );
        }
      }

      emit(
          state.copyWith(birdPosts: birdPosts, status: BirdPostStatus.loading));
    } catch (_) {
      emit(state.copyWith(status: BirdPostStatus.error));
    }
  }

  Future<void> addBirdPost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));
    // Convert file to Uint8List
    Uint8List bytes = birdModel.image.readAsBytesSync();
    Map<String, dynamic> row = {
      DatabaseHelper.birdName: birdModel.birdName,
      DatabaseHelper.birdDescription: birdModel.birdDescription,
      DatabaseHelper.picture: bytes,
      DatabaseHelper.latitude: birdModel.latitude,
      DatabaseHelper.longitude: birdModel.longtitude,
    };
    final id = await _dbHelper.insert(row);
    birdModel.id = id;
    List<BirdModel> posts = [];
    posts.addAll(state.birdPosts);
    posts.add(birdModel);
    emit(state.copyWith(birdPosts: posts, status: BirdPostStatus.postAdded));
  }

  Future<void> deletePost(BirdModel birdModel) async {
    emit(state.copyWith(status: BirdPostStatus.loading));
    List<BirdModel> posts = List.from(state.birdPosts, growable: true);
    posts.remove(birdModel);
    _dbHelper.delete(birdModel.id!);
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
