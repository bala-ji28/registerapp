import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final lformcontroller = GlobalKey<FormState>();
  final lemailcontroller = TextEditingController();
  final lpasscontroller = TextEditingController();
  bool obscuretext = true;

  void login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: lemailcontroller.text, password: lpasscontroller.text)
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
        lemailcontroller.clear();
        lpasscontroller.clear();
      });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      if (e.code == 'invalid-email') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Invalid email'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('ok'),
                  ),
                ],
              );
            });
      } else if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('User not found'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('ok'),
                  ),
                ],
              );
            });
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Wrong password'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('ok'),
                  ),
                ],
              );
            });
      }
    }
  }

  @override
  void dispose() {
    lemailcontroller.dispose();
    lpasscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: lformcontroller,
            child: Column(
              children: [
                const Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  controller: lemailcontroller,
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
                      child: Icon(obscuretext
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                  controller: lpasscontroller,
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
                    if (lformcontroller.currentState!.validate()) {
                      login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300.0, 50.0),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
