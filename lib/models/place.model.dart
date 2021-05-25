import 'dart:io';

class PlaceLocation {
  final double lat;
  final double long;
  final String? address;

  const PlaceLocation({required this.lat, required this.long, this.address});
}

class Place {
  String? id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({
    required this.image,
    this.id,
    required this.title,
    required this.location,
  }) {
    this.id = DateTime.now().toIso8601String();
  }

  Place copyWith(
      {String? title, String? id, File? image, PlaceLocation? location}) {
    return Place(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      location: location ?? this.location,
    );
  }

  static Place fromMap(Map<String, Object?> map) {
    var id = map['id']! as String;
    var imagePath = map['image']! as String;
    var image = File(imagePath);
    var title = map['title'] as String;
    var lat = map['loc_lat'] as double;
    var long = map['loc_lng'] as double;
    var address = map['address'] as String;
    return Place(
      id: id,
      image: image,
      title: title,
      location: PlaceLocation(lat: lat, long: long, address: address),
    );
  }
}
