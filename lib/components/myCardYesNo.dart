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
import 'package:fillproject/components/constants/myColor.dart';
import 'package:fillproject/components/constants/myText.dart';
import 'package:fillproject/components/myCardNoChoice.dart';
import 'package:fillproject/components/myCardYesChoice.dart';
import 'package:fillproject/components/myQuestion.dart';
import 'package:fillproject/components/myQuestionSAR.dart';
import 'package:fillproject/localization/app_localizations.dart';
import 'package:fillproject/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCardYesNo extends StatefulWidget {
  final String question, username;
  final int sar, target, usersSar;
  final List<dynamic> snapi;
  final int index;
  final Function notifyParent, refreshNavbar;
  final DocumentSnapshot doc, snap;
  final ValueKey key;
  final bool isSar;

  MyCardYesNo({
    this.question,
    this.key,
    this.sar,
    this.isSar,
    this.usersSar,
    this.index,
    this.snapi,
    this.snap,
    this.notifyParent,
    this.target,
    this.doc,
    this.username,
    this.refreshNavbar,
  });

  @override
  _MyCardYesNoState createState() => _MyCardYesNoState();
}

class _MyCardYesNoState extends State<MyCardYesNo> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
        key: widget.key,
        width: SizeConfig.safeBlockHorizontal * 88,
        height: SizeConfig.blockSizeVertical * 35,
        margin: EdgeInsets.only(
            left: ScreenUtil.instance.setWidth(12.0),
            top: SizeConfig.blockSizeVertical * 10,
            right: ScreenUtil.instance.setWidth(12.0)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Color.fromRGBO(74, 85, 98, 1.0),),
        child: Padding(
          padding: EdgeInsets.only(
              left: ScreenUtil.instance.setWidth(40.0),
              right: ScreenUtil.instance.setWidth(40.0),
              top: ScreenUtil.instance.setWidth(15.0)),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: ScreenUtil.instance.setWidth(5.0)),
                  child: MyQuestionSAR(
                    text: widget.sar.toString() +
                        ' ' +
                        AppLocalizations.of(context).translate('SAR'),
                    isCompleted: false,
                  ),
                ),
                Container(
                  child: MyQuestion(
                      isCompleted: false,
                      question: widget.question,
                      containerHeight: 20 ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.blockSizeHorizontal * 10),
                    child: Row(
                      children: <Widget>[
                        MyYesChoice(
                            choice: MyText().willYes,
                            snapi: widget.snapi,
                            usersSars: widget.usersSar,
                            sar: widget.sar,
                            isSar: widget.isSar,
                            snap: widget.snap,
                            index: widget.index,
                            notifyParent: widget.notifyParent,
                            target: widget.target,
                            doc: widget.doc,
                            marginRight: ScreenUtil.instance.setWidth(0.0),
                            username: widget.username),
                        MyNoChoice(
                            choice: MyText().willNo,
                            snapi: widget.snapi,
                            usersSars: widget.usersSar,
                            snap: widget.snap,
                            isSar: widget.isSar,
                            sar: widget.sar,
                            index: widget.index,
                            notifyParent: widget.notifyParent,
                            target: widget.target,
                            doc: widget.doc,
                            marginRight: 35.0,
                            username: widget.username)
                      ],
                    ),
                  ),
                )
              ]),
        ));
  }
}
