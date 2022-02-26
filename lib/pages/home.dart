import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {

  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

  }

class _HomeState extends State<Home> {
  final LatLng initialCamPosition = const LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  final Location _location = Location();
  final List<Marker> _markers = <Marker>[];
  late double lat;
  late double long;
  late double time;
  dynamic loc;
  String data = '';

  void _onMapCreated(GoogleMapController _cntlr) {
    //Assigning a GoogleMapController
    _controller = _cntlr;

    //Listening for changes in the controller using a LocationData variable
    _location.onLocationChanged.listen((l) {
      _markers.add(Marker(
          markerId: const MarkerId('SomeId'),
          position: LatLng(l.latitude as double, l.longitude as double),
          infoWindow: InfoWindow(
              title:
                  'Lat: ${l.latitude as double}, Long ${l.longitude as double}')));
      //Saving the current location and time data as double variables
      lat = l.latitude as double;
      long = l.longitude as double;
      time = l.time as double;
      loc = {'Latitude':'${lat}','Longitude':'${long}', 'Time':'${time}'};
      //Animating the map controller's camera to point at the user's current location
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: getLatLong(l), zoom: 15),
        ),
      );
    data = getLocationData(l).toString();
    });


  }

  /// Getter function for the latitude and longitude based on the current location data
  /// @param l - the location data that contains the latitude and longitude of a specific location
  LatLng getLatLong(LocationData l) {
    LatLng newLatLong = LatLng(l.latitude as double, l.longitude as double);
    return newLatLong;
  }

  Future<String> get _localPath async{
    var dir = await getExternalStorageDirectory();

    return dir!.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;

    return File('$path/test.txt');
  }

  Future<File> writeData(String msg) async{
    final file = await _localFile;

    return file.writeAsString(msg);
  }

  Map getLocationData(LocationData l) {

    lat = l.latitude as double;
    long = l.longitude as double;
    time = l.time as double;

    var details = {'lat': lat,'long': long, 'time': time};

    return details;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Your Current Location',
          style: TextStyle(fontSize: 22, fontFamily: 'Lexend')
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo[600],
      ),
      body: Stack(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 100, top: 50),
          child: GoogleMap(
              initialCameraPosition: CameraPosition(target: initialCamPosition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              markers: Set<Marker>.of(_markers)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data,
          style: TextStyle(fontSize: 14, fontFamily: 'Lexend')),
        ),
    ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/photos');
          writeData(data);
        },
        backgroundColor: Colors.indigo[600],
        tooltip: '${data}',
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat,
    );
  }
}
