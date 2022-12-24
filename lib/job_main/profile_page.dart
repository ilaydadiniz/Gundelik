import 'package:deneme/log_sign_screen/first_dart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../log_sign_screen/bottom_nav_page.dart';
import '../user_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  String email = "ilaydadiniz@hotmail.com";
  String phoneNumber = "05548848161";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffFEFAEC),
      child: Scaffold(
          backgroundColor: Color(0xffFEFAEC),
          bottomNavigationBar: BottomNav(
            indexNum: 3,
          ),
          appBar: AppBar(
            backgroundColor: Color(0xff625772),
            title: Text("Gündelik"),
            centerTitle: true,
          ),
          body: Center(
            child: Stack(
              children: [
                SizedBox(
                  height: 20,
                ),
                Card(
                  color: Color(0xffFEFAEC),
                  //Color(0xffFEFAEC),
                  margin: EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 160,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "İlayda DİNİZ",
                            style: TextStyle(color: Colors.black, fontSize: 24),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.all(22.0),
                          child: Text(
                            "Hesap Bilgisi",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: userInfo(icon: Icons.email, content: email),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child:
                              userInfo(icon: Icons.phone, content: phoneNumber),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  _auth.signOut();
                                  Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => FirstPage()));
                                },
                                child: Text(
                                  "Çıkış Yap ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff625772),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80),
                                      side: BorderSide(
                                          width: 1, color: Colors.white)),
                                  padding: EdgeInsets.all(0.0),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FractionalTranslation(
                      translation: Offset(0.0, -0.34),
                      child: Align(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.purple,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage("assets/images/bne.jpg"),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
