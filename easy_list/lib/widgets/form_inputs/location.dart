import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'dart:convert';//JSON to dart maps

import 'package:http/http.dart' as http;

import '../../models/location_data.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;

  LocationInput(this.setLocation);

  @override
  State<StatefulWidget> createState() {
    return LocationInputState();
  }
}

class LocationInputState extends State<LocationInput> {
  final FocusNode _addressInput = FocusNode();
  Uri _staticMapUri;
  final TextEditingController _addressInputController = TextEditingController();
  LocationData _locationData;

  @override
  void initState() {
    _addressInput.addListener(_updateLocation);
    super.initState();
  }

  @override
  void dispose() {
    //stop always listening, this will make sure to only listen for address change if the location widget is loaded
    this._addressInput.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    if(address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }

    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {'address': address, 'key': 'AIzaSyDp2Ed2RgWYzpfut750mb8DITmyo0afw9g'});
    final http.Response res = await http.get(uri);
    final decodedRes = json.decode(res.body);

    final formattedAddr = decodedRes['results'][0]['formatted_address'];
    final coords = decodedRes['results'][0]['geometry']['location'];
    _locationData = LocationData(address: formattedAddr, lat: coords['lat'], lng: coords['lng']);


    final StaticMapProvider staticMapProvider =
        StaticMapProvider('AIzaSyDp2Ed2RgWYzpfut750mb8DITmyo0afw9g');
    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', _locationData.lat, _locationData.lng)],
        center: Location(_locationData.lat, _locationData.lng),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);

    widget.setLocation(_locationData);
    setState(() {
      _addressInputController.text = _locationData.address;
      this._staticMapUri = staticMapUri;
    });
  }

  void _updateLocation() {
    if(!_addressInput.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInput,
          controller: _addressInputController,
          validator: (String value) {
            if(_locationData == null || value.isEmpty) {
              return 'No valid location found.';
            }
          },
          decoration: InputDecoration(labelText: "Address"),
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.network(this._staticMapUri.toString())
      ],
    );
  }
}
