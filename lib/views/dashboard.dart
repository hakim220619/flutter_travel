// ignore: unused_import
import 'dart:developer';
// ignore: unused_import
import 'dart:ffi';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/views/paypage.dart';
import 'dart:convert';
import 'dart:async';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travel/views/listBooking.dart';
// ignore: unused_import
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'cetak_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
      print(response.statusCode);
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
          (route) => false,
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
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(yesbutton),
              onPressed: () async {
                Logout();
                Navigator.of(context, rootNavigator: true).pop('dialog');
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
            body: Menu()));
  }
}

class Menu extends StatefulWidget {
  const Menu({
    Key? key,
  }) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

final _formkey = GlobalKey<FormState>();
String? onclick;
bool seepwd = false;

@override
// var tofromRute;
var toAgentValue;
bool changebutton = false;

@override
class _MenuState extends State<Menu> {
  TextEditingController dateofJourney = TextEditingController();
  int _selectedIndex = 0;
  var tofromRute;
  List getRute = [];
  List _get = [];
  static final _client = http.Client();
  var asal;
  var tujuan;
  var FixLunas;

  //Future
  Future Rute() async {
    var baseUrl = "https://travel.eastbluetechnology.com/api/rute";
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        getRute = jsonData['data'];
        // print(getRute);
      });
    }
  }

  // List toAgent = [];
  // Future getagentTo() async {
  //   var baseUrl = "https://travel.eastbluetechnology.com/api/tempat_agen";
  //   http.Response response = await http.get(Uri.parse(baseUrl));
  //   if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body);

  //     setState(() {
  //       toAgent = jsonData['data'];
  //     });
  //   }
  // }

  Future riwayatTiket() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var id_user = preferences.getInt('id_user');
      var token = preferences.getString('token');
      var _riwayatTiket =
          Uri.parse('https://travel.eastbluetechnology.com/api/riwayat_tiket');
      http.Response response = await _client.post(_riwayatTiket, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token.toString(),
      }, body: {
        "id_user": id_user.toString(),
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _get = data['data'];
          // print(_get);
        });
        var _orderid =
            Uri.parse('https://travel.eastbluetechnology.com/api/cek_transaksi');
        http.Response getOrderId = await _client.post(_orderid, body: {
          "id_user": id_user.toString(),
        });

        if (getOrderId.statusCode == 200) {
          final dataOrderId = jsonDecode(getOrderId.body)['data'];
          // print(dataOrderId);
          for (var i = 0; i < dataOrderId.length; i++) {
            var orderId = dataOrderId[i]['order_id'];
            // print(i);
            String username = 'SB-Mid-server-1De6XBimvoJ-ON1XbDl4M5rC';
            String password = '';
            String basicAuth =
                'Basic ' + base64Encode(utf8.encode('$username:$password'));
            http.Response responseTransaksi = await _client.get(
              Uri.parse(
                  "https://api.sandbox.midtrans.com/v2/" + orderId + "/status"),
              headers: <String, String>{
                'authorization': basicAuth,
                'Content-Type': 'application/json'
              },
            );
            var jsonTransaksi = jsonDecode(responseTransaksi.body.toString());

            if (jsonTransaksi['status_code'] == '200') {
              var updateTransaksi =
                  Uri.parse('https://travel.eastbluetechnology.com/api/updateTransaksi');
              // ignore: unused_local_variable
              http.Response getOrderId =
                  await _client.post(updateTransaksi, body: {
                "order_id": orderId,
              });
              // print(jsonTransaksi['status_code']);
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Rute();
      // getagentTo();
      riwayatTiket();
      profile();
      loginStatus();
    });
  }

  Future refresh() async {
    setState(() {
      riwayatTiket();
    });
  }

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Rute();
    // getagentTo();
    riwayatTiket();
    profile();
    loginStatus();
  }

  @override
  void dispose() {
    _formkey.currentState?.dispose();
    super.dispose();
  }

  var profilePhoto = "http://cdn.onlinewebfonts.com/svg/img_299586.png";
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      Container(
        child: SafeArea(
          child: Material(
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: Container(
                      child: Column(children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Rute :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'Titik Penjemputan'),
                            isExpanded: true,
                            items: getRute.map((item) {
                              return DropdownMenuItem(
                                  value: item['id'].toString(),
                                  child: Text(item['keberangkatan'].toString() +
                                      ' - ' +
                                      item['tujuan'].toString()));
                            }).toList(),
                            validator: (value) {
                              if (value == null)
                                return 'Silahkan Masukan Tempat';
                              return null;
                            },
                            value: tofromRute,
                            onChanged: (newVal) {
                              setState(() {
                                tofromRute = newVal;
                              });
                            },
                          ),
                        ),

                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Tanggal :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'Pilih Tanggal'),
                            validator: (value) {
                              if (value == false)
                                return 'Silahkan Pilih Tanggal';
                              return null;
                            },
                            onTap: () async {
                              DateFormat('dd/mm/yyyy').format(DateTime.now());
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
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            var email = preferences.getString('email');
                            var id_user = preferences.getInt('id_user');
                            setState(() {
                              changebutton = true;
                            });
                            if (_formkey.currentState!.validate()) {
                              // await ListBooking(tofromRute,
                              //     dateofJourney.text, context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (
                                      context,
                                    ) =>
                                        ListBooking(
                                            // tofromRute: 1,
                                            rute: tofromRute.toString(),
                                            dateofJourney: dateofJourney.text,
                                            email: email.toString()),
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
                                    "Cari",
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
                ]),
              ),
            ),
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
                      _get[index]['keberangkatan'] +
                      ' | ' +
                      _get[index]['tujuan'],
                  style: new TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _get[index]['status'] +
                      " | "
                          "Tgl " +
                      _get[index]['created_at'].toString().substring(0, 10),
                  maxLines: 2,
                  style: new TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  _get[index]['tgl_keberangkatan'].toString().substring(10, 19),
                ),
                onTap: () {
                  if (_get[index]['status'] == 'lunas') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => TicketData(
                          order_id: _get[index]['order_id'].toString(),
                          nama: _get[index]['nama_pemesan'].toString(),
                          tanggal: _get[index]['tgl_keberangkatan'].toString(),
                          email: _get[index]['email'].toString(),
                          no_hp: _get[index]['no_hp'].toString(),
                          status: _get[index]['status'].toString(),
                          no_kursi: _get[index]['no_kursi'].toString(),
                        ),
                      ),
                     
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => payPage(
                              nama: _get[index]['nama_pemesan'].toString(),
                              email: _get[index]['email'].toString(),
                              no_hp: _get[index]['no_hp'].toString(),
                              status: _get[index]['status'].toString(),
                              redirect_url:
                                  _get[index]['redirect_url'].toString())),
                     
                    );
                  }
                },
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
              label: 'Pesan',
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
