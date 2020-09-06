import 'package:flutter/material.dart';
import 'package:movieapp/Models/constant.dart';
import 'package:movieapp/Models/movie.dart';
import 'package:movieapp/widgets/country_map.dart';
import 'package:movieapp/widgets/vote_average.dart';

class MovieDetail extends StatelessWidget {
  static const routeName = '/movie_detail.dart';

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context).settings.arguments as Movie;
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                FadeInImage.assetNetwork(
                    placeholder: Constant.loadingImage,
                    image: Constant.backdropImagePrefix + movie.backdropPath),
                Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Row(
                        children: [
                          Text(
                            movie.releaseDate.year.toString(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          VoteAverage(raiting: movie.voteAverage)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.0),
                    child: Image.network(
                      Constant.posterImagePrefix + movie.posterPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Text(
                    movie.overview,
                    style: TextStyle(color: Colors.white),
                  ))
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300.0,
              child: CountryMap(
                  latitude: movie.latLng.latitude,
                  longitude: movie.latLng.longitude,
                  countryName: movie.productionCountries.first.name),
            )
          ],
        ),
      ),
    );
  }
}
