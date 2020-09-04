import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class VoteAverage extends StatelessWidget {
  final double raiting;
  const VoteAverage({@required this.raiting});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: raiting / 2,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: 20.0,
      unratedColor: Colors.amber.withAlpha(50),
    );
  }
}
