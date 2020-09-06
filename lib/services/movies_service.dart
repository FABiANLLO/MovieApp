import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/Models/constant.dart';
import 'package:movieapp/Models/movie.dart';
import 'dart:convert';

class MovieService {
  final _db = FirebaseFirestore.instance;

  /// Fetch a movie from TMDB REST
  Future<Movie> fetchRestMovie(String movieId) async {
    final String url = Constant.movieUrl.replaceFirst('{movieId}', movieId);
    var movie;
    await http.get(url).then((response) {
      movie = movieFromJson(response.body);
    });
    print('### ${movie.title}');
    return movie;
  }

  /// Add a movie to Firestore
  Future<void> addFirestoreMovie(Movie movie) async {
    _db.collection('movies').doc(movie.id.toString()).set(movie.toJson());
  }

  /// Add all movies from the movieIds array
  Future<List<Movie>> addAllMovies() async {
    final movies = List<Movie>();
    for (String movieId in Constant.movieIds) {
      final movie = await fetchRestMovie(movieId);
      movie.latLng =
          await fetchLatLng(movie.productionCountries.first.iso31661);
      movies.add(movie);
      await addFirestoreMovie(movie);
    }
    return movies;
  }

  /// Get all movies saved in Firestore as Stream
  /// to use them with StreamProvider
  Stream<List<Movie>> fetchAllMovies() {
    final movies = _db
        .collection('movies')
        .orderBy('release_date', descending: true)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((e) => Movie.fromJson(e.data())).toList());
    return movies;
  }

  /// Delete a movie from Firestore
  Future<void> deleteFirestoreMovie(String movieId) async {
    return _db.collection('movies').doc(movieId).delete();
  }

  /// Update in Firestore the movie's title
  Future<void> updateMovieTitle(String movieId, String movieTitle) async {
    return await _db
        .collection('movies')
        .doc(movieId)
        .update({'title': movieTitle});
  }

  /// Add a movie from the movieIdsToAdd array to Firestore
  Future<void> addMovie() async {
    if (Constant.movieIdsToAdd.length > 0) {
      final movie = await fetchRestMovie(Constant.movieIdsToAdd[0]);
      movie.latLng =
          await fetchLatLng(movie.productionCountries.first.iso31661);
      await addFirestoreMovie(movie);
      Constant.movieIdsToAdd.removeAt(0);
    } else {
      print('There are no movies to add');
    }
  }

  Future<GeoPoint> fetchLatLng(String countryCode) async {
    GeoPoint geoPoint;
    await http
        .get(Constant.countryCodeUrl.replaceFirst('{code}', countryCode))
        .then((response) {
      final latLng = json.decode(response.body)['latlng'];
      double latitude = latLng[0];
      double longitude = latLng[1];
      geoPoint = GeoPoint(latitude, longitude);
    });
    return geoPoint;
  }
}
