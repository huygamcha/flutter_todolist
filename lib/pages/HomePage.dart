import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Custom/TodoCart.dart';
import 'package:my_app/Services/Auth_Service.dart';
import 'package:my_app/pages/AddPage.dart';
import 'package:my_app/pages/SignUpPage.dart';
import 'package:my_app/pages/UpdatePage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Authclass authclass = Authclass();
  User? currentUser; // Đối tượng người dùng hiện tại
  late Stream<QuerySnapshot> _stream;
  Widget currentPage = SignUpPage();
  late String formattedDate;

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
    _updateDate();
  }

  void _updateDate() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('EEEE d').format(now);
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
          "${currentUser?.email}",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/alo.jpg"),
            radius: 30,
          ),
          SizedBox(
            width: 25,
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      String userEmail = currentUser?.email ?? "guest";

                      var instance = FirebaseFirestore.instance
                          .collection("users")
                          .doc(userEmail)
                          .collection("Todo");
                      for (var i = 0; i < selected.length; i++) {
                        if (selected[i].checkValue) {
                          instance.doc(selected[i].id).delete();
                          selected[i].checkValue = true;
                        }
                      }

                      // set cho việc xoá trở lại bình thường
                      for (var i = 0; i < selected.length; i++) {
                        selected[i].checkValue = true;
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 40,
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
                Icons.logout_outlined,
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
                  switch (document["Tag"]) {
                    case "Work":
                      iconData = Icons.run_circle_outlined;
                      iconColor = Colors.red;
                      break;
                    case "Homework":
                      iconData = Icons.book;
                      iconColor = Colors.orange;
                      break;
                    case "Health":
                      iconData = Icons.hearing;
                      iconColor = Colors.purple;
                      break;
                    case "Sport":
                      iconData = Icons.alarm;
                      iconColor = Colors.teal;
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
                      iconColor = Colors.black;
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
                    child: Container(
                      margin: EdgeInsets.only(top: 6.0),
                      // padding: EdgeInsets.only(top: 6.0),
                      child: TodoCart(
                        title: document["title"] ?? "Hey There",
                        check: selected[index].checkValue,
                        iconBgColor: Colors.white,
                        iconColor: iconColor,
                        iconData: iconData,
                        time: document["time"] ?? "",
                        index: index,
                        onChange: onChange,
                      ),
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