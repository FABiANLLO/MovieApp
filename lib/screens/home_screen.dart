import 'package:flutter/material.dart';
import 'package:movieapp/Models/movie.dart';
import 'package:movieapp/services/basic_crud.dart';
import 'package:movieapp/services/movies_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final basicCrud = BasicCrud();
    // basicCrud.addDocument();
    // basicCrud.addDocument();

    final movieService = MovieService();
    // movieService.fetchRestMovie('128');
    movieService.addAllMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<List<Movie>>(context);
    return Container();
  }
}
