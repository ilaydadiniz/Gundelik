import 'package:flutter/material.dart';

import '../log_sign_screen/bottom_nav_page.dart';

class WorkerScreen extends StatefulWidget {
  @override
  State<WorkerScreen> createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff625772),
      child: Scaffold(
        backgroundColor: Color(0xffFEFAEC),
        bottomNavigationBar: BottomNav(
          indexNum: 1,
        ),
        appBar: AppBar(
          backgroundColor: Color(0xff625772),
          title: Text("Gündelik"),
          centerTitle: true,
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
