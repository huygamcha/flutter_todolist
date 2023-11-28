// import 'dart:js';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewData extends StatefulWidget {
  ViewData({Key? key, required this.document, required this.id})
      : super(key: key);
  final Map<String, dynamic> document;
  final String id;

  @override
  _ViewDataState createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  // tạo các cách controller để nhận giá trị được nhập vào
  late TextEditingController _titleController;
  late TextEditingController __descriptionController;
  String type = "";
  String category = "";
  bool edit = false;
  User? currentUser; // Đối tượng người dùng hiện tại

  void getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    currentUser = auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // TODO: implement initState
    super.initState();
    String title = widget.document["title"] ?? "Hey There";
    _titleController = TextEditingController(text: title);
    __descriptionController =
        TextEditingController(text: widget.document["description"]);
    type = widget.document["task"] ?? "";
    category = widget.document["category"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1d1e26),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff1d1e26),
            Color(0xff252041),
          ]),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          String userEmail = currentUser?.email ?? "guest";
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(userEmail)
                              .collection("Todo")
                              .doc(widget.id)
                              .delete()
                              .then((value) => {Navigator.pop(context)});
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: edit ? Colors.green : Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? "Editing" : "View",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Your todo",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    label("task Title"),
                    const SizedBox(
                      height: 12,
                    ),
                    title(context),
                    const SizedBox(
                      height: 30,
                    ),
                    label("Task Type"),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect("Imporatant", 0xff2664fa),
                        const SizedBox(
                          width: 20,
                        ),
                        taskSelect("Planned", 0xff2bc8d9),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    label("Descreption"),
                    const SizedBox(
                      height: 25,
                    ),
                    descreption(context),
                    const SizedBox(
                      height: 12,
                    ),
                    label("category"),
                    const SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categorySelect("Food", 0xffff6d6e),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Workout", 0xfff29732),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("work", 0xff6557ff),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Design", 0xff234ebd),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Run", 0xff2bc8d9),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    edit ? button(context) : Container(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(BuildContext context) {
    return InkWell(
        onTap: () {
          String userEmail = currentUser?.email ?? "guest";
          FirebaseFirestore.instance
              .collection("users")
              .doc(userEmail)
              .collection("Todo")
              .doc(widget.id)
              .update({
            'title': _titleController.text,
            'task': type,
            'category': category,
            'description': __descriptionController.text
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
              "Update Todo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
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
        controller: __descriptionController,
        enabled: edit,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
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
        onTap: edit
            ? () {
                setState(() {
                  type = label;
                });
              }
            : null,
        child: Chip(
          backgroundColor: type == label ? Colors.black : Color(color),
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

  Widget categorySelect(String label, int color) {
    return InkWell(
        onTap: edit
            ? () {
                setState(() {
                  category = label;
                });
              }
            : null,
        child: Chip(
          backgroundColor: category == label ? Colors.black : Color(color),
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
      child: Center(
        child: TextFormField(
          controller: _titleController,
          enabled: edit,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
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
      ),
    );
  }

  Widget label(String label) {
    return const Text(
      "Task Title",
      style: TextStyle(
        fontSize: 16.5,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}
