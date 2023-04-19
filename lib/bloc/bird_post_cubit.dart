import 'package:bloc/bloc.dart';
import 'package:spot_the_bird/models/bird_model.dart';
import 'package:equatable/equatable.dart';
part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(BirdPostState(
          birdPosts: [],
          status: BirdPostStatus.initial,
        ));
  void addBirdPost(BirdModel birdModel) {
    emit(state.copyWith(status: BirdPostStatus.loading));
    List<BirdModel> posts = [];
    posts.addAll(state.birdPosts);
    posts.add(birdModel);
    emit(state.copyWith(birdPosts: posts, status: BirdPostStatus.postAdded));
  }
}
