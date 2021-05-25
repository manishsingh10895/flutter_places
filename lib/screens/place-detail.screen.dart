import 'package:flutter/material.dart';
import 'package:greatplaces/models/place.model.dart';
import 'package:greatplaces/providers/places.provider.dart';
import 'package:greatplaces/screens/map.screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = "/place/detail";
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    var size = MediaQuery.of(context).size;
    final place =
        Provider.of<PlacesProvider>(context, listen: false).findById(id);

    if (place == null) {
      Container(
        child: Center(
          child: Text("No such place found"),
        ),
      );
    }
    Place p = place!;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.title.toUpperCase()),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 10.0,
                  spreadRadius: 1,
                  color: Colors.black38,
                )
              ],
            ),
            height: size.height * 0.6,
            width: double.infinity,
            child: Image.file(
              p.image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 15.0,
            ),
            child: Text(
              place.location.address ?? "",
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => MapScreen(
                    initialLocation: place.location,
                    isSelecting: false,
                  ),
                ),
              );
            },
            child: Text("View on Map"),
          )
        ],
      ),
    );
  }
}
