import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travel/views/listBooking.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:profile/profile.dart';

class Dashboard extends StatefulWidget {
  // const Dashboard({Key? key}) : super(key: key);
  const Dashboard({Key? key, required this.token, required this.email})
      : super(key: key);
  final String token;
  final String email;

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
      // print(response.statusCode);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          preferences.remove("is_login");
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

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Dashboard"),
              actions: [
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () {
                    Logout();
                    // _handleLogout;
                  },
                )
              ],
            ),
            body: Menu(email: widget.email)));
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key, required this.email});
  final String email;
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
      // print(jsonData);
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      getagentFrom();
      getagentTo();
    });
  }

  void initState() {
    getagentFrom();
    getagentTo();
  }

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
                                            dateofJourney: dateofJourney.text),
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
      Text(
        'Index 1: Business',
        style: optionStyle,
      ),
      Container(
        margin: EdgeInsets.only(top: 30),
        child: Profile(
          imageUrl:
              "https://images.unsplash.com/photo-1598618356794-eb1720430eb4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
          name: "Shamim Miah",
          email: widget.email,
          phone_number: "01757736053",
          website: "shamimmiah.com",
          designation: "",
        ),
      )
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
