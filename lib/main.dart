import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movieapp/screens/home_screen.dart';
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
          theme: ThemeData(primarySwatch: Colors.brown),
          home: HomeScreen(),
        ));
  }
}
