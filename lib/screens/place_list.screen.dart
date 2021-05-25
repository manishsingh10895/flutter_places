import 'package:flutter/material.dart';
import 'package:greatplaces/providers/places.provider.dart';
import 'package:greatplaces/screens/add_place.screen.dart';
import 'package:greatplaces/widgets/place-tile.widget.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<PlacesProvider>(context, listen: false).fetchPlaces(),
        builder: (ctx, AsyncSnapshot snap) =>
            snap.connectionState == ConnectionState.waiting
                ? Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          // color: Colors.red,
                          strokeWidth: 3.0,
                        )),
                  )
                : Consumer<PlacesProvider>(
                    builder: (ctx, places, child) {
                      if (places.items.length == 0) return child!;

                      return ListView.builder(
                        itemBuilder: (ctx, index) {
                          var place = places.items[index];
                          return PlaceTile(place: place);
                        },
                        itemCount: places.items.length,
                      );
                    },
                    child: Center(
                      child: Text("Got no places yet"),
                    ),
                  ),
      ),
    );
  }
}
