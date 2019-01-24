import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocationInputState();
  }
}

class LocationInputState extends State<StatefulWidget> {
  final FocusNode _addressInput = FocusNode();
  Uri _staticMapUri;

  @override
  void initState() {
    _addressInput.addListener(_updateLocation);
    this.getStaticMap();
    super.initState();
  }

  @override
  void dispose() {
    //stop always listening, this will make sure to only listen for address change if the location widget is loaded
    this._addressInput.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap() {
    final StaticMapProvider staticMapProvider =
        StaticMapProvider('AIzaSyDp2Ed2RgWYzpfut750mb8DITmyo0afw9g');
    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', 41.40338, 2.17403)],
        center: Location(41.40338, 2.17403),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);

    setState(() {
      this._staticMapUri = staticMapUri;
    });
  }

  void _updateLocation() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInput,
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.network(this._staticMapUri.toString())
      ],
    );
  }
}
