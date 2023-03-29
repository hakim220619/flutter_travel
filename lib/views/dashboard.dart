import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/views/paypage.dart';
import 'dart:convert';
import 'dart:async';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travel/views/listBooking.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class Dashboard extends StatefulWidget {
  const Dashboard(
      {Key? key,
      required this.token,
      required this.email,
      required this.id_user})
      : super(key: key);
  final String token;
  final String email;
  final String id_user;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static final _client = http.Client();

  @override
  static var _logoutUrl = Uri.parse('https://travel.dlhcode.com/api/logout');

  Future Logout() async {
    try {
      http.Response response = await _client.get(_logoutUrl, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + widget.token,
      });
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          preferences.remove("is_login");
          preferences.remove("id_user");
          preferences.remove("email");
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(yesbutton),
              onPressed: () async {
                onTap();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Travel"),
              actions: [
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () {
                    _showMyDialog('Log Out', 'Are you sure you want to logout?',
                        'No', 'Yes', () async {
                      Logout();
                    }, true);
                    
                    child:
                    Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
                    );
                    
                  },
                )
              ],
            ),
            body: Menu(
                email: widget.email,
                id_user: widget.id_user,
                token: widget.token)));
  }
}

class Menu extends StatefulWidget {
  const Menu(
      {super.key,
      required this.email,
      required this.id_user,
      required this.token});
  final String email;
  final String id_user;
  final String token;
  @override
  State<Menu> createState() => _MenuState();
}

final _formkey = GlobalKey<FormState>();
String? onclick;
bool seepwd = false;

@override
var fromAgentValue;
var toAgentValue;
bool changebutton = false;

@override
class _MenuState extends State<Menu> {
  TextEditingController dateofJourney = TextEditingController();
  int _selectedIndex = 0;
  var fromAgentValue;
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
      });
    }
  }

  List _get = [];
 
  static final _client = http.Client();
  var asal;
  var tujuan;
  Future riwayatTiket() async {
    try {
      var _riwayatTiket =
          Uri.parse('https://travel.dlhcode.com/api/riwayat_tiket');
      http.Response response = await _client.post(_riwayatTiket, body: {
        "email": widget.email,
        "id_user": widget.id_user,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        setState(() {
          _get = data['data'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
  var _dataProfile;
  var datanama;
  profile() async {
    try {
      var _profile = Uri.parse('https://travel.dlhcode.com/api/profile');
      http.Response response = await _client.post(_profile, headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer " + widget.token,
      }, body: {
        "email": widget.email,
      });
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final dataProfile = jsonDecode(response.body.toString());

        setState(() {
          _dataProfile = dataProfile['data'];
          var dataNama = _dataProfile['nama'].toString();
          print(dataNama);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // String? _nama;
  // String? _email;
  // String? _no_hp;

  // String? get nama => _nama;
  // set nama(String? nama) => _nama = nama;
  // String? get email => _email;
  // set email(String? email) => _email = email;

  // String? get no_hp => _no_hp;
  // set no_hp(String? no_hp) => _no_hp = no_hp;
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> _dataProfile = new Map<String, dynamic>();
  //   _dataProfile['nama'] = this.nama;
  //   _dataProfile['email'] = this._email;
  //   _dataProfile['no_hp'] = this._no_hp;
  //   return _dataProfile;

  // }
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      getagentFrom();
      getagentTo();
      riwayatTiket();
      profile();
    });
  }

  Future refresh() async {
    setState(() {
      riwayatTiket();
    });
  }

  void initState() {
    getagentFrom();
    getagentTo();
    riwayatTiket();
    profile();
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
            color: Colors.white,
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(children: [
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
                            items: fromAgent.map((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child: Text(item['tempat_agen'].toString()),
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
                                hintText: 'Pilih Tujuan'),
                            isExpanded: true,
                            items: fromAgent.map((item) {
                              return DropdownMenuItem(
                                value: item['id'].toString(),
                                child: Text(item['tempat_agen'].toString()),
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
                                        ListBooking(
                                            fromAgentValue: fromAgentValue,
                                            toAgentValue: toAgentValue,
                                            dateofJourney: dateofJourney.text,
                                            email: widget.email),
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
                  backgroundColor: Color.fromARGB(255, 131, 90, 214),
                  child: Icon(Icons.directions_car),
                ),
                title: Text(
                  "Dari " + _get[index]['asal'] + ' | ' + _get[index]['tujuan'],
                  style: new TextStyle(fontSize: 18.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _get[index]['status'] +
                      " | "
                          "Tgl " +
                      _get[index]['created_at']
                          .toString()
                          .substring(0, 10),
                  maxLines: 2,
                  style: new TextStyle(fontSize: 18.0),
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => payPage(
                              redirect_url: _get[index]['redirect_url'])));
                },
              ),
            ),
          ),
        ),
      ),
      Column(children: [
        SafeArea(
          minimum: const EdgeInsets.only(top: 100),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                // backgroundImage: Colors.black,
              ),
              Text(
                "_dataProfile['nama']",
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
                      "_dataProfile['email']",
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
                      "_dataProfile['no_hp']",
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
        )
      ]),
        
        
    ];
    
    return Scaffold(
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
    );
  }
}

