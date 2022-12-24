import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deneme/job_main/search_bar.dart';
import 'package:deneme/log_sign_screen/bottom_nav_page.dart';
import 'package:deneme/others/job_widget.dart';
import 'package:flutter/material.dart';

import '../others/job_category.dart';

class JobPage extends StatefulWidget {
  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  String? jobCategoryFilter;
  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Job Category",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
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
                          jobCategoryFilter = Category.jobCategoryList[index];
                        });
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                        print(
                            "jobCategoryList[index],${Category.jobCategoryList[index]}");
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Color(0xff625772),
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
                  "Filtrele",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    jobCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  "Çıkış",
                  style: TextStyle(color: Color(0xff625772)),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xffFEFAEC),
        bottomNavigationBar: BottomNav(indexNum: 0),
        appBar: AppBar(
          backgroundColor: Color(0xff625772),
          title: Text("Gündelik"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              _showTaskCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (c) => WorkerScreen()),
                );
              },
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("jobs")
                .where("jobCategory", isEqualTo: jobCategoryFilter)
                .where("recruitment", isEqualTo: true)
                .orderBy("createdAt", descending: false)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data?.docs.isNotEmpty == true) {
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return JobWidget(
                            jobTitle: snapshot.data?.docs[index]["jobTitle"],
                            jobDescription: snapshot.data?.docs[index]
                                ["jobDescription"],
                            jobId: snapshot.data?.docs[index]["jobId"],
                            uploadedBy: snapshot.data!.docs[index]
                                ["UploadedBy"],
                            userImage: snapshot.data?.docs[index]["userImage"],
                            name: snapshot.data?.docs[index]["name"],
                            recruitment: snapshot.data?.docs[index]
                                ["recruitment"],
                            email: snapshot.data?.docs[index]["email"],
                            location: snapshot.data?.docs[index]["location"]);
                      });
                } else {
                  return Center(
                    child: Text("There is no jobs"),
                  );
                }
              }
              return Center(
                child: Text(
                  "Something went wrong",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              );
            }));
  }
}
