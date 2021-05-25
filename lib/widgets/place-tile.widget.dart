import 'package:flutter/material.dart';
import 'package:greatplaces/models/place.model.dart';
import 'package:greatplaces/screens/place-detail.screen.dart';

class PlaceTile extends StatefulWidget {
  final Place place;

  PlaceTile({required this.place});

  @override
  _PlaceTileState createState() => _PlaceTileState();
}

class _PlaceTileState extends State<PlaceTile> {
  bool trim = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.place.location.address != null) {
      trim = widget.place.location.address!.length > 50;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var place = widget.place;
    var add = place.location.address;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: FileImage(place.image),
      ),
      title: Text(place.title),
      subtitle: Text(
        add == null
            ? ""
            : trim
                ? "${add.substring(0, 50)}..."
                : add,
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(PlaceDetailScreen.routeName, arguments: place.id);
      },
      onLongPress: () {
        setState(() {
          trim = !trim;
        });
      },
    );
  }
}
