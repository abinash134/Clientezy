import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Database/Databasehelper.dart';
import '../../WIdgets/clientcard.dart';


enum SingingCharacter { All,Cold_Lead,
Engaged,
Prospect,
Hot_lead,
Customer,}

class ViewClient extends StatefulWidget {
  const ViewClient({Key? key}) : super(key: key);

  @override
  _ViewClientState createState() => _ViewClientState();
}

class _ViewClientState extends State<ViewClient> {
  List<Map> clients = [];
  String type = "All";
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
  SingingCharacter? _character = SingingCharacter.Cold_Lead;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: <Widget>[
                                    Text("Filter",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                    ListTile(
                                      title: const Text('All'),
                                      leading: Radio<SingingCharacter>(
                                        value: SingingCharacter.All,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                            type = 'All';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Cold Lead'),
                                      leading: Radio<SingingCharacter>(
                                        value: SingingCharacter.Cold_Lead,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                            type = 'Cold Lead';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Engaged'),
                                      leading: Radio<SingingCharacter>(
                                        value: SingingCharacter.Engaged,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                            type = 'Engaged';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Prospect'),
                                      leading: Radio<SingingCharacter>(
                                        value: SingingCharacter.Prospect,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                            type = 'Prospect';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Hot Lead'),
                                      leading: Radio<SingingCharacter>(
                                        value: SingingCharacter.Hot_lead,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                            type = 'Hot lead';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Customer'),
                                      leading: Radio<SingingCharacter>(
                                        value: SingingCharacter.Customer,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                            type = 'Customer';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                            ));
                      });
                },
                child: Icon(Icons.filter_list_outlined)),
          )
        ],
        elevation: 0,
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
                    return type=="All"?ClientCardWidget(
                      client: clients[index],
                    ):type==clients[index]["type"]?ClientCardWidget(
                      client: clients[index],
                    ):Container();
                  },
                )
              ],
            )),
    );
  }
}
