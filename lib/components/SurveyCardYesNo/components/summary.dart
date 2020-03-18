/// Summary Page class
///
/// This class contains methods and layout for Home page.
///
/// Imports:
///   MyColor constant class with all colors
///   Cloud_firestore for connection to the firebase
///   ScreenUtil class for respnsive desing
///   Routes
///   Database connections
///
/// Authors: Sena Cikic, Danis Preldzic, Adi Cengic, Jusuf Elfarahati
/// Tech387 - T2
/// Feb, 2020

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fillproject/components/SurveyCardYesNo/components/appBar.dart';
import 'package:fillproject/components/SurveyCardYesNo/components/summaryContainer.dart';
import 'package:fillproject/components/constants/myColor.dart';
import 'package:fillproject/components/emptyCont.dart';
import 'package:fillproject/dashboard/survey.dart';
import 'package:fillproject/firebaseMethods/firebaseCheck.dart';
import 'package:fillproject/globals.dart';
import 'package:fillproject/models/Survey/surveyModel.dart';
import 'package:fillproject/models/Survey/usernameAnswerModel.dart';
import 'package:fillproject/routes/routeArguments.dart';
import 'package:fillproject/utils/screenUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Summary extends StatefulWidget {
  final List<dynamic> questions, usernameAnswers;
  final int totalSar, userLevel;
  final int totalProgress;
  final Function animateTo;
  final PasswordArguments arguments;
  final DocumentSnapshot doc;
  final Survey surveyDoc;
  String surveyName;
  Summary(
      {this.totalSar,
      this.questions,
      this.totalProgress,
      this.animateTo,
      this.arguments,
      this.userLevel,
      this.usernameAnswers,
      this.doc,
      this.surveyDoc,
      this.surveyName});

  @override
  _SummaryState createState() => _SummaryState();
}

String title;

class _SummaryState extends State<Summary> {
  List<dynamic> answers = [];
  List<dynamic> usernameAns = [];
  List<dynamic> answersList = [];
  List<dynamic> userAnswersSplitted = [];
  int num = 0;
  String userAnswers, usernameThatAnswers;

  @override
  void initState() {
    super.initState();
    isOnSummary = true;
    //surveyName = widget.surveyDoc.name;
    //surveyGroupName = widget.surveyDoc.name;
    //print(widget.surveyDoc.usersAnswers);
  }

  @override
  Widget build(BuildContext context) {
    if (isFutureDone == false) {
      print('IZVRŠAVAM ISFUTUREDONE');
      setState(() {
        isFutureDone = true;
      });
    }
    Constant().responsive(context);
    //OVDJE PRAZNIM LISTU KADA PONOVO DODJEM NA SUMMARY KAKO NE BI MIJEŠAO ODGOVORE OD RANIJIH SRUVEYA
    answersList.removeRange(0, answersList.length);
    Timer(Duration(milliseconds: 1000), () {
      // OVDJE LOOPAM KROZ ODGOVORE I IZVLACIM IZ NJIH USERNAME
      for (var i = 0; i < answers.length; i++) {
        userAnswers = answers[i].toString();
        // //print(userAnswers);
        userAnswersSplitted = userAnswers.split(' : ');
        usernameThatAnswers = userAnswersSplitted[2];
        //print(usernameThatAnswers);
        // // /// usernameSecond treba
        //if (answersList == []) {
        // OVDJE NA OSNOVU USERNAME IZVLACIM ODGOVORE I SMJESTAM IH U LISTU KOJU PRINTAM
        if (userAnswersSplitted[2] == currentUsername) {
          //print(answers[i]);
          answersList.add(userAnswersSplitted[1]);
        }
        // }
      }
      printList();
    });
    return Scaffold(
      backgroundColor: MyColor().black,
      body: Builder(
        builder: (context) => WillPopScope(
            onWillPop: _onWillPop,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: 0,
                  width: 0,
                  child: FutureBuilder(
                      future: Future.delayed(Duration(milliseconds: 400)).then(
                          (value) => FirebaseCheck()
                              .getSurveyGroups(widget.userLevel)),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          snapi = snapshot.data
                              .map((doc) => Survey.fromDocument(doc))
                              .toList();
                          return ListView.builder(
                              itemCount: snapi.length,
                              itemBuilder: (BuildContext context, int index) {
                                print(surveyGroupName);
                                print(snapi[index].name);
                                // OVDJE PROVJERAVAM DA LI JE TO SURVEY NA KOJEM SAM I AKO JEST UZIMAM TU LISTU
                                if (surveyGroupName == snapi[index].name) {
                                  //print('Nasao sam pravi survey!!!!!!!!!!');
                                  // print(snapi[index].name);
                                  // print(snapi[index].usersAnswers);
                                  answers = snapi[index].usersAnswers;
                                }
                                //print(answersList);
                                //answersList.removeRange(0, answersList.length);
                                return EmptyContainer();
                              });
                        }
                        return Center(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }),
                ),
                SurveyAppBar(
                  percent: 1,
                  arguments: widget.arguments,
                  totalProgress: widget.totalProgress,
                  surveyDoc: widget.surveyDoc,
                  answersList: answersList,
                  // OVDJE SAM PROSLIJEĐIVO TAJ NAME U APPBAR
                  //surveyName: widget.surveyDoc.name
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil.instance.setWidth(25.0),
                      right: ScreenUtil.instance.setWidth(25.0)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            bottom: ScreenUtil.instance.setWidth(33.0)),
                        child: Center(
                          child: Text('Congratulation\nyou have got',
                              style: TextStyle(
                                color: MyColor().white,
                                fontWeight: FontWeight.w700,
                                fontFamily: "LoewNextArabic",
                                fontStyle: FontStyle.normal,
                                fontSize: ScreenUtil.instance.setSp(25.0),
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: ScreenUtil.instance.setWidth(44.0)),
                        child: Center(
                          child: Text(widget.totalSar.toString() + '\nSAR',
                              style: TextStyle(
                                color: MyColor().white,
                                fontWeight: FontWeight.w700,
                                fontFamily: "LoewNextArabic",
                                fontStyle: FontStyle.normal,
                                fontSize: ScreenUtil.instance.setSp(35.0),
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: ScreenUtil.instance.setWidth(15.0)),
                        child: Center(
                          child: Text('Summary',
                              style: TextStyle(
                                color: MyColor().white,
                                fontWeight: FontWeight.w700,
                                fontFamily: "LoewNextArabic",
                                fontStyle: FontStyle.normal,
                                fontSize: ScreenUtil.instance.setSp(25.0),
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: ScreenUtil.instance.setWidth(20.0)),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: widget.questions.length,
                            itemBuilder: (BuildContext context, int index) {
                              title = widget.questions[index]['title'];
                              return SummaryAnswerContainer(
                                surveyDoc: widget.surveyDoc,
                                answersList: answersList,
                                animateTo: widget.animateTo,
                                index: index,
                                question: title,
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  printList() {
    print(answersList);
  }

  Future<bool> _onWillPop() async {
    answersList.removeRange(0, answersList.length);
    setState(() {
      isOnSummary = false;
      isFutureDone = false;
    });
    return Navigator.of(context).pop() ?? true;
  }
}
