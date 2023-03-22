import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:travel/views/dashboard.dart';
import 'package:travel/views/listBooking.dart';
import 'package:travel/views/welcome.dart';

class HttpService {
  static final _client = http.Client();

  static var _loginUrl = Uri.parse('https://travel.dlhcode.com/api/login');

  static var _registerUrl =
      Uri.parse('https://travel.dlhcode.com/api/register');

  static login(email, password, context) async {
    http.Response response = await _client.post(_loginUrl, body: {
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      // print(jsonDecode(response.body));
      // var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // await EasyLoading.showSuccess(json[0]);
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        // EasyLoading.showError(json[0]);
      }
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
    print(response);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      print(json);
      if (json == 'username already exist') {
        print(json);
        await EasyLoading.showError(json);
      } else {
        print(json);
        // await EasyLoading.showSuccess(json.success);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static pesan(nama, email, noHp, asal, tujuan, tanggal, context) async {
    http.Response response = await _client.post(_registerUrl, body: {
      "nama": nama,
      "email": email,
      "no_hp": noHp,
      "asal": asal,
      "tujuan": tujuan,
      "tanggal": tanggal,
    });
    print(response);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      print(json);
      if (json == 'username already exist') {
        print(json);
        await EasyLoading.showError(json);
      } else {
        print(json);
        // await EasyLoading.showSuccess(json.success);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }
}
