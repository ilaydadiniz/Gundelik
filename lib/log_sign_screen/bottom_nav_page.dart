import 'package:deneme/job_main/job_page.dart';
import 'package:deneme/job_main/profile_page.dart';
import 'package:deneme/job_main/search_bar.dart';
import 'package:deneme/job_main/upLoadJob.dart';
import 'package:deneme/log_sign_screen/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNav extends StatelessWidget {
  int indexNum = 0;

  BottomNav({required this.indexNum});

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
            ],
          ),
          content: const Text(
            "Do you want to Logout ?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "No ",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              child: const Text(
                "Yes ",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: const Color(0xff625772),
      backgroundColor: const Color(0xffFEFAEC),
      buttonBackgroundColor: const Color(0xff625772),
      height: 50,
      index: indexNum,
      items: [
        const Icon(
          Icons.list,
          size: 19,
          color: Colors.white,
        ),
        const Icon(
          Icons.search,
          size: 19,
          color: Colors.white,
        ),
        const Icon(
          Icons.add,
          size: 19,
          color: Colors.white,
        ),
        const Icon(
          Icons.person_pin,
          size: 19,
          color: Colors.white,
        ),
        const Icon(
          Icons.exit_to_app,
          size: 19,
          color: Colors.white,
        ),
      ],
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => JobPage()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => WorkerScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UpLoadJob()));
        } else if (index == 3) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const ProfilePage()));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
