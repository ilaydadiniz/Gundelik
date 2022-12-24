// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/global_methods.dart';
import 'package:deneme/others/job_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../log_sign_screen/bottom_nav_page.dart';
import 'global_variables.dart';

class UpLoadJob extends StatefulWidget {
  @override
  State<UpLoadJob> createState() => _UpLoadJobState();
}

class _UpLoadJobState extends State<UpLoadJob> {
  final TextEditingController _jobCategoryController =
      TextEditingController(text: "Kategori Seç");
  final TextEditingController _jobTitleController =
      TextEditingController(text: "Bir Açıklama Ekle");
  final TextEditingController _jobDescriptionController =
      TextEditingController(text: "Select Description Title");
  final TextEditingController _deadController =
      TextEditingController(text: "Tarihi Seç ");

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadlineDataTimeStamp;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _deadController.dispose();
  }

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xff625772),
          fontSize: 17,
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFormFields(
      {required String valueKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == 'JobDescription' ? 4 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xff625772),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))),
        ),
      ),
    );
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Color(0xffFEFAEC),
            title: Text(
              "Job Category",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Color(0xff625772)),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Category.jobCategoryList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _jobCategoryController.text =
                              Category.jobCategoryList[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              Category.jobCategoryList[index],
                              style: TextStyle(
                                  color: Color(0xff625772), fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xff625772),
                ),
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          );
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        Duration(days: 0),
      ),
      lastDate: DateTime(2200),
    );
    if (picked != null) {
      setState(() {
        _deadController.text =
            "${picked!.year}-${picked!.month}-${picked!.day}";
        deadlineDataTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _upLoadTask() async {
    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user?.uid;
    final isValid = _formKey.currentState?.validate();

    if (isValid != null) {
      if (_deadController.text == "Choose job Deadline date" ||
          _jobCategoryController.text == "Choose job category") {
        GlobalMethod.showErrorDialog(
            error: "Please pick everything", ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection("jobs").doc(jobId).set({
          "jobId": jobId,
          "uploadedBy": _uid,
          "email": user!.email,
          "jobDescription": _jobDescriptionController.text,
          "deadlineDate": _deadController.text,
          "deadlineDateTimeStamp": deadlineDataTimeStamp,
          "jobCategory": _jobCategoryController.text,
          "jobComments": [],
          "recruitment": true,
          "createdAt": Timestamp.now(),
          "name": name,
          "userImage": userImage,
          "location": location,
          "applicants": 0,
        });
        await Fluttertoast.showToast(
            msg: "The task has been uploaded",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.grey,
            fontSize: 18.0);

        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = "Choose job category";
          _deadController.text = "Choose job Deadline date";
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Its not valid");
    }
  }

  /*void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      name = userDoc.get("name");
      userImage = userDoc.get("userImage");
      location = userDoc.get("location");
    });
  }*/

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyData();
  }*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Color(0xffFEFAEC),
      child: Scaffold(
        backgroundColor: Color(0xffFEFAEC),
        bottomNavigationBar: BottomNav(
          indexNum: 2,
        ),
        appBar: AppBar(
          backgroundColor: Color(0xff625772),
          title: Text("Gündelik"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(7.0),
            child: Container(
              color: Color(0xffFEFAEC),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Bir İş İlanı Yayınla !",
                        style: TextStyle(
                          color: Color(0xff625772),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(
                              label: "İş Kategorisi  ",
                            ),
                            _textFormFields(
                              valueKey: "JobCategory",
                              controller: _jobCategoryController,
                              enabled: false,
                              fct: () {
                                _showTaskCategoriesDialog(size: size);
                              },
                              maxLength: 100,
                            ),
                            _textTitles(label: "İş Hakkında Bilgi Ver !"),
                            _textFormFields(
                                valueKey: "JobTitle",
                                controller: _jobTitleController,
                                enabled: true,
                                fct: () {},
                                maxLength: 100),
                            _textTitles(label: "İş Günü "),
                            _textFormFields(
                                valueKey: "Date",
                                controller: _deadController,
                                enabled: false,
                                fct: () {
                                  _pickDateDialog();
                                },
                                maxLength: 100),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : MaterialButton(
                                onPressed: () {
                                  _upLoadTask();
                                },
                                color: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Yayınla !",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ]),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
