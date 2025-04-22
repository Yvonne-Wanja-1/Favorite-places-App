import 'package:flutter/material.dart';
import 'package:native_tools/models/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, this.pickedLocation});
  final Placelocation? pickedLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: widget.pickedLocation == null
          ? const Text('No location chosen')
          : Text(widget.pickedLocation!.address),
    );
  }
}
