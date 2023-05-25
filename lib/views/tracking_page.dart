import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

final _formkey = GlobalKey<FormState>();
List fromAgent = [];

class _TrackingPageState extends State<TrackingPage> {
  TextEditingController Nama = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future getagentFrom() async {
      var baseUrl = "https://travel.dlhcode.com/api/persediaan_tiket";
      http.Response response = await http.get(Uri.parse(baseUrl));
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          fromAgent = jsonData['data'];
          print(fromAgent);
        });
      }
    }

    var toAgentValue;
    // ignore: unused_local_variable
    var nama;
    void initState() {
      super.initState();
      getagentFrom();
    }

    Future refresh() async {
      setState(() {
        getagentFrom();
      });
    }

    return Scaffold(
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
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Perjalanan :",
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    hintText: 'Pilih Perjalanan'),
                                isExpanded: true,
                                items: fromAgent.map((item) {
                                  // print(fromAgent);
                                  return DropdownMenuItem(
                                    value: item['id'].toString(),
                                    child: Text("${item['asal'].toString()}"
                                        "- ${item['tujuan'].toString()}"),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == false)
                                    return 'Silahkan Masukan Perjalanan';
                                  return null;
                                },
                                onChanged: (newVal) {
                                  setState(() {
                                    toAgentValue = newVal;
                                    // print(fromAgent[index]['id']);
                                  });
                                },
                                value: toAgentValue,
                              ),
                            ),
                            TextFormField(
                              controller: Nama,
                              onChanged: (value) {
                                setState(() {
                                  nama = value;
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
                            // TextFormField(
                            //   controller: Email,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       email = value;
                            //     });
                            //   },
                            //   decoration: InputDecoration(
                            //       fillColor: Colors.grey.shade100,
                            //       filled: true,
                            //       hintText: "Masukan Email",
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(10)),
                            //       labelText: "Email"),
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return "Email tidak boleh kosong";
                            //     }
                            //     return null;
                            //   },
                            // ),
                            // SizedBox(
                            //   height: 10.0,
                            // ),
                            // TextFormField(
                            //   controller: Nohp,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       noHp = value;
                            //     });
                            //   },
                            //   decoration: InputDecoration(
                            //       fillColor: Colors.grey.shade100,
                            //       filled: true,
                            //       hintText: "Masukan Nomor Hp",
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(10)),
                            //       labelText: "Nomor Hp"),
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return "Nomor Hp tidak boleh kosong";
                            //     }
                            //     return null;
                            //   },
                            // ),
                            // SizedBox(
                            //   height: 10.0,
                            // ),
                            // TextFormField(
                            //   initialValue: widget.asalKey,
                            //   obscureText: false,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       asal = value;
                            //     });
                            //   },
                            //   readOnly: true,
                            //   decoration: InputDecoration(
                            //       hintText: 'Asal',
                            //       fillColor: Colors.grey.shade100,
                            //       filled: true,
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(10)),
                            //       labelText: "Asal"),
                            // ),
                            // SizedBox(
                            //   height: 10.0,
                            // ),
                            // TextFormField(
                            //   initialValue: widget.tujuanKey,
                            //   obscureText: false,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       tujuan = value;
                            //     });
                            //   },
                            //   readOnly: true,
                            //   decoration: InputDecoration(
                            //       hintText: 'Tujuan',
                            //       fillColor: Colors.grey.shade100,
                            //       filled: true,
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(10)),
                            //       labelText: "Tujuan"),
                            // ),
                            // SizedBox(
                            //   height: 10.0,
                            // ),
                            // TextFormField(
                            //   initialValue: widget.tanggalKey,
                            //   obscureText: false,
                            //   readOnly: true,
                            //   decoration: InputDecoration(
                            //       hintText: 'Tanggal',
                            //       fillColor: Colors.grey.shade100,
                            //       filled: true,
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(10)),
                            //       labelText: "Tanggal"),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       tanggal = value;
                            //     });
                            //   },
                            // ),
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
                            // await HttpService.pesanOut(nama, email, noHp,
                            //     widget.idKey, widget.hargaKey, context);
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
        ));
  }
}
