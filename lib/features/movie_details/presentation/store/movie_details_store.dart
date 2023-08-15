import 'package:flutter/material.dart';
import 'package:sportsbet_flutter_assignment/features/movie_details/data/movie_details_repository.dart';

import 'movie_details_state.dart';

class MovieDetailsStore extends ValueNotifier<MovieDetailsState> {
  final MovieDetailsRepository repository;

  MovieDetailsStore({required this.repository})
      : super(
          MovieDetailsState(
            status: MovieDetailsStatus.initial,
            movie: null,
          ),
        );

  Future<void> getMovieDetails(int movieId) async {
    value = value.copyWith(status: MovieDetailsStatus.loading);
    final movieDetailsEither = await repository.getMovieDetails(movieId);

    movieDetailsEither.fold((failure) {
      value = value.copyWith(status: MovieDetailsStatus.error);
    }, (movieDetails) {
      value = value.copyWith(
        status: MovieDetailsStatus.success,
        movie: movieDetails,
      );
    });
  }
}
