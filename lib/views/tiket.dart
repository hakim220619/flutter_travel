import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// ignore: unused_import
import 'package:flutter/src/widgets/placeholder.dart';
// ignore: unused_import
import 'package:flutter_easyloading/flutter_easyloading.dart';
// ignore: unused_import
import 'package:email_validator/email_validator.dart';
// ignore: unused_import
import 'package:ticket_widget/ticket_widget.dart';
import 'package:travel/views/cetak_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: unused_import
import 'dart:io';
// ignore: duplicate_import
import 'cetak_page.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';

class TiketPage extends StatefulWidget {
  TiketPage({super.key});

  static final _client = http.Client();

  @override
  State<TiketPage> createState() => _TiketPageState();
}

class _TiketPageState extends State<TiketPage> {
  @override
  // ignore: override_on_non_overriding_member
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
                keyboardType: TextInputType.number,
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
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  var id_user = preferences.getInt('id_user');
                  var token = preferences.getString('token');
                  var _riwayatTiket =
                      Uri.parse('https://travel.eastbluetechnology.com/api/cetak_tiket');
                  http.Response response =
                      await TiketPage._client.post(_riwayatTiket, headers: {
                    "Accept": "application/json",
                    "Authorization": "Bearer " + token.toString(),
                  }, body: {
                    "order_id": kodeBooking,
                  });
                  print(response.statusCode);

                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body.toString());
                    // print(data['data']['order_id']);

                    // print(i);
                    String username = 'SB-Mid-server-1De6XBimvoJ-ON1XbDl4M5rC';
                    String password = '';
                    String basicAuth = 'Basic ' +
                        base64Encode(utf8.encode('$username:$password'));
                    http.Response responseTransaksi = await http.get(
                      Uri.parse("https://api.sandbox.midtrans.com/v2/" +
                          kodeBooking +
                          "/status"),
                      headers: <String, String>{
                        'authorization': basicAuth,
                        'Content-Type': 'application/json'
                      },
                    );
                    var jsonTransaksi =
                        jsonDecode(responseTransaksi.body.toString());

                    if (jsonTransaksi['status_code'] == '200') {
                      var updateTransaksi = Uri.parse(
                          'https://travel.eastbluetechnology.com/api/updateTransaksi');
                      // ignore: unused_local_variable
                      http.Response getOrderId =
                          await http.post(updateTransaksi, body: {
                        "order_id": kodeBooking,
                      });
                      // print(jsonTransaksi['status_code']);
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TicketData(
                                  order_id:
                                      data['data1']['order_id'].toString(),
                                  nama:
                                      data['data1']['nama_pemesan'].toString(),
                                  tanggal:
                                      data['data1']['created_at'].toString(),
                                  email: data['data1']['email'].toString(),
                                  no_hp: data['data1']['no_hp'].toString(),
                                  status: data['data1']['status'].toString(),
                                  no_kursi: data['data1']['no_kursi'].toString(),
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
