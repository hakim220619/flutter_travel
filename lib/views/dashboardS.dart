// ignore: unused_import
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:travel/views/paypage.dart';
import 'package:travel/views/tracking_page.dart';
import 'dart:convert';
import 'dart:async';
import 'login.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:travel/views/listBooking.dart';
// ignore: unused_import
import 'package:flutter_easyloading/flutter_easyloading.dart';
// ignore: unused_import
import 'cetak_page.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DashboardS extends StatefulWidget {
  const DashboardS({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardS> createState() => _DashboardSState();
}

class _DashboardSState extends State<DashboardS> {
  static final _client = http.Client();

  @override
  // ignore: override_on_non_overriding_member
  static var _logoutUrl = Uri.parse('https://travel.eastbluetechnology.com/api/logout');

  Future Logout() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      http.Response response = await _client.get(_logoutUrl, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token.toString(),
      });
      print(response.body);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          preferences.remove("is_login");
          preferences.remove("id_user");
          preferences.remove("email");
          preferences.remove("nama");
          preferences.remove("no_hp");
          preferences.remove("token");
          preferences.remove("id_user");
          preferences.remove("order_id");
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
          (route) => true,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showMyDialog(String title, String text, String nobutton,
      String yesbutton, Function onTap, bool isValue) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isValue,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(nobutton),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(yesbutton),
              onPressed: () async {
                Logout();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Travel"),
              actions: [
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () {
                    _showMyDialog('Log Out', 'Are you sure you want to logout?',
                        'No', 'Yes', () async {}, false);

                    // ignore: unused_label
                    child:
                    Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
                    );
                  },
                )
              ],
            ),
            body: MenuS()));
  }
}

class MenuS extends StatefulWidget {
  const MenuS({
    Key? key,
  }) : super(key: key);

  @override
  State<MenuS> createState() => _MenuSState();
}

final _formkey = GlobalKey<FormState>();
String? onclick;
bool seepwd = false;

@override
var fromAgentValue;
var toAgentValue;
bool changebutton = false;

@override
class _MenuSState extends State<MenuS> {
  TextEditingController dateofJourney = TextEditingController();
  int _selectedIndex = 0;

  static final _client = http.Client();

  // ignore: unused_field
  List _getProfile = [];
  Future profile() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var email = preferences.getString('email');
      var token = preferences.getString('token');

      var _riwayatTiket = Uri.parse('https://travel.eastbluetechnology.com/api/profile');
      http.Response response = await _client.post(_riwayatTiket, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token.toString(),
      }, body: {
        "email": email.toString(),
      });
      if (response.statusCode == 200) {
        // ignore: unused_local_variable
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var nama = prefs.getString('nama');
        // print(nama);
        // ignore: unused_local_variable
        var _getProfile = nama.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  var nama;
  var email;
  var no_hp;
  void loginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => {
          nama = prefs.getString('nama'),
          email = prefs.getString('email'),
          no_hp = prefs.getString('no_hp'),
        });
  }

  List _get = [];
  Future riwayatTracking() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var id_user = preferences.getInt('id_user');
      var token = preferences.getString('token');
      // print(id_user);
      var _riwayatTiket =
          Uri.parse('https://travel.eastbluetechnology.com/api/tracking_by_id_supir');
      http.Response response = await _client.post(_riwayatTiket, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token.toString(),
      }, body: {
        "id_supir": id_user.toString(),
      });
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _get = data['data'];
          // print(_get);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      profile();
      loginStatus();
      riwayatTracking();
    });
  }

  // Future refresh() async {
  //   setState(() {
  //     riwayatTiket();
  //   });
  // }

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    profile();
    loginStatus();
    riwayatTracking();
  }

  @override
  void dispose() {
    _formkey.currentState?.dispose();
    super.dispose();
  }

  Future refresh() async {
    // ignore: unused_local_variable

    // print(nama.toString());
    setState(() {
      riwayatTracking();
      // ignore: unused_local_variable, non_constant_identifier_names
      // _loadCounter();
      // print(Getnama);
    });
  }

  var profilePhoto = "http://cdn.onlinewebfonts.com/svg/img_299586.png";
  // ignore: unused_field
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  String _scanBarcode = 'Unknown';
  Future<void> scanBarcodeNormal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Getnama = prefs.getString('nama');
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeScanRes != false) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TrackingPage(
                lokasi: _scanBarcode, namaSupir: Getnama.toString()),
          ),
        );
      }
      print(barcodeScanRes);
    } on Exception {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // ignore: override_on_non_overriding_member

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      Center(
        child: Container(
          alignment: Alignment.center,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () => scanBarcodeNormal(),
                  child: Text('Start barcode scan')),
              Text('Scan result : $_scanBarcode\n',
                  style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      ),
      Center(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
            itemCount: _get.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.all(10),
              elevation: 8,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 48, 31, 83),
                  child: Icon(
                    Icons.directions_car,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Dari " +
                      _get[index]['nama_lokasi'].toString() +
                      ' | ' +
                      _get[index]['tujuan'].toString(),
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _get[index]['lat_long'].toString(),
                  maxLines: 2,
                  style: new TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  _get[index]['tgl'].toString(),
                ),
                // onTap: () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => TicketData(
                //                 order_id: _get[index]['order_id'].toString(),
                //                 nama: _get[index]['nama_pemesan'].toString(),
                //                 tanggal:
                //                     _get[index]['tgl_keberangkatan'].toString(),
                //                 email: _get[index]['email'].toString(),
                //                 no_hp: _get[index]['no_hp'].toString(),
                //                 status: _get[index]['status'].toString(),
                //               )));

                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => payPage(
                //               nama: _get[index]['nama_pemesan'].toString(),
                //               email: _get[index]['email'].toString(),
                //               no_hp: _get[index]['no_hp'].toString(),
                //               status: _get[index]['status'].toString(),
                //               redirect_url:
                //                   _get[index]['redirect_url'].toString())));
                // },
              ),
            ),
          ),
        ),
      ),
      Column(
        children: [
          // ListView.builder(
          //   itemCount: _getProfile.length,
          //   itemBuilder: (context, index) =>
          SafeArea(
            minimum: const EdgeInsets.only(top: 100),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  // backgroundImage: Colors.black,
                ),
                Text(
                  "${this.nama}",
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Pacifico",
                  ),
                ),

                SizedBox(
                  height: 20,
                  width: 200,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),

                // we will be creating a new widget name info carrd

                GestureDetector(
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      title: Text(
                        "${this.email}",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontFamily: "Source Sans Pro"),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    child: ListTile(
                      leading: Icon(
                        Icons.call,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      title: Text(
                        "${this.no_hp}",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontFamily: "Source Sans Pro"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(
            _selectedIndex,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
