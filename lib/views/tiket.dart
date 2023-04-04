import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:travel/views/cetak_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'cetak_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TiketPage extends StatefulWidget {
  TiketPage({super.key});

  static final _client = http.Client();

  @override
  State<TiketPage> createState() => _TiketPageState();
}

class _TiketPageState extends State<TiketPage> {
  @override
  final _formKey = GlobalKey<FormState>();

  late String kodeBooking;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiket"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextFormField(
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                maxLines: 1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    labelText: 'Masukan Kode Booking',
                    hintText: 'Masukan Kode Booking'),
                onChanged: (value) {
                  setState(() {
                    kodeBooking = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var _riwayatTiket =
                      Uri.parse('https://travel.dlhcode.com/api/cetak_tiket');
                  http.Response response =
                      await TiketPage._client.post(_riwayatTiket, body: {
                    "order_id": kodeBooking,
                  });
                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body.toString());
                    // print(data['data']['order_id']);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TicketData(
                                  order_id: data['data']['order_id'].toString(),
                                  nama: data['data']['nama_pemesan'].toString(),
                                  tanggal:
                                      data['data']['created_at'].toString(),
                                  email: data['data']['email'].toString(),
                                  no_hp: data['data']['no_hp'].toString(),
                                )));
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Warning!!'),
                        content: const Text('Masukan kode boking dengan benar'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(150, 15, 150, 15),
              ),
              child: const Text(
                'Cari',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
