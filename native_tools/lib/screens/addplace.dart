import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:native_tools/models/place.dart';
import 'package:native_tools/providers/userdata.dart';
import 'package:native_tools/widgets/image.dart';
import 'package:native_tools/widgets/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.selectedLocation});
  final Placelocation? selectedLocation;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Placelocation? _pickedLocation;
  LatLng? _selectedLatLng;

  @override
  void initState() {
    super.initState();
    if (widget.selectedLocation != null) {
      _pickedLocation = widget.selectedLocation;
      _selectedLatLng = LatLng(
          widget.selectedLocation!.latitude, widget.selectedLocation!.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedLatLng ?? const LatLng(37.7749, -122.4194),
          zoom: 16,
        ),
        onTap: (position) async {
          final address = await _getAddress(position.latitude, position.longitude);
          setState(() {
            _pickedLocation = Placelocation(
              latitude: position.latitude,
              longitude: position.longitude,
              address: address,
            );
            _selectedLatLng = position;
          });
        },
        markers: (_selectedLatLng == null || _pickedLocation == null)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _selectedLatLng!,
                  infoWindow: InfoWindow(title: _pickedLocation!.address),
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
                    child: const Text('Select Location'),
                  ),
                ],
              ),
            ),
    );
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
}

class Addplace extends ConsumerStatefulWidget {
  const Addplace({super.key});

  @override
  ConsumerState<Addplace> createState() => _AddplaceState();
}

class _AddplaceState extends ConsumerState<Addplace> {
  Placelocation? _pickedLocation;
  final _titleController = TextEditingController();
  File? _pickedImage;

  void _savePlace() {
    final enteredTitle = _titleController.text;
    if (enteredTitle.isEmpty || _pickedImage == null || _pickedLocation == null) {
      return;
    }
    ref
        .read(userdataprovider.notifier)
        .addplace(enteredTitle, _pickedImage!, _pickedLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectonmap() async {
    final pickedlocation = await Navigator.of(context).push<Placelocation>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          selectedLocation: _pickedLocation,
        ),
      ),
    );
    if (pickedlocation == null) {
      return;
    }

    setState(() {
      _pickedLocation = pickedlocation;
    });
  }

  void _onSelectImage(File image) {
    _pickedImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new place')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text('Title'),
                hintText: 'Enter a title',
              ),
              maxLength: 100,
              textInputAction: TextInputAction.next,
              controller: _titleController,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 10),
            Imageinput(
              onSelectImage: _onSelectImage,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: LocationInput(
                    pickedLocation: _pickedLocation,
                  ),
                ),
                IconButton(
                  onPressed: _selectonmap,
                  icon: const Icon(Icons.map),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add_location),
              label: const Text('Add Place'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
