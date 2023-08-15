import 'package:dartz/dartz.dart';
import 'package:sportsbet_flutter_assignment/features/movie_details/data/models/detailed_movie.dart';
import 'package:sportsbet_flutter_assignment/features/movie_details/data/movie_details_remote_datasource.dart';

import '../../../core/error/custom_exception.dart';
import '../../../core/error/failure.dart';

abstract class MovieDetailsRepository {
  Future<Either<Failure, DetailedMovie>> getMovieDetails(int movieId);
}

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  final MovieDetailsRemoteDatasource datasource;

  MovieDetailsRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<Failure, DetailedMovie>> getMovieDetails(int movieId) async {
    try {
      final response = await datasource.getMovieDetails(movieId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    }
  }
}
