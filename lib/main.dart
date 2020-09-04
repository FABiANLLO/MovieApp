import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movieapp/screens/home_screen.dart';
import 'package:movieapp/screens/movie_detail.dart';
import 'package:movieapp/services/movies_service.dart';
import 'package:provider/provider.dart';
import 'Models/constant.dart';

bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  TextStyle _buildTextStyle() {
    return TextStyle(color: Colors.white, shadows: <Shadow>[
      Shadow(
        offset: Offset(1.0, 1.0),
        blurRadius: 3.0,
        color: Colors.black,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final _movisService = MovieService();
    return MultiProvider(
        providers: [
          StreamProvider(create: (_) => _movisService.fetchAllMovies())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Constant.appName,
          theme: ThemeData(
              primarySwatch: Colors.amber,
              scaffoldBackgroundColor: Colors.black87,
              textTheme: TextTheme(headline6: _buildTextStyle())),
          home: HomeScreen(),
          routes: {
            MovieDetail.routeName: (_) => MovieDetail(),
          },
        ));
  }
}
