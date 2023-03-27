import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:travel/views/dashboard.dart';
import 'package:travel/views/listBooking.dart';
import 'package:travel/views/login.dart';
import 'package:travel/views/paypage.dart';
import 'package:travel/views/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class HttpService {
  static final _client = http.Client();

  static var _loginUrl = Uri.parse('https://travel.dlhcode.com/api/login');

  static var _registerUrl =
      Uri.parse('https://travel.dlhcode.com/api/register');
  static var _pesanUrl =
      Uri.parse('https://travel.dlhcode.com/api/tambah_pemesanan');
  static var _pesanmidtransUrl =
      Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');

  static login(email, password, context) async {
    http.Response response = await _client.post(_loginUrl, body: {
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      var jsonUsers = jsonDecode(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("email", email);
      await pref.setBool("is_login", true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Dashboard(
            token: jsonUsers['data'],
            email: email,
          ),
        ),
        (route) => false,
      );
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static register(email, password, nama, noHp, role, context) async {
    http.Response response = await _client.post(_registerUrl, body: {
      "email": email,
      "password": password,
      "nama": nama,
      "no_hp": noHp,
      "role_id": role,
    });
    // print(response);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      // print(json);
      if (json == 'username already exist') {
        // print(json);
        await EasyLoading.showError(json);
      } else {
        // print(json);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static pesan(nama, email, noHp, id_persediaan_tiket, harga, context) async {
    Random objectname = Random();
    int number = objectname.nextInt(10000000);
    String username = 'SB-Mid-server-z5T9WhivZDuXrJxC7w-civ_k';
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    // print(basicAuth);
    http.Response responseMidtrans = await _client.post(_pesanmidtransUrl,
        headers: <String, String>{
          'authorization': basicAuth,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'transaction_details': {'order_id': number, 'gross_amount': harga},
          "credit_card": {"secure": true}
        }));
    var jsonMidtrans = jsonDecode(responseMidtrans.body.toString());
    print(responseMidtrans.body);
    http.Response response = await _client.post(_pesanUrl, body: {
      "id_persediaan_tiket": id_persediaan_tiket,
      "nama_pemesan": nama,
      "email": email,
      "no_hp": noHp,
      "status": "pending",
      "redirect_url": jsonMidtrans['redirect_url'],
    });
    print(response.body);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      print(json['success'] == true);
      if (json['success'] == false) {
        print(json);
        await EasyLoading.showError(json);
      } else {
        print(json);
        // await EasyLoading.showSuccess(json.success);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    payPage(redirect_url: jsonMidtrans['redirect_url']
                    )));
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }
}
