import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movieapp/Models/constant.dart';

class CountryMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String countryName;

  CountryMap({
    @required this.latitude,
    @required this.longitude,
    @required this.countryName,
  });

  @override
  _CountryMapState createState() => _CountryMapState();
}

class _CountryMapState extends State<CountryMap> {
  GoogleMapController _mapController;
  CameraPosition _cameraPosition() {
    return CameraPosition(
        target: LatLng(widget.latitude, widget.longitude), zoom: 4.7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _cameraPosition(),
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
                _mapController.setMapStyle(jsonEncode(Constant.mapStyle));
              },
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Text(widget.countryName,
                  style: Theme.of(context).textTheme.headline6),
            )
          ],
        ),
      ),
    );
  }
}
