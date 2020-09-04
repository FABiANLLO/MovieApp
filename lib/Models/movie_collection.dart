class MovieCollection {
  MovieCollection({
    this.id,
    this.name,
    this.posterPath,
    this.backdropPath,
  });

  int id;
  String name;
  String posterPath;
  String backdropPath;

  factory MovieCollection.fromJson(Map<String, dynamic> json) =>
      MovieCollection(
        id: json["id"],
        name: json["name"],
        posterPath: json["poster_path"],
        backdropPath: json["backdrop_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "poster_path": posterPath,
        "backdrop_path": backdropPath,
      };
}
