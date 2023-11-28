// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Custom/TodoCart.dart';
import 'package:my_app/Services/Auth_Service.dart';
import 'package:my_app/pages/AddTodoPage.dart';
import 'package:my_app/pages/SignUpPage.dart';
import 'package:my_app/pages/view_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Authclass authclass = Authclass();
  User? currentUser; // Đối tượng người dùng hiện tại
  late Stream<QuerySnapshot> _stream;
  Widget currentPage = SignUpPage();

  @override
  void initState() {
    super.initState();
    checkLogin();
    getCurrentUser();
    String userEmail = currentUser?.email ?? "guest";
    _stream = FirebaseFirestore.instance
        .collection("users")
        .doc(userEmail)
        .collection("Todo")
        .snapshots();
  }

  void checkLogin() async {
    String? token = await authclass.getToken();
    if (token != null) {
      setState(() {
        currentPage = HomePage();
      });
    }
  }

  void getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    currentUser = auth.currentUser;
  }

  List<Select> selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "To day's Schedule",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/alo.jpg"),
          ),
          SizedBox(
            width: 25,
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Monday 21",
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      var instance =
                          FirebaseFirestore.instance.collection("Todo");
                      for (var i = 0; i < selected.length; i++) {
                        if (selected[i].checkValue) {
                          instance.doc(selected[i].id).delete();
                        }
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBar(backgroundColor: Colors.black87, items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 32,
            color: Colors.white,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.black87,
          icon: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => AddTodoPage()));
            },
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Colors.indigoAccent,
                  Colors.purple,
                ]),
              ),
              child: Icon(
                Icons.add,
                size: 29,
                color: Colors.white,
              ),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => SignUpPage()),
                    (route) => false);
              },
              child: Icon(
                Icons.settings,
                size: 32,
                color: Colors.white,
              )),
          label: '',
        ),
      ]),
      body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  IconData iconData;
                  Color iconColor;
                  Map<String, dynamic> document =
                      snapshot.data?.docs[index].data() as Map<String, dynamic>;
                  switch (document["category"]) {
                    case "work":
                      iconData = Icons.run_circle_outlined;
                      iconColor = Colors.red;
                      break;
                    case "Workout":
                      iconData = Icons.alarm;
                      iconColor = Colors.teal;
                      break;
                    case "Run":
                      iconData = Icons.run_circle;
                      iconColor = Colors.yellow;
                      break;
                    case "Food":
                      iconData = Icons.local_grocery_store;
                      iconColor = Colors.blue;
                      break;
                    case "Design":
                      iconData = Icons.audiotrack;
                      iconColor = Colors.green;
                      break;
                    default:
                      iconData = Icons.run_circle_outlined;
                      iconColor = Colors.red;
                  }
                  selected.add(Select(
                      id: snapshot.data!.docs[index].id, checkValue: false));
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ViewData(
                                    document: document,
                                    id: snapshot.data!.docs[index].id,
                                  )));
                    },
                    child: TodoCart(
                      title: document["title"] ?? "Hey There",
                      check: selected[index].checkValue,
                      iconBgColor: Colors.white,
                      iconColor: iconColor,
                      iconData: iconData,
                      time: "10 PM",
                      index: index,
                      onChange: onChange,
                    ),
                  );
                });
          }),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select {
  String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}

///
///IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: () async {
          //     await authclass.logOut();
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (builder) => SignUpPage()),
          //         (route) => false);
          //   },
          // ),