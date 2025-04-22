import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:native_tools/models/place.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    super.key,
    Placelocation? initialLocation,
    this.isSelecting = true,
  }) : initialLocation = initialLocation ??
          Placelocation(
            latitude: 37.422,
            longitude: -122.084,
            address: '',
          );

  final Placelocation initialLocation;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLatLng;
  Placelocation? _pickedLocation;

  @override
  void initState() {
    super.initState();
    // Initialize _pickedLocation with initialLocation if not selecting
    if (!widget.isSelecting) {
      _pickedLatLng = LatLng(
        widget.initialLocation.latitude,
        widget.initialLocation.longitude,
      );
      _pickedLocation = widget.initialLocation;
    }
  }

  Future<String> _getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        return 'Address not found';
      }
    } catch (e) {
      return 'Error getting address';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting && _pickedLocation != null)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: widget.isSelecting
            ? (position) async {
                final address =
                    await _getAddress(position.latitude, position.longitude);
                setState(() {
                  _pickedLatLng = position;
                  _pickedLocation = Placelocation(
                    latitude: position.latitude,
                    longitude: position.longitude,
                    address: address,
                  );
                });
              }
            : null,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        markers: (_pickedLatLng == null)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLatLng!,
                ),
              },
      ),
      bottomNavigationBar: _pickedLocation == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Selected Location: ${_pickedLocation!.latitude}, ${_pickedLocation!.longitude}'),
                  Text('Address: ${_pickedLocation!.address}'),
                ],
              ),
            ),
    );
  }
}
