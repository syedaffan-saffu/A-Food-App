import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/cart/confirmorder.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class PickLocationPage extends StatefulWidget {
  final bool? alreadyprov;
  final void Function(GeocodingResult?) onNext;
  const PickLocationPage({super.key, this.alreadyprov, required this.onNext});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  bool? _alreadyprov;
  @override
  void initState() {
    _alreadyprov = widget.alreadyprov ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context);
    return MapLocationPicker(
      backButton: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.navigate_before)),
      apiKey: "AIzaSyDXz9bDkCGq73qfM82scwShez6YmFmiFI0",
      currentLatLng: _alreadyprov!
          ? LatLng(double.parse(provider.data.last),
              double.parse(provider.data.last))
          : const LatLng(25.404569, 68.356226),
      popOnNextButtonTaped: true,
      onNext: widget.onNext,
    );
  }
}
