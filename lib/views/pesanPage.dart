// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:travel/service/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PesanPage extends StatefulWidget {
  const PesanPage({
    Key? key,
    required this.idKey,
    required this.asalKey,
    required this.tujuanKey,
    required this.tanggalKey,
    required this.hargaKey,
  }) : super(key: key);
  final String idKey;
  final String asalKey;
  final String tujuanKey;
  final String tanggalKey;
  final String hargaKey;

  @override
  State<PesanPage> createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  TextEditingController Nama = TextEditingController(text: '');
  TextEditingController Email = TextEditingController(text: '');
  TextEditingController Nohp = TextEditingController(text: '');
  @override
  var tanggal;
  var asal;
  var tujuan;
  final _formkey = GlobalKey<FormState>();
  SharedPreferences? preferences;


  Widget build(BuildContext context) {
 void loginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var nama = prefs.getString('nama');
    var email = prefs.getString('email');
    var nohp = prefs.getString('no_hp');
    
    setState(() => {
          Nama.text = nama.toString(),
          Email.text = email.toString(),
          Nohp.text = nohp.toString()
          
        });
  }
  void initState() {
    super.initState();
    loginStatus();
  }
    return Scaffold(
      appBar: AppBar(title: Text("Pesan")),
      body: SafeArea(
        child: Material(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: Container(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: Nama,
                            onChanged: (value) {
                              setState(() {
                                Nama.text = value;
                              });
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Masukan Nama Lengkap",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Nama"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Nama tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                           controller: Email,
                            onChanged: (value) {
                              setState(() {
                                Email.text = value;
                              });
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Masukan Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Email"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: Nohp,
                            onChanged: (value) {
                              setState(() {
                                Nohp.text = value;
                              });
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Masukan Nomor Hp",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Nomor Hp"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Nomor Hp tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            initialValue: widget.asalKey,
                            obscureText: false,
                            onChanged: (value) {
                              setState(() {
                                asal = value;
                              });
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                                hintText: 'Asal',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Asal"),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            initialValue: widget.tujuanKey,
                            obscureText: false,
                            onChanged: (value) {
                              setState(() {
                                tujuan = value;
                              });
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                                hintText: 'Tujuan',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Tujuan"),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            initialValue: widget.tanggalKey,
                            obscureText: false,
                            readOnly: true,
                            decoration: InputDecoration(
                                hintText: 'Tanggal',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Tanggal"),
                            onChanged: (value) {
                              setState(() {
                                tanggal = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          await HttpService.pesan(Nama, Email, Nohp,
                              widget.idKey, widget.hargaKey, context);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: const Center(
                          child: Text(
                            "Bayar",
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
      ),
    );
  }
}
