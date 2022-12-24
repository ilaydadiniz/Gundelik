// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> with TickerProviderStateMixin {
  final _SignInFormKey = GlobalKey<FormState>();
  File? imageFile;
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? imageUrl;

  final TextEditingController _fullNameController =
      TextEditingController(text: '');
  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();

    super.dispose();
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Please choose an option"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Camera ",
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Gallery ",
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _getFromCamera() async {
    XFile? PickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(PickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(PickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void _submitFormOnSignIn() async {
    final isValid = _SignInFormKey.currentState!.validate();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethod.showErrorDialog(
          error: "Please pick an image",
          ctx: context,
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passTextController.text.trim());
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child("userImages")
            .child(_uid + ".jpg");
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();

        FirebaseFirestore.instance.collection("users").doc(_uid).set({
          "id": _uid,
          "name": _fullNameController.text,
          "email": _emailTextController.text,
          "userImage": imageUrl,
          "createdAt": Timestamp.now(),
        });

        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color(0xffBCCEF8),
      body: SafeArea(
        child: Container(
          color: Color(0xffFEFAEC),
          child: Column(
            children: [
              /*CachedNetworkImage(
                imageUrl:signInUrlImage,
                placeholder: (context,url)=>Image.asset(
                  "assets/images/bne.jpg"//buraya resim
                  fit:BoxFit.fill,

                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: FractionalOffset(),
                
                
                ),*/
              Container(
                //height: screenHeight * 0.3,
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(height: 36.0),
                    Image.asset("assets/images/loginnn.png"),
                  ],
                ),
              ), //welcome olan kısım
              SizedBox(height: 20),
              Column(
                children: [
                  Form(
                    key: _SignInFormKey,
                    child: Container(
                      width: screenWidth,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showImageDialog();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                width: screenWidth * 0.25,
                                height: screenHeight * 0.25,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: imageFile == null
                                        ? const Icon(Icons.camera_enhance_sharp,
                                            color: Colors.black)
                                        : Image.file(
                                            imageFile!,
                                            fit: BoxFit.fill,
                                          )),
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                "       Create an account !",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(_emailFocusNode),
                                  keyboardType: TextInputType.name,
                                  controller: _fullNameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This Field is Missing";
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Name/Company Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ), //email
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(_passFocusNode),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailTextController,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return "Please enter a valid Email adress";
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "E-mail",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(_passFocusNode),
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: _passTextController,
                                  obscureText: !_obscureText,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter a valid password !";
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
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                width: screenWidth,
                decoration: BoxDecoration(),
                child: Column(
                  children: [
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
                                  _submitFormOnSignIn();
                                },
                                child: Text(
                                  "Create an Account ! ",
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
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                      ),
                      child: Text(
                        "Have an account ? Login",
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
        ),
      ),
    );
  }
}
