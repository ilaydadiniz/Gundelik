// ignore_for_file: use_build_context_synchronously

import 'package:deneme/global_methods.dart';
import 'package:deneme/job_main/job_page.dart';
import 'package:deneme/log_sign_screen/sign_page.dart';
import 'package:deneme/job_main/search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController =
      TextEditingController(text: "");
  final TextEditingController _passTextController =
      TextEditingController(text: "");

  final FocusNode _passFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();

  void _submitFormOnLogin() async {
    final isValid = _loginFormKey?.currentState?.validate();
    if (isValid != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim(),
        );
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print("error $error");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffFEFAEC),
      body: SafeArea(
        child: Container(
          color: Color(0xffFEFAEC),
          child: Column(
            children: [
              Container(
                //height: screenHeight * 0.3,
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(height: 55.0),
                    Image.asset("assets/images/loginnn.png"),
                  ],
                ),
              ), //welcome olan kısım
              SizedBox(height: 25),
              Column(
                key: _loginFormKey,
                children: [
                  Form(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          width: 400.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_passFocusNode),
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailTextController,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains("@")) {
                                  return "Please enter a valid e-mail adress";
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //email
                  SizedBox(
                    height: 15,
                  ),
                  Form(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          width: 400.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _passFocusNode,
                              keyboardType: TextInputType.visiblePassword,
                              controller: _passTextController,
                              obscureText: !_obscureText,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return "Please enter a valid password";
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        "Sign into your account !         ",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    //height: screenHeight * 0.3,
                    width: screenWidth,
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            height: 40.0,
                            child: SizedBox(
                              height: 40.0,
                              width: 300.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitFormOnLogin();
                                  Get.to(JobPage());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff625772),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80),
                                      side: BorderSide(
                                          width: 1, color: Colors.white)),
                                  padding: EdgeInsets.all(0.0),
                                  alignment: Alignment.center,
                                ),
                                /*() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>   JobPage(),
                                    ),
                                  );
                                },*/
                                child: Text(
                                  "Login ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SigninPage(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                          ),
                          child: Text(
                            "Don\'t have an account ? Create",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ), //sign in
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
