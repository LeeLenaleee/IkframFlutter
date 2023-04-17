import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:places_app/widgets/map_preview.dart';

class MapScreen extends StatelessWidget {
  static const routeName = '/map';
  final LatLng _latLng;
  final String _title;

  MapScreen(this._title, this._latLng);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: MapPreview(_latLng),
    );
  }
}
