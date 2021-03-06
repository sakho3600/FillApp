import 'package:fillproject/components/SurveyCardYesNo/components/surveyCardComponents/orderComponents/listOfChoices.dart';
import 'package:fillproject/components/answerLabelContainer.dart';
import 'package:fillproject/components/emptyCont.dart';
import 'package:fillproject/globals.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatelessWidget {
  final widget;
  final int index, numberOfQuestions, number;
  final Function refresh;
  OrderWidget(
      {Key key,
      this.widget,
      this.index,
      this.refresh,
      this.number,
      this.numberOfQuestions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isSummary ? AnswerLabel() : EmptyContainer(),
        ListOfChoices(
            index: index,
            widget: widget,
            refresh: refresh,
            numberOfQuestions: numberOfQuestions,
            number: number,
            doc: widget.doc,
            username: widget.username,
            title: widget.snapQuestions[index]['title']),
      ],
    );
  }
}
