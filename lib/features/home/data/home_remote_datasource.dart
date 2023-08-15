import 'package:dio/dio.dart';
import 'package:sportsbet_flutter_assignment/features/home/data/models/movie.dart';

import '../../../core/error/custom_exception.dart';

abstract class HomeRemoteDatasource {
  Future<List<Movie>> getLatestMovies(int page);
  Future<List<Movie>> getPopularMovies(int page);
  Future<List<Movie>> getTopRatedMovies(int page);
  Future<List<Movie>> getUpcomingMovies(int page);
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final Dio dio;

  HomeRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<Movie>> getLatestMovies(int page) async {
    final path = '/movie/now_playing?page=$page';
    try {
      final response = await dio.get(
        path,
      );
      final data = response.data as Map<String, dynamic>;
      return data['results']
          .map<Movie>((e) => Movie.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Error getting latest movies');
    }
  }

  @override
  Future<List<Movie>> getPopularMovies(int page) async {
    final path = '/movie/popular?page=$page';
    try {
      final response = await dio.get(
        path,
      );
      final data = response.data as Map<String, dynamic>;
      return data['results']
          .map<Movie>((e) => Movie.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Error getting popular movies');
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies(int page) async {
    final path = '/movie/top_rated?page=$page';
    try {
      final response = await dio.get(
        path,
      );
      final data = response.data as Map<String, dynamic>;
      return data['results']
          .map<Movie>((e) => Movie.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Error getting top rated movies');
    }
  }

  @override
  Future<List<Movie>> getUpcomingMovies(int page) async {
    final path = '/movie/upcoming?page=$page';
    try {
      final response = await dio.get(
        path,
      );
      final data = response.data as Map<String, dynamic>;
      return data['results']
          .map<Movie>((e) => Movie.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Error getting upcoming movies');
    }
  }
}
