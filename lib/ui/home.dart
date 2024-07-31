import 'package:flutter/material.dart';
import 'package:todoapp/ui/todoscreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("ToDoApp",style: TextStyle(color: Colors.white),),
      ),
      body: ToDoScreen(),
    );
  }
}
