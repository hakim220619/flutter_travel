import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';

class TicketData extends StatefulWidget {
  const TicketData({
    Key? key,
    required this.order_id,
    required this.nama,
    required this.tanggal,
    required this.email,
    required this.no_hp,
    required this.status,
    required this.no_kursi,
  }) : super(key: key);
  final String order_id;
  final String nama;
  final String tanggal;
  final String email;
  final String no_hp;
  final String status;
  final String no_kursi;

  @override
  State<TicketData> createState() => _TicketDataState();
}

@override
// List<Map<Widget, dynamic>> DataAll = [];

class _TicketDataState extends State<TicketData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: TicketWidget(
          width: 350,
          height: 500,
          isCornerRounded: true,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120.0,
                    height: 25.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(width: 1.0, color: Colors.green),
                    ),
                    child: const Center(
                      child: Text(
                        'Travel',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  "Tiket: " + '${widget.order_id}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  "No Kursi: " + widget.no_kursi,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: ticketDetailsWidget("Nama", '${widget.nama}',
                                'Tanggal Berangkat', '${widget.tanggal}', "No Kursi" '${widget.no_kursi}'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, right: 45),
                            child: ticketDetailsWidget('Email',
                                '${widget.email}', 'No Hp', '${widget.no_hp}', "No Kursi"'${widget.no_kursi}'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40.0,
                      ),
                      child: Container(
                        width: 250.0,
                        height: 10.0,
                        // decoration: const BoxDecoration(
                        //     image: DecorationImage(
                        //         image: AssetImage('assets/barcode.png'),
                        //         fit: BoxFit.cover)),
                      ),
                    ),
                    
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(21),
                              bottomLeft: Radius.circular(21))),
                      margin: EdgeInsets.only(left: 15, right: 15),
                      padding: EdgeInsets.only(top: 0, bottom: 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: "${widget.order_id}",
                            drawText: false,
                            color: Color.fromARGB(255, 14, 5, 5),
                            width: double.infinity,
                            height: 70,
                          ),
                        ),
                      ),

                      // child: Text(
                      //   'Status: Lunas',
                      //   style: TextStyle(color: Colors.black, fontSize: 30),
                      // ),
                    ),
                    Text("Status: " "${widget.status}"),
                    // Text("Jam Berangkat: " "${widget.status}"),
                    const SizedBox(height: 20),
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
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc, String no_kursi) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            
          ],
        ),
      ),
      
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            
          ],
        ),
      ),
      
    ],
  );
}
