// ignore_for_file: prefer_final_fields, unused_local_variable, avoid_print, file_names, use_build_context_synchronously, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/pages/HomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Authclass {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  FirebaseAuth auth = FirebaseAuth.instance;

  // Create storage
  final storage = new FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        try {
          // truy cập vào firebase để tạo tài khoản thông qua google
          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          // lưu token cho user
          storeTokenAndData(userCredential);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text('Not able to sign in'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    // Write value
    await storage.write(
        key: 'token', value: userCredential.credential?.token.toString());
    await storage.write(
        key: 'token', value: userCredential.credential?.token.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> logOut() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {}
  }
}
