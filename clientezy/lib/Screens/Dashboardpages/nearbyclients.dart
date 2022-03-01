import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../../Database/Databasehelper.dart';

class NearbyClients extends StatefulWidget {
  const NearbyClients({Key? key}) : super(key: key);

  @override
  _NearbyClientsState createState() => _NearbyClientsState();
}

class _NearbyClientsState extends State<NearbyClients> {
  int distance = 5;
  bool isgettinglocation = false;
  double lat = 0.0;
  double long = 0.0;
  List<Map> clients = [];
  List<Map> filteredclients = [];
  static Future<void> openMap(double latitude, double longitude) async {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return true;
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      isgettinglocation = true;
    });
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    Position position = await _geolocatorPlatform.getCurrentPosition();

    setState(() {
      lat = position.latitude;
      long = position.longitude;

      isgettinglocation = false;
    });
  }

  Future<void> getdata() async {
    List<Map> list = await DatabaseHelper.instance.fetchdata();
    setState(() {
      clients = list;
    });
    print(clients.length);
    print(list.toString());
    findClientAreaWise(10);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  findClientAreaWise(int dist) {
    setState(() {
      isgettinglocation = true;
    });
    //getdata();
    _getCurrentPosition();
    print(clients.length);
    for (var i = 0; i < clients.length; i++) {
      double endlat = double.parse(clients[i]["lat"]);
      double endlng = double.parse(clients[i]["long"]);
      print("calculatinhg");
      double distanceInMeters =
          Geolocator.distanceBetween(lat * -1, long, endlat * -1, endlng);
      double distanceInMeters2 =
          calculateDistance(lat * -1, long, endlat * -1, endlng);
      print(distanceInMeters);
      print(distanceInMeters2);
      if (distanceInMeters < dist * 1000) {
        filteredclients.add(clients[i]);
      }
    }
    setState(() {
      isgettinglocation = false;
    });
    //double distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
  }

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    //findClientAreaWise(5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: Text("Near By Clients"), actions: [
        Icon(Icons.filter_alt_outlined),
      ]),
      body: isgettinglocation
          ? Center(child: CircularProgressIndicator())
          : filteredclients.length == 0
              ? Center(child: Text("No Nearby Clients Found"))
              : SingleChildScrollView(
                  child: Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: filteredclients.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: InkWell(
                                onTap: () {
                                  //MapUtils.openMap(-3.823216,-38.481700);
                                  openMap(
                                      double.parse(
                                          filteredclients[index]["lat"]),
                                      double.parse(
                                          filteredclients[index]["long"]));
                                },
                                child: Icon(Icons.location_on_outlined)),
                            trailing: InkWell(
                                onTap: () {
                                  launch(
                                      "tel://${filteredclients[index]["Mobileno"]}");
                                },
                                child: Icon(Icons.phone)),
                            subtitle: Text(filteredclients[index]["Mobileno"]),
                            title: Text(filteredclients[index]["Clientname"]),
                          ),
                        );
                      },
                    )
                  ],
                )),
    );
  }
}
