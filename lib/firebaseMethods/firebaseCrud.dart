/// Firebase CRUD  class
///
/// This class contains methods (CRUD) for the app.
///
/// Imports:
///   Cloud_firestore for connection to the firebase
///   Routes
///   Random String class for generating String which is used for custom username for anonymous users
///
/// Authors: Sena Cikic, Danis Preldzic, Adi Cengic, Jusuf Elfarahati
/// Tech387 - T2
/// Feb, 2020

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fillproject/routes/routeConstants.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

final db = Firestore.instance;

class FirebaseCrud {
  /// create function
  ///
  /// upis u firestore collection
  createUser(String email, String phone, String username, String password,
      int sar, int isAnonymous) async {
    await db.collection('Users').add({
      'email': email,
      'username': username,
      'username_second': '',
      'password': password,
      'phone': phone,
      'is_anonymous': isAnonymous,
      'user_id': randomAlphaNumeric(15),
      'level': 1,
      'sar': sar,
    });
  }

  /// update function for user that is anonymous and wants to become registered user
  ///
  /// we only need to update specific fields,
  /// we don't need to update user_id,
  /// (ako vidis jos koju stvar da je viska izbaci)
  updateUser(DocumentSnapshot doc, String email, String phone, String username,
      String usernameSecond, String password, int sar) async {
    await db.collection('Users').document(doc.documentID).updateData({
      'email': email,
      'username': username,
      'username_second': usernameSecond,
      'password': password,
      'phone': phone,
      'is_anonymous': 0,
      'sar': sar,
    });
  }

  /// [updatePassword]
  ///
  /// function that updates users password ,
  /// forgot password
  updatePassword(
      DocumentSnapshot doc, BuildContext context, String password) async {
    await db
        .collection('Users')
        .document(doc.documentID)
        .updateData({'password': '$password'});
    Navigator.of(context).pushNamed(Login);
  }

  /// [updateListOfUsernameAnswers]
  ///
  /// this function updates users answers in db
  updateListOfUsernameAnswers(DocumentSnapshot doc, BuildContext context,
      String username, String choice) async {
    await db.collection('Questions').document(doc.documentID).updateData({
      'listOfUsernameAnswers': FieldValue.arrayUnion(['$username : $choice'])
    });
  }

  /// [updateListOfUsernamesThatGaveAnswers]
  ///
  /// this function updates users that answer questions in db
  updateListOfUsernamesThatGaveAnswers(
      DocumentSnapshot doc, BuildContext context, String username) async {
    await db.collection('Questions').document(doc.documentID).updateData({
      'listOfUsernamesThatGaveAnswers': FieldValue.arrayUnion(['$username'])
    });
  }

  /// [updateUsersSars]
  ///
  /// this function updates users sars when he answers the question
  updateUsersSars(DocumentSnapshot doc, BuildContext context, int sar) async {
    await db
        .collection('Users')
        .document(doc.documentID)
        .updateData({'sar': sar});
  }

  /// [updateListOfUsernamesAnswersSurvey]
  ///
  /// this function updates users that answer questions in db
  updateListOfUsernamesAnswersSurvey(DocumentSnapshot doc, BuildContext context,
      String username, String choice, String title) async {
    await db.collection('QuestionsSurvey').document(doc.documentID).updateData({
      'list_of_username_answers': FieldValue.arrayUnion(['$title : $choice : $username']),
    });
  }
}
