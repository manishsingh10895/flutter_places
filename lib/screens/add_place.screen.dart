import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greatplaces/helpers/messenger.helper.dart';
import 'package:greatplaces/models/place.model.dart';
import 'package:greatplaces/providers/places.provider.dart';
import 'package:greatplaces/widgets/image-input.widget.dart';
import 'package:greatplaces/widgets/location-input.widget.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = "/add";
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();

  Place place = Place(
    image: File(""),
    id: "",
    title: "",
    location: PlaceLocation(lat: 0, long: 0),
  );

  void _selectImage(File image) {
    ///Don't need set state as form doesn't need to re render on image change
    // setState(() {
    place = place.copyWith(image: image);
    // });
  }

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      try {
        if (place.location == null) return;
        _formKey.currentState!.save();
        print("saved");

        Provider.of<PlacesProvider>(context, listen: false).addPlace(place);

        Navigator.of(context).pop();
      } catch (e) {
        Messenger.showSimpleMessage(context, "Error");
      }
    } else {
      Messenger.showSimpleMessage(context, "Invalid Values");
    }
  }

  void _onPlaceSelected(LatLng location) {
    place = place.copyWith(
      location: PlaceLocation(
        lat: location.latitude,
        long: location.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new place"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                        onSaved: (value) {
                          place = place.copyWith(title: value);
                        },
                        validator: (value) {
                          return ValidationBuilder()
                              .minLength(3)
                              .build()(value);
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ImageInput(
                        onImageSaved: this._selectImage,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      LocationInput(
                        onSaveLocation: this._onPlaceSelected,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
              elevation: null,
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).accentColor),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              _savePlace();
            },
            icon: Icon(Icons.add),
            label: Text("Add Place"),
          )
        ],
      ),
    );
  }
}
