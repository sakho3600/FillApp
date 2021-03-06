/// Yes No Card class
///
/// This class contains model for flash yes and no question card.
///
/// Imports:
///   MyColor constant class with all colors
///   Cloud_firestore for connection to the firebase
///   ScreenUtil class for respnsive desing
///
/// Authors: Sena Cikic, Danis Preldzic, Adi Cengic, Jusuf Elfarahati
/// Tech387 - T2
/// Feb, 2020

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fillproject/components/SurveyCardYesNo/components/statuSurvey.dart';
import 'package:fillproject/components/SurveyCardYesNo/surveyCard.dart';
import 'package:fillproject/components/constants/myColor.dart';
import 'package:fillproject/components/myProgressNumbers.dart';
import 'package:fillproject/components/myQuestion.dart';
import 'package:fillproject/components/myQuestionSAR.dart';
import 'package:fillproject/components/pageRouteBuilderAnimation.dart';
import 'package:fillproject/dashboard/survey.dart';
import 'package:fillproject/firebaseMethods/firebaseCrud.dart';
import 'package:fillproject/globals.dart';
import 'package:fillproject/localization/app_localizations.dart';
import 'package:fillproject/models/Survey/surveyModel.dart';
import 'package:fillproject/routes/routeArguments.dart';
import 'package:fillproject/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class MySurveyGroupCard extends StatefulWidget {
  final PasswordArguments arguments;
  final String name, username, usernameSecond;
  final int answered, total, sar, userSar, userLevel;
  final DocumentSnapshot doc, userDoc;
  final Survey surveyDoc;
  final List<dynamic> snapQuestions,
      usernameFinal,
      userProgress,
      usernameAnswers;
  MySurveyGroupCard({
    this.arguments,
    this.sar,
    this.userSar,
    this.name,
    this.answered,
    this.total,
    this.snapQuestions,
    this.username,
    this.doc,
    this.userDoc,
    this.surveyDoc,
    this.usernameFinal,
    this.usernameSecond,
    this.userProgress,
    this.userLevel,
    this.usernameAnswers,
  });

  @override
  _MySurveyGroupCard createState() => _MySurveyGroupCard();
}

class _MySurveyGroupCard extends State<MySurveyGroupCard>
    with AutomaticKeepAliveClientMixin<MySurveyGroupCard> {
  bool isCompleted = false, isFirst = false, justToggle = false;
  int number, totalNumber;
  List<dynamic> endProgress;
  var user;

  @override
  void initState() {
    super.initState();
    if (usernameFinal.contains(widget.username) == false &&
        usernameFinal.contains(usernameSecond) == false) {
      isCompleted = false;
    } else {
      isCompleted = true;
    }
    Timer(Duration(seconds: 1), () {
      setState(() {
        justToggle = !justToggle;
      });
      getUserProgress();
    });
    getUserProgress();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    SizeConfig().init(context);

    surveyListOfAnswers() async {
      String listName;
      listName = widget.surveyDoc.name;
      List<String> answersOfCurrentSurvey;
      var prefs = await SharedPreferences.getInstance();
      answersOfCurrentSurvey = prefs.getStringList('$listName');
      if(answersOfCurrentSurvey == null) {
        prefs.setStringList('$listName', [listName]);
        answersOfCurrentSurvey = prefs.getStringList('$listName');
      } else {
      }
      offlineAnswers = answersOfCurrentSurvey;
    }

    return GestureDetector(
      onTap: () {
        if (!isCompleted) {
          surveyListOfAnswers();
          Navigator.of(context).push(CardAnimationTween(
              widget: SurveyCard(
                  surveyDoc: widget.surveyDoc,
                  userLevel: userLevel,
                  usernameSecond: widget.usernameSecond,
                  notifyParent: refreshState,
                  user: user,
                  userDoc: widget.userDoc,
                  sarSurvey: widget.sar,
                  number: number,
                  increaseAnswered: increaseAnswered,
                  userSar: widget.userSar,
                  arguments: PasswordArguments(
                    email: widget.arguments.email,
                    password: widget.arguments.password,
                    phone: widget.arguments.phone,
                    username: widget.arguments.username,
                  ),
                  isCompleted: setColor,
                  doc: widget.doc,
                  username: widget.username,
                  snapQuestions: widget.snapQuestions,
                  total: totalNumber)));
        }
      },
      child: Container(
          key: UniqueKey(),
          width: ScreenUtil.instance.setWidth(340.0),
          height: ScreenUtil.instance.setWidth(275.0),
          margin: EdgeInsets.only(
              left: ScreenUtil.instance.setWidth(30.0),
              right: ScreenUtil.instance.setWidth(30.0),
              bottom: ScreenUtil.instance.setWidth(50.0)),
          decoration: BoxDecoration(
              border: Border.all(
                  color: isCompleted ? Color.fromRGBO(74, 85, 98, 1.0) : Color.fromRGBO(74, 85, 98, 1.0),
                  width: 3.0),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: isCompleted ? MyColor().white : Color.fromRGBO(74, 85, 98, 1.0)),
          child: Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil.instance.setWidth(37.0),
                  right: ScreenUtil.instance.setWidth(37.0),
                  top: ScreenUtil.instance.setWidth(15.0)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.instance.setWidth(5.0)),
                          child: MyQuestionSAR(
                            text: '+' + widget.sar.toString() + ' ' + AppLocalizations.of(context).translate('SAR'),
                            isCompleted: isCompleted,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.instance.setWidth(5.0),
                              left: ScreenUtil.instance.setWidth(83.0)),
                          child: MyProgressNumbers(
                              isCompleted: isCompleted,
                              answered: isCompleted ? widget.total : number,
                              total: widget.total),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil.instance.setWidth(50.0)),
                      child: MyQuestion(
                          isCompleted: isCompleted,
                          question: widget.name,
                          containerHeight:  10),
                    ),
                    StatusSurvey(isCompleted: isCompleted, number: number, total: widget.total),
                  ]))),
    );
  }

  setColor() {
    setState(() {
      isCompleted = true;
    });
  }

  increaseAnswered() {
    setState(() {
      number++;
    });
    FirebaseCrud().deleteListOfUsernamesThatGaveAnswersProgress(
        widget.doc, context, widget.username + ',' + number.toString());
    FirebaseCrud().updateListOfUsernamesThatGaveAnswersProgress(
        widget.doc, context, widget.username + ',' + number.toString());
  }

  getUserProgress() {
    if (widget.userProgress.length == null || widget.userProgress.length == 0) {
      number = 0;
    } else {
      for (int i = 0; i < widget.userProgress.length; i++) {
        var usernameProgress = widget.userProgress[i].toString();
        user = usernameProgress.split(',');
        var progressNum = user[1];
        if (user[0] == widget.username || user[0] == widget.usernameSecond) {
          number = int.parse(progressNum);
        } else {
          number = 0;
        }
      }
    }
  }

  refreshState() {
    setState(() {
      justToggle = !justToggle;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
