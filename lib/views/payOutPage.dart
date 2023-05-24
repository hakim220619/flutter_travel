import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:travel/views/dashboard.dart';
import 'package:travel/views/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: unused_import
import 'dart:io';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class payOutPage extends StatefulWidget {
  const payOutPage({
    Key? key,
    required this.nama,
    required this.email,
    required this.no_hp,
    required this.status,
    required this.redirect_url,
    required this.order_id,
  }) : super(key: key);
  final String nama;
  final String email;
  final String no_hp;
  final String status;
  final String redirect_url;
  final String order_id;

  @override
  State<payOutPage> createState() => _payOutPageState();
}

final _formkey = GlobalKey<FormState>();

// List _get = [];
class DataStatus {
  final int status;

  const DataStatus({
    required this.status,
  });

  factory DataStatus.fromJson(Map<String, dynamic> json) {
    return DataStatus(
      status: json['status'],
    );
  }
}

class TransactionDetails {
  final String status;

  TransactionDetails({
    required this.status,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      status: json['status'],
    );
  }

  static List<TransactionDetails> fromJsonList(dynamic jsonList) {
    final transactionDetailsList = <TransactionDetails>[];
    if (jsonList['data'] == null) return transactionDetailsList;
    // print(jsonList['data']);
    if (jsonList['data'] is List<dynamic>) {
      // print(jsonList['data']);
      for (final json in jsonList['data']) {
        transactionDetailsList.add(
          TransactionDetails.fromJson(json),
        );
      }
    }

    return transactionDetailsList;
  }
}

class _payOutPageState extends State<payOutPage> {
  Future<List<TransactionDetails>> fetchTransaction() async {
    var _riwayatTiket = Uri.parse('https://travel.dlhcode.com/api/cetak_tiket');
    http.Response response = await http.post(_riwayatTiket, body: {
      "order_id": widget.order_id,
    });
    // print(response.body);
    print(widget.order_id);
    if (response.statusCode == 200) {
      // final data = response.body;
      String username = 'SB-Mid-server-z5T9WhivZDuXrJxC7w-civ_k';
      String password = '';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      http.Response responseTransaksi = await http.get(
        Uri.parse("https://api.sandbox.midtrans.com/v2/" +
            widget.order_id +
            "/status"),
        headers: <String, String>{
          'authorization': basicAuth,
          'Content-Type': 'application/json'
        },
      );
      var jsonTransaksi = jsonDecode(responseTransaksi.body.toString());

      if (jsonTransaksi['status_code'] == '200') {
        var updateTransaksi =
            Uri.parse('https://travel.dlhcode.com/api/updateTransaksi');
        // ignore: unused_local_variable
        http.Response getOrderId = await http.post(updateTransaksi, body: {
          "order_id": widget.order_id,
        });
        print(jsonTransaksi['status_code']);
      }
      return TransactionDetails.fromJsonList(json.decode(response.body));
    } else {
      throw Exception('Request Failed.');
    }
  }

  // List _get = [];
  // Future<List<DataStatus>> cekTransaksi() async {
  //   var _riwayatTiket = Uri.parse('https://travel.dlhcode.com/api/cetak_tiket');
  //   http.Response response = await http.post(_riwayatTiket, body: {
  //     "order_id": widget.order_id,
  //   });
  //   // print(response.body);
  //   if (response.statusCode == 200) {
  //     // final data = jsonDecode(response.body);
  //     // print(data['data']);
  //     return DataStatus.fromJson(jsonDecode(response.body));
  //   }
  //   String username = 'SB-Mid-server-z5T9WhivZDuXrJxC7w-civ_k';
  //   String password = '';
  //   String basicAuth =
  //       'Basic ' + base64Encode(utf8.encode('$username:$password'));
  //   http.Response responseTransaksi = await http.get(
  //     Uri.parse(
  //         "https://api.sandbox.midtrans.com/v2/" + widget.order_id + "/status"),
  //     headers: <String, String>{
  //       'authorization': basicAuth,
  //       'Content-Type': 'application/json'
  //     },
  //   );
  //   var jsonTransaksi = jsonDecode(responseTransaksi.body.toString());

  //   if (jsonTransaksi['status_code'] == '200') {
  //     var updateTransaksi =
  //         Uri.parse('https://travel.dlhcode.com/api/updateTransaksi');
  //     // ignore: unused_local_variable
  //     http.Response getOrderId = await http.post(updateTransaksi, body: {
  //       "order_id": widget.order_id,
  //     });
  //     print(jsonTransaksi['status_code']);
  //   }
  // }

  Future refresh() async {
    setState(() {
      fetchTransaction();
    });
  }

  // late Future<DataStatus> GetDataStatus;
  // void initState() {
  //   super.initState();
  //   GetDataStatus = cekTransaksi();
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Pembayaran"),
          leading: InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(),
                ),
              );
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
              child: FutureBuilder(
                future: fetchTransaction(),
                builder: (context,
                    AsyncSnapshot<List<TransactionDetails>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Center(child: Text('Something went wrong'));
                    }
                    print(snapshot.data);
                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 1,
                        itemBuilder: (context, index) => Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Card(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.key,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      title: Text(
                                        widget.order_id,
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20,
                                            fontFamily: "Source Sans Pro"),
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.copy),
                                          onPressed: () async {
                                            //logic to open POPUP window
                                            Clipboard.setData(new ClipboardData(
                                                    text: widget.order_id))
                                                .then((_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Copied to your clipboard !')));
                                            });
                                          }),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Card(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),
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
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),
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
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),
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
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.payment,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      title: Text(
                                        snapshot.data![index].status,
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
                                  child: Center(
                                      child: ElevatedButton(
                                    child: Text("Bayar Sekarang"),
                                    onPressed: () async {
                                      if (snapshot.data![index].status ==
                                          'lunas') {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Warning!!'),
                                            content: const Text(
                                                'Pembayaran anda sudah lunas'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        String url = widget.redirect_url;
                                        var urllaunchable = await canLaunch(
                                            url); //canLaunch is from url_launcher package
                                        if (urllaunchable) {
                                          await launch(
                                              url); //launch is from url_launcher package to launch URL
                                        } else {
                                          print("URL can't be launched.");
                                        }
                                      }
                                    },
                                  )),
                                ),
                              ],
                            )));
                  }
                  return const CircularProgressIndicator();
                },
              )),
        ));
    //
  }
}
