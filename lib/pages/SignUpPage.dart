// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:my_app/pages/HomePage.dart';
import 'package:my_app/pages/PhoneAuth.dart';
import 'package:my_app/pages/SignInPage.dart';
import 'package:my_app/Services/Auth_Service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool circular = false;

  Authclass authclass = Authclass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buttonItem('assets/google.svg', 'Continue with Google', 25,
                        () async {
                      await authclass.googleSignIn(context);
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    buttonItem('assets/phone.svg', 'Continue with Phone', 25,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => PhoneAuthPage()));
                    }),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Or",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    textItem('Email...', _emailController, false),
                    SizedBox(
                      height: 15,
                    ),
                    textItem('Password... ', _pwdController, true),
                    SizedBox(
                      height: 30,
                    ),
                    colorButton(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'if you already have an account ?',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => SignInPage()),
                                  (route) => false);
                            },
                            child: Text(
                              'Login ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    )
                  ]))),
    );
  }

  Widget colorButton() {
    return InkWell(
        onTap: () async {
          setState(() {
            circular = true;
          });
          try {
            firebase_auth.UserCredential userCredential =
                await firebaseAuth.createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _pwdController.text);
            // ignore: avoid_print
            print(userCredential.user?.email);
            setState(() {
              circular = true;
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => HomePage()),
                (route) => false);
          } catch (e) {
            final snackbar = SnackBar(content: Text(e.toString()));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            setState(() {
              circular = false;
            });
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 90,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [
                Color(0xfffd746c),
                Color(0xffff9068),
                Color(0xfffd746c)
              ])),
          child: Center(
            child: circular
                ? CircularProgressIndicator()
                : Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
          ),
        ));
  }

  Widget buttonItem(
      String imagepath, String buttomName, double size, Function onTap) {
    return InkWell(
        onTap: () => onTap(),
        child: Container(
            width: MediaQuery.of(context).size.width - 60,
            height: 60,
            child: Card(
              color: Colors.black,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(width: 1, color: Colors.grey)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          10), // Thêm padding 10 pixels theo chiều ngang
                  child: SvgPicture.asset(
                    imagepath,
                    height: size,
                    width: size,
                  ),
                ),
                Text(
                  buttomName,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )
              ]),
            )));
  }

  Widget textItem(
      String label, TextEditingController controller, bool obscureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 17, color: Colors.white),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 17, color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.amber,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 1, color: Colors.grey))),
      ),
    );
  }
}
