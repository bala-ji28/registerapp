import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formcontroller = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  bool obscuretext = true;
  void signin() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailcontroller.text, password: passcontroller.text)
        .then((value) {
      if (value.user != null) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Register successfully.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                      emailcontroller.clear();
                      passcontroller.clear();
                      namecontroller.clear();
                    },
                    child: const Text('ok'),
                  ),
                ],
              );
            });
      }
    });
  }

  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    passcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formcontroller,
          child: Column(
            children: [
              const Text(
                'REGISTER',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter name',
                  prefixIcon: Icon(Icons.person),
                ),
                controller: namecontroller,
                keyboardType: TextInputType.name,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'enter the field';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter email',
                  prefixIcon: Icon(Icons.email),
                ),
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'enter the field';
                  } else if (!val.contains("@")) {
                    return 'Invalid emial';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscuretext = !obscuretext;
                      });
                    },
                    child: Icon(
                        obscuretext ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                controller: passcontroller,
                obscureText: obscuretext,
                keyboardType: TextInputType.visiblePassword,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'enter the field';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formcontroller.currentState!.validate()) {
                    signin();
                    debugPrint('ok..');
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300.0, 50.0),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Already register? ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                        text: 'login',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
