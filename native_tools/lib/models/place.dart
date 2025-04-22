// c:\Users\Administrator\Desktop\native_tools\native_tools\lib\models\place.dart
import 'dart:io';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

/// Represents a geographical location with latitude, longitude, and address.
class Placelocation {
  final double latitude;
  final double longitude;
  final String address;

  Placelocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  }) {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude must be between -90 and 90.');
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude must be between -180 and 180.');
    }
  }
}

/// Represents a place with an ID, title, image, and location.
class Place {
  final String id;
  final String title;
  final File image;
  final Placelocation location;

  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();
}
