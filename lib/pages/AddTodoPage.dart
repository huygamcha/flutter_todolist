// import 'dart:js';
// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/HomePage.dart';

class AddTodoPage extends StatefulWidget {
  AddTodoPage({Key? key}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  // tạo các cách controller để nhận giá trị được nhập vào
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String type = "";
  String Category = "";
  User? currentUser; // Đối tượng người dùng hiện tại
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    currentUser = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(colors: [
        //     Color(0xff1d1e26),
        //     Color(0xff252041),
        //   ]),
        // ),
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => HomePage()),
                      (route) => false);
                },
                icon: const Icon(
                  CupertinoIcons.home,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Text(
                        "Create work!",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "New todo",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    label("Duty"),
                    const SizedBox(
                      height: 12,
                    ),
                    title(context),
                    const SizedBox(
                      height: 30,
                    ),
                    label("Classify"),
                    const SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        taskSelect("Default", 0xff3b5998),
                        const SizedBox(
                          width: 15,
                        ),
                        taskSelect("Important", 0xff3b5998),
                        const SizedBox(
                          width: 15,
                        ),
                        taskSelect("Urgent", 0xff3b5998),
                        const SizedBox(
                          width: 15,
                        ),
                        taskSelect("Personal", 0xff3b5998),
                        const SizedBox(
                          width: 15,
                        ),
                        taskSelect("Meeting", 0xff3b5998),
                        const SizedBox(
                          width: 15,
                        ),
                        taskSelect("Planned", 0xff3b5998),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    label("Descreption"),
                    const SizedBox(
                      height: 15,
                    ),
                    descreption(context),
                    const SizedBox(
                      height: 12,
                    ),
                    label("Tag"),
                    const SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        CategorySelect("Food", 0xff2ecc71),
                        const SizedBox(
                          width: 20,
                        ),
                        CategorySelect("Sport", 0xff2ecc71),
                        const SizedBox(
                          width: 20,
                        ),
                        CategorySelect("Work", 0xff2ecc71),
                        const SizedBox(
                          width: 20,
                        ),
                        CategorySelect("Homework", 0xff2ecc71),
                        const SizedBox(
                          width: 20,
                        ),
                        CategorySelect("Health", 0xff2ecc71),
                        const SizedBox(
                          width: 20,
                        ),
                        CategorySelect("Design", 0xff2ecc71),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    label("Time"),
                    const SizedBox(
                      height: 12,
                    ),
                    time(context),
                    const SizedBox(
                      height: 50,
                    ),
                    button(context),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              // Text(
              //   '${currentUser?.email ?? "Guest"}',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
    return scaffold;
  }

  Widget button(BuildContext context) {
    return InkWell(
        onTap: () {
          String userEmail = currentUser?.email ?? "guest";
          FirebaseFirestore.instance
              .collection("users")
              .doc(userEmail)
              .collection("Todo")
              .add({
            'title': _titleController.text,
            'task': type,
            'Tag': Category,
            'description': _descriptionController.text,
            'time': _timeController.text,
          });

          //quay lại màn hình trước đó
          Navigator.pop(context);
        },
        child: Container(
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xff8a32f1),
                Color(0xffad32f9),
              ],
            ),
          ),
          child: const Center(
            child: Text(
              "Add Todo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ));
  }

  Widget descreption(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title...",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget taskSelect(String label, int color) {
    return InkWell(
        onTap: () {
          setState(() {
            type = label;
          });
        },
        child: Chip(
          backgroundColor: type == label ? Colors.red : Color(color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          label: Text(label),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          labelPadding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 3.8,
          ),
        ));
  }

  Widget time(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _timeController,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Task Time...",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget CategorySelect(String label, int color) {
    return InkWell(
        onTap: () {
          setState(() {
            Category = label;
          });
        },
        child: Chip(
          backgroundColor: Category == label ? Colors.red : Color(color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          label: Text(label),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          labelPadding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 3.8,
          ),
        ));
  }

  Widget title(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title...",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}
