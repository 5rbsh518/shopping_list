import 'package:flutter/material.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create a new item")),
      body: const Padding(
        padding: EdgeInsets.all(25),
        child: Text("Form"),
      ),
    );
  }
}
