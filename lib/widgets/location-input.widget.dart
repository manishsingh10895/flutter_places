import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greatplaces/helpers/location.helper.dart';
import 'package:greatplaces/models/place.model.dart';
import 'package:greatplaces/screens/map.screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function(LatLng) onSaveLocation;

  LocationInput({required this.onSaveLocation});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    final location = await Location().getLocation();
    print(location.latitude);
    print(location.longitude);
    final mapImageUrl = LocationHelper.generateLocationPreviewImage(
      lat: location.latitude!,
      long: location.longitude!,
    );
    setState(() {
      _previewImageUrl = mapImageUrl;
    });

    this.widget.onSaveLocation(
          LatLng(
            location.latitude!,
            location.longitude!,
          ),
        );
  }

  Future<void> selectOnMap() async {
    final LatLng? selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    print(selectedLocation.latitude);

    setState(() {
      this._previewImageUrl = LocationHelper.generateLocationPreviewImage(
        lat: selectedLocation.latitude,
        long: selectedLocation.longitude,
      );
    });

    this.widget.onSaveLocation(selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          width: double.infinity,
          child: _previewImageUrl == null
              ? Center(
                  child: Text(
                    "No location chosen",
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                this._getCurrentUserLocation();
              },
              icon: Icon(Icons.location_on),
              label: Text("Current Location"),
            ),
            SizedBox(
              width: 10.0,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                this.selectOnMap();
              },
              icon: Icon(Icons.map),
              label: Text("Select on Map"),
            )
          ],
        )
      ],
    );
  }
}
