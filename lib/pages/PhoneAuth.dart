// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class PhoneAuthPage extends StatefulWidget {
  PhoneAuthPage({Key? key}) : super(key: key);

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "SignUp",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          centerTitle: true,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                textField(),
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                          margin: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                      Text(
                        "Enter 6 digit OTP",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                          margin: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                otpField(),
                SizedBox(
                  height: 40,
                ),
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Send OTP again in ",
                      style:
                          TextStyle(fontSize: 16, color: Colors.yellowAccent),
                    ),
                    TextSpan(
                      text: "00:$start",
                      style: TextStyle(fontSize: 16, color: Colors.pinkAccent),
                    ),
                    TextSpan(
                      text: " sec ",
                      style:
                          TextStyle(fontSize: 16, color: Colors.yellowAccent),
                    ),
                  ],
                )),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                      color: Color(0xffff9601),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      "Lets Go",
                      style: TextStyle(
                          fontSize: 17,
                          color: Color(0xfffbe2ae),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ))));
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          start = 30;
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return OtpTextField(
      numberOfFields: 6,
      fieldWidth: 40,
      borderColor: Color(0xFF512DA8),
      focusedBorderColor: Color(0xFF4F44FF),
      //set to true to show as box or false to show as dash
      showFieldAsBox: true,
      //runs when a code is typed in
      onCodeChanged: (String code) {
        //handle validation or checks here
      },
      textStyle: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
      //runs when every textfield is filled
      onSubmit: (String verificationCode) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Verification Code"),
                content: Text('Code entered is $verificationCode'),
              );
            });
      }, // end onSubmit
    );
  }

  Widget textField() {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xff1d1d1d),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
            style: TextStyle(color: Colors.white, fontSize: 17),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter your phone Number",
                hintStyle: TextStyle(color: Colors.white54, fontSize: 17),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 19, horizontal: 8),
                prefixIcon: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                  child: Text(
                    " (+84) ",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                suffixIcon: InkWell(
                    onTap: wait
                        ? null
                        : () {
                            startTimer();
                            setState(() {
                              wait = true;
                              buttonName = "Resend";
                              start = 30;
                            });
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 15),
                      child: Text(
                        buttonName,
                        style: TextStyle(
                          color: wait ? Colors.grey : Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )))));
  }
}
