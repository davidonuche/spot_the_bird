part of 'bird_post_cubit.dart';



enum BirdPostStatus { initial, error, loading, postAdded}

class BirdPostState extends Equatable {

  final List<BirdModel> birdPosts;
  final BirdPostStatus status;

  BirdPostState({required this.birdPosts, required this.status});
  @override
  List<Object?> get props => [birdPosts, status];
  BirdPostState copyWith({
    List<BirdModel>? birdPosts,
    BirdPostStatus? status,
  }) {
    return BirdPostState(
      birdPosts: birdPosts ?? this.birdPosts,
      status: status ?? this.status,
    );
  }
}