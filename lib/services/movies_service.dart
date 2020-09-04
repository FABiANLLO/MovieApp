import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/Models/constant.dart';
import 'package:movieapp/Models/movie.dart';

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
}
