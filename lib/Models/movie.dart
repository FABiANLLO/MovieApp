import 'dart:convert';
import 'package:movieapp/Models/genre.dart';
import 'package:movieapp/Models/movie_collection.dart';
import 'package:movieapp/Models/production_country.dart';

Movie movieFromJson(String str) => Movie.fromJson(json.decode(str));

String movieToJson(Movie data) => json.encode(data.toJson());

class Movie {
  Movie({
    this.id,
    this.voteAverage,
    this.title,
    this.overview,
    this.adult,
    this.movieCollection,
    this.genres,
    this.releaseDate,
    this.productionCountries,
    this.posterPath,
    this.backdropPath,
  });

  int id;
  double voteAverage;
  String title;
  String overview;
  bool adult;
  MovieCollection movieCollection;
  List<Genre> genres;
  DateTime releaseDate;
  List<ProductionCountry> productionCountries;
  String posterPath;
  String backdropPath;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"],
        voteAverage: json["vote_average"].toDouble(),
        title: json["title"],
        overview: json["overview"],
        adult: json["adult"],
        movieCollection: json["belongs_to_collection"] == null
            ? null
            : MovieCollection.fromJson(json["belongs_to_collection"]),
        genres: List<Genre>.from(
            json["genres"].map((genre) => Genre.fromJson(genre))),
        releaseDate: DateTime.parse(json["release_date"]),
        productionCountries: List<ProductionCountry>.from(
            json["production_countries"]
                .map((country) => ProductionCountry.fromJson(country))),
        posterPath: json["poster_path"],
        backdropPath: json["backdrop_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vote_average": voteAverage,
        "title": title,
        "overview": overview,
        "adult": adult,
        "movie_collection": movieCollection.toJson(),
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "production_countries":
            List<dynamic>.from(productionCountries.map((x) => x.toJson())),
        "poster_path": posterPath,
        "backdrop_path": backdropPath,
      };
}
