import 'dart:convert';

import 'package:greatplaces/config.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  static String generateLocationPreviewImage(
      {required double lat, required double long}) {
    return '''https://maps.googleapis.com/maps/api/staticmap?$lat,$long&zoom=13&size=600x300&maptype=roadmap
&markers=color:red%7Clabel:C%7C$lat,$long
&key=$MAPS_API_KEY''';
  }

  static Future<String?> getPlaceAddress(double lat, double lng) async {
    var url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$MAPS_API_KEY";

    var response = await http.get(Uri.parse(url));

    var decoded = jsonDecode(response.body)['results'];
    if (decoded.length == 0) {
      return null;
    }
    return decoded[0]['formatted_address'];
  }
}
