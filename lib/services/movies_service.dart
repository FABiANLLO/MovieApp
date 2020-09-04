import 'package:http/http.dart' as http;
import 'package:movieapp/Models/constant.dart';
import 'package:movieapp/Models/movie.dart';

class MovieService {
  Future<void> fectRestMovie(String movieId) async {
    final String url = Constant.movieUrl.replaceFirst('{movieId}', movieId);
    var movie;
    await http.get(url).then((response) {
      movie = movieFromJson(response.body);
    });
    print('### ${movie.title}');
    return movie;
  }
}
