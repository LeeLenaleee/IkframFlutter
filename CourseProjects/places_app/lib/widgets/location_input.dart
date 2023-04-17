import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:location/location.dart';
import 'package:places_app/widgets/map_preview.dart';

class LocationInput extends StatefulWidget {
  final Function selectPlace;

  LocationInput(this.selectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng _location;

  Future<void> _getCurrentLocation() async {
    final locData = await Location().getLocation();
    setState(() {
      _location = LatLng(locData.latitude, locData.longitude);
    });

    widget.selectPlace(_location);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          height: 170,
          alignment: Alignment.center,
          width: double.infinity,
          child: _location == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : MapPreview(_location),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Not implemented'),
                  content: Text(
                      'Not implemented since course uses google platform and I cant do it since I dont have a credit card, implementing it with leaflet is out of scope of course.'),
                  actions: [
                    FlatButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Okay'),
                    )
                  ],
                ),
              ),
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
