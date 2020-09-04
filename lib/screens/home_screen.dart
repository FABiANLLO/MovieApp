import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movieapp/Models/movie.dart';
import 'package:movieapp/screens/movie_detail.dart';
import 'package:movieapp/services/basic_crud.dart';
import 'package:movieapp/services/movies_service.dart';
import 'package:movieapp/widgets/vote_average.dart';
import 'package:provider/provider.dart';
import 'package:movieapp/Models/constant.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  // void initState() {
  //   final basicCrud = BasicCrud();
  //   // basicCrud.addDocument();
  //   // basicCrud.addDocument();

  //   final movieService = MovieService();
  //   // movieService.fetchRestMovie('128');
  //   movieService.addAllMovies();
  //   super.initState();
  // }

  final _movieService = MovieService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _movieTitleController = TextEditingController();
  String _tempMovieTitle;
  bool _isAddMovieIconTapped = false;

  Future<void> _addMovie() async {
    if (_isAddMovieIconTapped) {
      return null;
    } else {
      _isAddMovieIconTapped = true;
      await _movieService.addMovie();
      _isAddMovieIconTapped = false;
    }
  }

  Future<bool> _deleteOrUpMovie(
      BuildContext context, DismissDirection direction, Movie movie) async {
    if (direction == DismissDirection.endToStart) {
      final deleteMovie = movie;
      final snackBar = SnackBar(
        content: Text('Movie Deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              _movieService.addFirestoreMovie(deleteMovie);
            }),
      );
      _movieService.deleteFirestoreMovie(movie.id.toString());
      _scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else if (direction == DismissDirection.startToEnd) {
      _movieTitleController.text = movie.title;
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                Constant.editmovieTitle,
                style: Theme.of(context).textTheme.headline5,
              ),
              content: TextField(
                controller: _movieTitleController,
                onChanged: (value) {
                  setState(() {
                    _tempMovieTitle = value;
                  });
                },
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _movieTitleController.text = movie.title;
                  },
                ),
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    setState(() {
                      _movieService.updateMovieTitle(
                          movie.id.toString(), _tempMovieTitle);
                    });
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            ),
          ) ??
          false;
    }
  }

  Widget _buildMoviesList(List<Movie> movies) {
    if (movies.length == 0) {
      return Center(
        child: Text(Constant.noMoviesMsg),
      );
    }
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.white,
        height: 0.1,
      ),
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        final movie = movies[index];
        return Dismissible(
          background: Container(
            alignment: AlignmentDirectional.centerStart,
            padding: EdgeInsets.only(left: 20.0),
            color: Colors.green,
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: EdgeInsets.only(right: 20.0),
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          key: Key(movie.id.toString()),
          confirmDismiss: (direction) {
            return _deleteOrUpMovie(context, direction, movie);
          },
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(2.0),
              child: Image.network(
                Constant.posterImagePrefix + movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              movie.title,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              movie.releaseDate.year.toString(),
              style: TextStyle(color: Colors.white),
            ),
            trailing: VoteAverage(raiting: movie.voteAverage),
            onTap: () {
              print(movie.title);
              Navigator.pushNamed(context, MovieDetail.routeName,
                  arguments: movie);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<List<Movie>>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Constant.appName),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_photo_alternate), onPressed: _addMovie)
        ],
      ),
      body: movies == null
          ? Center(child: CircularProgressIndicator())
          : _buildMoviesList(movies),
    );
  }
}
