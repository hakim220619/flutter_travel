// import 'package:bus_ticket_booking_app/models/auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// ignore: unused_import
import 'package:travel/service/http_service.dart';
// ignore: unused_import
import 'package:travel/views/listBooking.dart';
import 'package:travel/views/listOutPage.dart';
// ignore: unused_import
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Add extends StatefulWidget {
  const Add({
    Key? key,
    this.id,
    this.date,
    this.fromcity,
    this.tocity,
  }) : super(key: key);

  final String? id;
  final String? date;
  final String? fromcity;
  final String? tocity;

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController dateofJourney = TextEditingController();

  List fromAgent = [];
  Future getagentFrom() async {
    var baseUrl = "https://travel.dlhcode.com/api/tempat_agen";
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        fromAgent = jsonData['data'];
      });
    }
  }

  List toAgent = [];
  Future getagentTo() async {
    var baseUrl = "https://travel.dlhcode.com/api/tempat_agen";
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      setState(() {
        toAgent = jsonData['data'];
        // print(toAgent);
      });
    }
  }

  String? onclick;
  bool seepwd = false;
  final _formkey = GlobalKey<FormState>();

  @override
  // ignore: override_on_non_overriding_member
  var fromAgentValue;
  var toAgentValue;
  bool changebutton = false;
  @override
  void initState() {
    widget.id != null ? dateofJourney.text = widget.date.toString() : "";
    super.initState();
    getagentFrom();
    getagentTo();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Travel Booking"),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Color.fromARGB(253, 255, 252, 252),
              ),
            ),
          ),
          body: Container(
            child: SafeArea(
              child: Material(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          //------Textformfiled code-------------
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 32.0),
                            child: Container(
                              child: Column(children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Dari :",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintText: 'Titik Penjemputan'),
                                    isExpanded: true,
                                    items: fromAgent.map((item) {
                                      return DropdownMenuItem(
                                        value: item['id'].toString(),
                                        child: Text(
                                            item['tempat_agen'].toString()),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null)
                                        return 'Silahkan Masukan Tempat';
                                      return null;
                                    },
                                    value: fromAgentValue,
                                    onChanged: (newVal) {
                                      setState(() {
                                        fromAgentValue = newVal;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Tujuan :",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintText: 'Pilih Tujuan'),
                                    isExpanded: true,
                                    items: fromAgent.map((item) {
                                      return DropdownMenuItem(
                                        value: item['id'].toString(),
                                        child: Text(
                                            item['tempat_agen'].toString()),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == false)
                                        return 'Silahkan Masukan Tempat';
                                      return null;
                                    },
                                    onChanged: (newVal) {
                                      setState(() {
                                        toAgentValue = newVal;
                                      });
                                    },
                                    value: toAgentValue,
                                  ),
                                ),

                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Tanggal :",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: dateofJourney,
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintText: 'Pilih Tanggal'),
                                    validator: (value) {
                                      if (value == false)
                                        return 'Silahkan Pilih Tanggal';
                                      return null;
                                    },
                                    onTap: () async {
                                      DateFormat('dd/mm/yyyy')
                                          .format(DateTime.now());
                                      var date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100));
                                      if (date == null) {
                                        dateofJourney.text = "";
                                      } else {
                                        dateofJourney.text =
                                            date.toString().substring(0, 10);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //-----------Login Button code---------------
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      changebutton = true;
                                    });
                                    if (_formkey.currentState!.validate()) {
                                      // await ListBooking(fromAgentValue, toAgentValue,
                                      //     dateofJourney.text, context);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (
                                              context,
                                            ) =>
                                                ListOutPage(
                                              fromAgentValue: fromAgentValue,
                                              toAgentValue: toAgentValue,
                                              dateofJourney: dateofJourney.text,
                                              email: "",
                                            ),
                                          ));
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    width: changebutton ? 50 : 150,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: changebutton
                                        ? Icon(Icons.done)
                                        : Text(
                                            widget.fromcity == null
                                                ? "Cari"
                                                : "Cari",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(
                                            changebutton ? 50 : 8)),
                                  ),
                                ),
                              ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          )),
    );
  }
}
