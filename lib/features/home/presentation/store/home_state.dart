import 'package:sportsbet_flutter_assignment/features/home/presentation/store/home_section.dart';

enum HomeStatus {
  initial,
  loadingLatestMovies,
  loadedLatestMovies,
  loadingPopularMovies,
  loadedPopularMovies,
  loadingTopRatedMovies,
  loadedTopRatedMovies,
  loadingUpcomingMovies,
  loadedUpcomingMovies,
  error,
}

class HomeState {
  final HomeStatus status;
  List<HomeSection> sections;

  HomeState({
    required this.status,
    this.sections = const [],
  });

  HomeState copyWith({
    HomeStatus? status,
    List<HomeSection>? sections,
  }) {
    return HomeState(
      status: status ?? this.status,
      sections: sections ?? this.sections,
    );
  }
}
