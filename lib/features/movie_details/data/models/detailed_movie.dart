class DetailedMovie {
  int id;
  String title;
  String posterPath;
  String overview;
  String videoName;
  String releaseDate;
  double voteAverage;
  List<String> genres;

  DetailedMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.videoName,
    required this.releaseDate,
    required this.voteAverage,
    required this.genres,
  });

  factory DetailedMovie.fromMap(Map<String, dynamic> map) {
    return DetailedMovie(
      id: map['id'] as int,
      title: map['title'] as String,
      posterPath: map['poster_path'] as String,
      overview: map['overview'] as String,
      videoName: (map['videos']['results'][0]['name'] ?? ''),
      releaseDate: map['release_date'] as String,
      voteAverage: map['vote_average'] as double,
      genres: (map['genres'] as List).map((e) => e['name'] as String).toList(),
    );
  }
}
