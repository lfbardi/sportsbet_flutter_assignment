import '../../data/models/movie.dart';

class HomeSection {
  final String title;
  bool isExpanded;
  int currentPage;
  List<Movie> movies;

  HomeSection({
    required this.title,
    required this.isExpanded,
    required this.currentPage,
    this.movies = const [],
  });

  HomeSection copyWith({
    String? title,
    bool? isExpanded,
    int? currentPage,
    List<Movie>? movies,
  }) {
    return HomeSection(
      title: title ?? this.title,
      isExpanded: isExpanded ?? this.isExpanded,
      currentPage: currentPage ?? this.currentPage,
      movies: movies ?? this.movies,
    );
  }
}
