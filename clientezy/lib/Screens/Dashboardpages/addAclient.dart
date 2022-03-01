import 'package:clientezy/Database/Databasehelper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

enum _PositionItemType {
  log,
  position,
}

class AddClient extends StatefulWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  TextEditingController name = TextEditingController();
  TextEditingController mobileno = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController latlong = TextEditingController();
  String lat = "";
  String long = "";
  bool isgettinglocation = false;
  bool issavingdata = false;
  String dropdownValue = 'Cold Lead';
  Future<void> _getCurrentPosition() async {
    setState(() {
      isgettinglocation = true;
    });
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    Position position = await _geolocatorPlatform.getCurrentPosition();
    print(position.latitude.toString());
    print(position.longitude.toString());
    setState(() {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      latlong.text =
          "${position.latitude.toString()} +${position.longitude.toString()}";
      isgettinglocation = false;
    });
  }
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1910),
      lastDate: DateTime.now(),

    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        dob.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
  }
  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Add Client",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          // Image.asset(
          //   "Assets/background.png",
          //   //fit: BoxFit.fill,
          //   height: MediaQuery.of(context).size.height,
          // ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter client Name',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: mobileno,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter client Mobile No',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!_isNumeric(value)) {
                            return 'Please enter valid Mobile NO';
                          } else if (value.length < 10 || value.length > 10) {
                            return 'Please enter valid Mobile NO';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) * 2,
                            child: TextFormField(
                              controller: dob,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter client D.O.B',
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(),
                              onPressed: () => {_selectDate(context)},
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Icon(Icons.calendar_month_outlined),)
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width / 3) * 2,
                            child: TextFormField(
                              controller: latlong,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Take Location',
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(),
                              onPressed: () => {_getCurrentPosition()},
                              child: isgettinglocation
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(Icons.place),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Client Type"),
                          SizedBox(width: 10,),
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.expand_more),
                            elevation: 16,
                            style:
                            const TextStyle(color: Colors.deepPurple),

                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: issavingdata
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    issavingdata = true;
                                  });
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  int i = await DatabaseHelper.instance.insert(
                                    {
                                      DatabaseHelper.ClientNmae: name.text,
                                      DatabaseHelper.Mobileno: mobileno.text,
                                      DatabaseHelper.DOB: dob.text,
                                      DatabaseHelper.Lat: lat,
                                      DatabaseHelper.Long: long,
                                      DatabaseHelper.Type: dropdownValue,
                                    },
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Data Saved')),
                                  );
                                  setState(() {
                                    name.text = "";
                                    mobileno.text = "";
                                    dob.text = "";
                                    latlong.text = "";
                                    issavingdata = false;
                                  });
                                }
                              },
                              child: issavingdata
                                  ? CircularProgressIndicator()
                                  : Text('Submit'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
