import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:travel/views/dashboard.dart';
import 'package:travel/views/dashboardS.dart';
import 'package:travel/views/listBooking.dart';
import 'package:travel/views/login.dart';
import 'package:travel/views/payOutPage.dart';
import 'package:travel/views/paypage.dart';
import 'package:travel/views/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class HttpService {
  static final _client = http.Client();

  static var _loginUrl = Uri.parse('https://travel.eastbluetechnology.com/api/login');
  static var _registerUrl =
      Uri.parse('https://travel.eastbluetechnology.com/api/register');
  static var _pesanUrl =
      Uri.parse('https://travel.eastbluetechnology.com/api/tambah_pemesanan');
  static var _pesanmidtransUrl =
      Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');
  static var _tracking =
      Uri.parse('https://travel.eastbluetechnology.com/api/tambah_tracking');

  static login(email, password, context) async {
    // ignore: unused_local_variable
    bool isLoading = false;
    http.Response response = await _client.post(_loginUrl, body: {
      "email": email,
      "password": password,
    });
    if (response.statusCode == 200) {
      var jsonUsers = jsonDecode(response.body);

      var id_user = jsonUsers['user']['id'];
      var nama = jsonUsers['user']['nama'];
      var no_hp = jsonUsers['user']['no_hp'].toString();
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("email", email);
      await pref.setString(
        "token",
        jsonUsers['data'],
      );
      await pref.setString("nama", nama);
      await pref.setInt("id_user", id_user);
      await pref.setString("no_hp", no_hp);
      await pref.setBool("is_login", true);
      // print(jsonUsers['user']['role_id']);
      if (jsonUsers['user']['role_id'] == '2') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Dashboard(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardS(),
          ),
          (route) => false,
        );
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static register(email, password, nama, noHp, context) async {
    http.Response response = await _client.post(_registerUrl, body: {
      "email": email,
      "password": password,
      "nama": nama,
      "no_hp": noHp,
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

  static pesan(id_jadwal, harga, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id_user = prefs.getInt('id_user');
    var nama = prefs.getString('nama');
    var email = prefs.getString('email');
    var no_hp = prefs.getString('no_hp');
    var token = prefs.getString('token');
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

    http.Response response = await _client.post(_pesanUrl, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token.toString(),
    }, body: {
      "id_jadwal": id_jadwal,
      "id_user": id_user.toString(),
      "nama_pemesan": nama.toString(),
      "email": email.toString(),
      "no_hp": no_hp.toString(),
      "status": "belum bayar",
      "order_id": number.toString(),
      "redirect_url": jsonMidtrans['redirect_url'],
    });
    print(response.body);
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var json = jsonDecode(response.body.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => payPage(
                  nama: nama.toString(),
                  email: email.toString(),
                  no_hp: no_hp.toString(),
                  status: "belum bayar",
                  redirect_url: jsonMidtrans['redirect_url'])));
    }
  }

  static pesanOut(
      nama, email, noHp, id_persediaan_tiket, harga, context) async {
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
      "nama_pemesan": nama,
      "email": email,
      "no_hp": noHp,
      "status": "belum bayar",
      "order_id": number.toString(),
      "redirect_url": jsonMidtrans['redirect_url'],
    });

    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var json = jsonDecode(response.body.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => payOutPage(
                    nama: nama,
                    email: email,
                    no_hp: noHp,
                    status: "belum bayar",
                    redirect_url: jsonMidtrans['redirect_url'],
                    order_id: number.toString(),
                  )));
    }
  }

  static tracking(id_persediaan_tiket, lat_long, nama_lokasi, context) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    var formatterH = new DateFormat('Hms').format(now);
    String formattedDate = formatter.format(now);

    // print(formatterH); // 2016-01-25
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    var id_user = preferences.getInt('id_user');
    var token = preferences.getString('token');
    // print(id_user);
    // print(id_persediaan_tiket);
    // print(lat_long);
    // print(nama_lokasi);

    http.Response response = await _client.post(_tracking, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token.toString(),
    }, body: {
      "id_supir": id_user.toString(),
      "id_jadwal": id_persediaan_tiket.toString(),
      "lat_long": lat_long.toString(),
      "nama_lokasi": nama_lokasi.toString(),
      "tgl": formattedDate,
      "jam": formatterH,
    });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      // print(json);
      if (json == 'username already exist') {
        await EasyLoading.showError(json);
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashboardS()));
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }
}
