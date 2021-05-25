import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greatplaces/models/place.model.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  MapScreen({
    this.initialLocation = const PlaceLocation(lat: 20.5937, long: 78.9629),
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _selectLocation(LatLng position) {
    setState(() {
      this._pickedLocation = position;
    });
  }

  LatLng? _pickedLocation;

  toLatLng(PlaceLocation loc) {
    return LatLng(loc.lat, loc.long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Map"),
        actions: [
          if (widget.isSelecting && this._pickedLocation != null)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop<LatLng>(_pickedLocation);
              },
              icon: Icon(Icons.check),
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 16,
          target: LatLng(this.widget.initialLocation.lat,
              this.widget.initialLocation.long),
        ),
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: MarkerId("1"),
                  position: this._pickedLocation ??
                      this.toLatLng(
                        this.widget.initialLocation,
                      ),
                ),
              },
        onTap: !widget.isSelecting ? null : _selectLocation,
      ),
    );
  }
}
