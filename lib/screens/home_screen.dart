import 'package:flutter/material.dart';
import 'package:movieapp/services/basic_crud.dart';
import 'package:movieapp/services/movies_service.dart';

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
    basicCrud.updateDocument();

    final movieService = MovieService();
    movieService.fectRestMovie('228');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
