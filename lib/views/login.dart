import 'package:flutter/material.dart';
import 'package:travel/service/http_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:travel/views/bookingPage.dart';
import 'package:travel/views/register.dart';
import 'package:cool_alert/cool_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;
  final _formKey = GlobalKey<FormState>();
  static const IconData directions_car =
      IconData(0xe1d7, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Icon(
              directions_car,
              size: 100,
            )),
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
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Masukan Email',
                  hintText: 'Masukan Email'),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              maxLines: 1,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Masukan Password',
                  hintText: 'Masukan Password'),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // print(password);
                // print(email);
                
                
              
                // CoolAlert.show(
                //   context: context,
                //   type: CoolAlertType.success,
                //   text: 'Transaction completed successfully!',
                //   autoCloseDuration: const Duration(seconds: 2),

                // );
                HttpService.login(email, password, context);
                
      
              }
              
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
            ),
            child: const Text(
              'Masuk',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Belum Punya Akun?'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text('Registrasi'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Mau Langsung Pesan Tiket?'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Add(),
                    ),
                  );
                },
                child: const Text('Pesan Tiket'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

