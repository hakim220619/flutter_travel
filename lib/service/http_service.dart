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
     
      var id_user = jsonUsers['user']['id'];
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("email", email);
      await pref.setInt("id_user", id_user);
      await pref.setBool("is_login", true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Dashboard(
            token: jsonUsers['data'],
            email: email,
            id_user: id_user.toString(),
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
    
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
     
      if (json == 'username already exist') {
       
        await EasyLoading.showError(json);
      } else {
      
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static pesan(nama, email, noHp, id_persediaan_tiket, harga, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id_user = prefs.getInt('id_user');
 
    Random objectname = Random();
    int number = objectname.nextInt(10000000);
    String username = 'SB-Mid-server-z5T9WhivZDuXrJxC7w-civ_k';
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
  
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
    
    http.Response response = await _client.post(_pesanUrl, body: {
      "id_persediaan_tiket": id_persediaan_tiket,
      "id_user": id_user.toString(),
      "nama_pemesan": nama,
      "email": email,
      "no_hp": noHp,
      "status": "belum bayar",
      "order_id": number.toString(),
      "redirect_url": jsonMidtrans['redirect_url'],
    });
  
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
     
      if (json['success'] == false) {
       
        await EasyLoading.showError(json);
      } else {
        print(json);
        // await EasyLoading.showSuccess(json.success);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Dashboard(
                      token: "",
                      email: "",
                      id_user: "",
                    )));
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }
}
