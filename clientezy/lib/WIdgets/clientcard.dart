import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Database/Databasehelper.dart';

class ClientCardWidget extends StatefulWidget {
  const ClientCardWidget({Key? key, required this.client}) : super(key: key);
  final Map client;

  @override
  State<ClientCardWidget> createState() => _ClientCardWidgetState();
}

class _ClientCardWidgetState extends State<ClientCardWidget> {
  String dropdownValue = 'Cold Lead';
  static Future<void> openMap(double latitude, double longitude) async {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }
  @override
  void initState() {
    // TODO: implement initState
    dropdownValue = widget.client["type"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: (50),
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: Image.asset("Assets/maleavtr.png"),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.client["Clientname"],
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.expand_more),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? newValue) async {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                          int i = await DatabaseHelper.instance.updateClientType(widget.client["id"], newValue!);
                          if(i !=0){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Data Changed')),
                            );
                          }


                        },
                        items: <String>[
                          'Cold Lead',
                          'Engaged',
                          'Prospect',
                          'Hot lead',
                          'Customer',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          launch("tel://${widget.client["Mobileno"]}");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              children: [
                                Icon(Icons.phone),
                                Text(widget.client["Mobileno"]),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      InkWell(
                          onTap: () {
//MapUtils.openMap(-3.823216,-38.481700);
                            openMap(double.parse(widget.client["lat"]),
                                double.parse(widget.client["long"]));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(

                                children: [
                                  Text("See Location"),
                                  Icon(Icons.location_on_outlined),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
