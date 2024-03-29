import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// ignore: unused_import
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:travel/views/pesanPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListBooking extends StatefulWidget {
  const ListBooking(
      {Key? key,
      required this.rute,
      required this.dateofJourney,
      required this.email})
      : super(key: key);
  final String rute;
  final String dateofJourney;
  final String email;
  @override
  _ListBookingState createState() => _ListBookingState();
}

class _ListBookingState extends State<ListBooking> {
  List _get = [];
  static final _client = http.Client();
  var asal;
  var tujuan;
  Future search() async {

    try {
       SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    var id_user = preferences.getInt('id_user');
    var token = preferences.getString('token');
      // print({widget.fromAgentValue});
      var _SearchUrl =
          Uri.parse('https://travel.eastbluetechnology.com/api/jadwal_keberangkatan');
      http.Response response = await _client.post(_SearchUrl, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token.toString(),
    }, body: {
        "id_rute": widget.rute,
        "tgl_keberangkatan": widget.dateofJourney,
      });
// print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _get = data['data'];
          // id_user = id_user;
          // print(id_user);
          // print(_get.first['kuota'] == '1');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    search();
  }

  Future refresh() async {
    setState(() {
      search();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = List<String>.generate(10000, (i) => '$i');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "List Travel",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
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
              itemCount: _get.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(10),
                elevation: 8,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 131, 90, 214),
                    child: Icon(Icons.directions_car),
                  ),
                  title: Text(
                    _get[index]['keberangkatan'] + ' | ' + _get[index]['tujuan'],
                    style: new TextStyle(fontSize: 18.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _get[index]['harga'],
                    maxLines: 2,
                    style: new TextStyle(fontSize: 18.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // print(_get.first['kuota']);
                    if (_get.first['stok_tiket'] != '0') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (
                              context,
                            ) =>
                                PesanPage(
                              asalKey: _get[index]['keberangkatan'],
                              tujuanKey: _get[index]['tujuan'],
                              idKey: _get[index]['id'],
                              hargaKey: _get[index]['harga'],
                              tanggalKey: widget.dateofJourney,
                            ),
                          ));
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Warning!!'),
                          content: const Text('kuota untuk Tujuan ini Habis'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
