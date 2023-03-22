import 'package:flutter/material.dart';
import 'package:travel/service/http_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String email;
  late String password;
  late String nama;
  late String noHp;
  late String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              TextField(
                obscureText: false,
                decoration: InputDecoration(hintText: 'Nama'),
                onChanged: (value) {
                  setState(() {
                    nama = value;
                  });
                },
              ),
              TextField(
                obscureText: false,
                decoration: InputDecoration(hintText: 'email'),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'password'),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextField(
                obscureText: false,
                decoration: InputDecoration(hintText: 'Nomor Hp'),
                onChanged: (value) {
                  setState(() {
                    noHp = value;
                  });
                },
              ),
              TextField(
                obscureText: false,
                decoration: InputDecoration(hintText: 'Role'),
                onChanged: (value) {
                  setState(() {
                    role = value;
                  });
                },
              ),
              InkWell(
                  onTap: () async {
                    await HttpService.register(
                        email, password, nama, noHp, role, context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25)),
                  ))
            ],
          ),
        )
        // ignore: avoid_unnecessary_containers
        );
  }
}
