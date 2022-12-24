/*import 'package:deneme/job_main/job_page.dart';
import 'package:deneme/log_sign_screen/first_dart.dart';
import 'package:deneme/log_sign_screen/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  
  @override
  
  Widget build(BuildContext context) {
    
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.data == null) {
          print("user is not logged in yet");
          return FirstPage();
        } else if (userSnapshot.hasData) {
          print("user is already logged in yet");
          return JobPage();
        } else if (userSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("An error has been occured.Try again later"),
            ),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          body: Center(child: Text("Something went wrong")),
        );
      },
    );
  }
}*/
