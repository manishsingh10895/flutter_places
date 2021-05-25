import 'package:flutter/foundation.dart';
import 'package:greatplaces/helpers/db.helper.dart';
import 'package:greatplaces/helpers/location.helper.dart';
import 'package:greatplaces/models/place.model.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [...this._items];
  }

  Future fetchPlaces() async {
    final dataList = await DB.getData("places");
    if (dataList == null) return [];
    var places = dataList.map((e) => Place.fromMap(e)).toList();
    this._items = places;
    await Future.delayed(Duration(milliseconds: 1000));
    notifyListeners();
  }

  Place? findById(String id) {
    return this._items.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(Place place) async {
    if (place.location.address == null) {
      var l = place.location;
      var address = await LocationHelper.getPlaceAddress(l.lat, l.long);
      place = place.copyWith(
        location: PlaceLocation(lat: l.lat, long: l.long, address: address),
      );
    }

    this._items.add(place);

    notifyListeners();

    var data = {
      'id': place.id!,
      'title': place.title,
      'image': place.image.path,
      'loc_lat': place.location.lat,
      "loc_lng": place.location.long
    };

    if (place.location.address != null) {
      data['address'] = place.location.address!;
    }

    DB.insert("places", {
      'id': place.id!,
      'title': place.title,
      'image': place.image.path,
      'loc_lat': place.location.lat,
      "loc_lng": place.location.long,
      "address": place.location.address!
    });
  }
}
