import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Database/Databasehelper.dart';

class ViewClient extends StatefulWidget {
  const ViewClient({Key? key}) : super(key: key);

  @override
  _ViewClientState createState() => _ViewClientState();
}

class _ViewClientState extends State<ViewClient> {
  List<Map> clients = [];

  static Future<void> openMap(double latitude, double longitude) async {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  Future<void> getdata() async {
    List<Map> list = await DatabaseHelper.instance.fetchdata();
    setState(() {
      clients = list;
    });
    print(list.toString());
    print(list[0]["id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clients"),
        centerTitle: true,
      ),
      body: clients.length == 0
          ? Center(
              child: Text("No Clients Found."),
            )
          : SingleChildScrollView(
              child: Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: InkWell(
                            onTap: () {
                              //MapUtils.openMap(-3.823216,-38.481700);
                              openMap(double.parse(clients[index]["lat"]),
                                  double.parse(clients[index]["long"]));
                            },
                            child: Icon(Icons.location_on_outlined)),
                        trailing: InkWell(
                            onTap: () {
                              launch("tel://${clients[index]["Mobileno"]}");
                            },
                            child: Icon(Icons.phone)),
                        subtitle: Text(
                            "${clients[index]["Mobileno"]} (${clients[index]["type"]})"),
                        title: Text(clients[index]["Clientname"]),
                      ),
                    );
                  },
                )
              ],
            )),
    );
  }
}
