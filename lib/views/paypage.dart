import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:travel/views/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class payPage extends StatefulWidget {
  const payPage({
    Key? key,
    required this.nama,
    required this.email,
    required this.no_hp,
    required this.status,
    required this.redirect_url,
  }) : super(key: key);
  final String nama;
  final String email;
  final String no_hp;
  final String status;
  final String redirect_url;

  @override
  State<payPage> createState() => _payPageState();
}

class _payPageState extends State<payPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                title: Text(
                  widget.nama,
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
                  Icons.email,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                title: Text(
                  widget.email,
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
                  widget.no_hp,
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
                  Icons.payment,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                title: Text(
                  widget.status,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontFamily: "Source Sans Pro"),
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.redAccent[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                    child: ElevatedButton(
                  child: Text("Bayar Sekarang"),
                  onPressed: () async {
                    String url = widget.redirect_url;
                    var urllaunchable = await canLaunch(
                        url); //canLaunch is from url_launcher package
                    if (urllaunchable) {
                      await launch(
                          url); //launch is from url_launcher package to launch URL
                    } else {
                      print("URL can't be launched.");
                    }
                  },
                )),
                Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Kembali"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
              ),
            ),
          )
              ],
            ),
          ),
          
        ],
      ),
    ));
  }
}
