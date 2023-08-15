import 'package:dio/dio.dart';

import '../../../core/error/custom_exception.dart';
import 'models/detailed_movie.dart';

abstract class MovieDetailsRemoteDatasource {
  Future<DetailedMovie> getMovieDetails(int movieId);
}

class MovieDetailsRemoteDatasourceImpl implements MovieDetailsRemoteDatasource {
  final Dio dio;
  MovieDetailsRemoteDatasourceImpl({required this.dio});

  @override
  Future<DetailedMovie> getMovieDetails(int movieId) async {
    final path = '/movie/$movieId?append_to_response=videos';
    try {
      final response = await dio.get(
        path,
      );
      final data = response.data as Map<String, dynamic>;
      return DetailedMovie.fromMap(data);
    } catch (e) {
      throw ServerException(message: 'Error getting movie details');
    }
  }
}
