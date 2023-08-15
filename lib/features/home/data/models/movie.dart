class Movie {
  int id;
  String title;
  String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title'] as String,
      posterPath: map['poster_path'] as String,
    );
  }
}
