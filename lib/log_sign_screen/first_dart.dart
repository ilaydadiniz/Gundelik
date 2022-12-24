import 'package:deneme/log_sign_screen/login_page.dart';
import 'package:deneme/log_sign_screen/sign_page.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Color(0xffFEFAEC),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset("assets/images/resim.png"),
            Center(
              child: Container(
                height: 40.0,
                child: Center(
                  child: Container(
                    height: 40.0,
                    child: SizedBox(
                      height: 40.0,
                      width: 300.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SigninPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Sıgn In ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff625772),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                              side: BorderSide(width: 1, color: Colors.white)),
                          padding: EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                height: 40.0,
                child: Center(
                  child: Container(
                    height: 40.0,
                    child: SizedBox(
                      height: 40.0,
                      width: 300.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff625772),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                              side: BorderSide(width: 1, color: Colors.white)),
                          padding: EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
