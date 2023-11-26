import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                      "Sign In",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buttonItem('assets/google.svg', 'Continue with Google', 25),
                    SizedBox(
                      height: 20,
                    ),
                    buttonItem('assets/phone.svg', 'Continue with Phone', 25),
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
                    textItem('Email...'),
                    SizedBox(
                      height: 15,
                    ),
                    textItem('Password... '),
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
                          "You don't have account ?",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          'Sign up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Fogot password? ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ]))),
    );
  }

  Widget colorButton() {
    return Container(
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
        child: Text(
          'Sign up',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget buttonItem(String imagepath, String buttomName, double size) {
    return Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(width: 1, color: Colors.grey)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10), // Thêm padding 10 pixels theo chiều ngang
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
        ));
  }

  Widget textItem(String label) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 17, color: Colors.white),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(width: 1, color: Colors.grey))),
      ),
    );
  }
}
