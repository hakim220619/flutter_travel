import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/service/http_service.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage(
      {super.key, required this.lokasi, required this.namaSupir});
  final String lokasi;
  final String namaSupir;
  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

final _formkey = GlobalKey<FormState>();
List fromAgent = [];
var Getnama;
var lat_long;
var id_persediaan_tiket;
var nama_lokasi;
var nama;
var namaLokasi;

class _TrackingPageState extends State<TrackingPage> {
  TextEditingController NamaLokasi = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future getagentFrom() async {
      var baseUrl = "https://travel.eastbluetechnology.com/api/rute";
      http.Response response = await http.get(Uri.parse(baseUrl));
      // print(response.body);

      // ignore: unused_local_variable

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          fromAgent = jsonData['data'];
          // ignore: unused_local_variable

          print(fromAgent);
        });
      }
    }

    // ignore: unused_local_variable

    void initState() async {
      super.initState();
      getagentFrom();
      // _loadCounter();
    }

    Future refresh() async {
      // ignore: unused_local_variable

      // print(nama.toString());
      setState(() {
        getagentFrom();
        // ignore: unused_local_variable, non_constant_identifier_names
        // _loadCounter();
        // print(Getnama);
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("Tracking"),
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
          body: Center(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) => Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0),
                        child: Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      hintText: 'Pilih Perjalanan'),
                                  isExpanded: true,
                                  items: fromAgent.map((item) {
                                    // print(fromAgent);
                                    return DropdownMenuItem(
                                      value: item['id'].toString(),
                                      child: Text("${item['keberangkatan'].toString()}"
                                          "- ${item['tujuan'].toString()}"),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == false)
                                      // return 'Silahkan Masukan Perjalanan';
                                      return null;
                                  },
                                  onChanged: (newVal) {
                                    setState(() async {
                                      id_persediaan_tiket = newVal;
                                      // print(fromAgent[index]['id']);
                                      // print(newVal);
                                    });
                                  },
                                  value: id_persediaan_tiket,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  initialValue: '$Getnama',
                                  readOnly: true,
                                  onChanged: (value) {
                                    setState(() async {
                                      // ignore: unused_local_variable
                                      // print('$Getnama');
                                      Getnama = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Masukan Nama Lengkap",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: "Nama Supir"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Nama tidak boleh kosong";
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  initialValue: widget.lokasi,
                                  readOnly: true,
                                  onChanged: (value) {
                                    setState(() async {
                                      // ignore: unused_local_variable
                                      // print(value);
                                      lat_long = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Masukan Nama Lengkap",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: "Longitude/Latitude "),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Nama tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  initialValue: namaLokasi,
                                  controller: NamaLokasi,
                                  readOnly: false,
                                  onChanged: (value) {
                                    setState(() {
                                      // ignore: unused_local_variable
                                      // print(nama_lokasi);
                                      nama_lokasi = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Masukan Nama Lokasi",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: "Lokasi Sekarang"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Nama tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 1.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            // print(nama_lokasi);
                            if (_formkey.currentState!.validate()) {
                              await HttpService.tracking(
                                  id_persediaan_tiket.toString(),
                                  widget.lokasi.toString(),
                                  nama_lokasi.toString(),
                                  context);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            child: const Center(
                              child: Text(
                                "Simpan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(25)),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
