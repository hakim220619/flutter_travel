import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class payPage extends StatefulWidget {
  const payPage({
    Key? key,
    required this.redirect_url,
  }) : super(key: key);
  final String redirect_url;

  @override
  State<payPage> createState() => _payPageState();
}

class _payPageState extends State<payPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Pembayaran")),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.redAccent[50],
            child: Center(
                child: ElevatedButton(
              child: Text("Open Pembayaran"),
              onPressed: () async {
                String url = widget.redirect_url;
                var urllaunchable = await canLaunch(
                    url); //canLaunch is from url_launcher package
                if (urllaunchable) {
                  await launch(
                      url); //launch is from url_launcher package to launch URL
                } else {
                  print("URL can't be launched.");
                }
              },
            )),
          ),
        ));
  }
}
