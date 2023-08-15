import 'package:dartz/dartz.dart';
import 'package:sportsbet_flutter_assignment/features/home/data/home_remote_datasource.dart';
import 'package:sportsbet_flutter_assignment/features/home/data/models/movie.dart';

import '../../../core/error/custom_exception.dart';
import '../../../core/error/failure.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Movie>>> getLatestMovies(int page);
  Future<Either<Failure, List<Movie>>> getPopularMovies(int page);
  Future<Either<Failure, List<Movie>>> getTopRatedMovies(int page);
  Future<Either<Failure, List<Movie>>> getUpcomingMovies(int page);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource datasource;

  HomeRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<Failure, List<Movie>>> getLatestMovies(int page) async {
    try {
      final response = await datasource.getLatestMovies(page);
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies(int page) async {
    try {
      final response = await datasource.getPopularMovies(page);
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies(int page) async {
    try {
      final response = await datasource.getTopRatedMovies(page);
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies(int page) async {
    try {
      final response = await datasource.getUpcomingMovies(page);
      return Right(response);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    }
  }
}
