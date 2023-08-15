import 'package:sportsbet_flutter_assignment/features/movie_details/data/models/detailed_movie.dart';

enum MovieDetailsStatus {
  initial,
  loading,
  success,
  error,
}

class MovieDetailsState {
  final MovieDetailsStatus status;
  final DetailedMovie? movie;

  MovieDetailsState({
    required this.status,
    required this.movie,
  });

  MovieDetailsState copyWith({
    MovieDetailsStatus? status,
    DetailedMovie? movie,
  }) {
    return MovieDetailsState(
      status: status ?? this.status,
      movie: movie ?? this.movie,
    );
  }
}
