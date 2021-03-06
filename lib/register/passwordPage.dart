/// Password class
///
/// This class contains methods and layout for dashboard page.
///
/// Imports:
///   MyColor constant class with all colors
///   ScreenUtil class for respnsive desing
///   Routes
///   Database methods class
///
/// Authors: Sena Cikic, Danis Preldzic, Adi Cengic, Jusuf Elfarahati
/// Tech387 - T2
/// Feb, 2020

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fillproject/components/constants/myColor.dart';
import 'package:fillproject/components/emptyCont.dart';
import 'package:fillproject/components/mySnackbar.dart';
import 'package:fillproject/components/myTextComponent.dart';
import 'package:fillproject/components/myValidation.dart';
import 'package:fillproject/components/pageRouteBuilderAnimation.dart';
import 'package:fillproject/dashboard/navigationBarController.dart';
import 'package:fillproject/firebaseMethods/firebaseCheck.dart';
import 'package:fillproject/firebaseMethods/firebaseCrud.dart';
import 'package:fillproject/localization/app_localizations.dart';
import 'package:fillproject/register/components/privacy.dart';
import 'package:fillproject/register/components/terms.dart';
import 'package:fillproject/register/emailAndDOB.dart';
import 'package:fillproject/register/verifyPinPage.dart';
import 'package:fillproject/routes/routeArguments.dart';
import 'package:fillproject/utils/screenUtils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

String password, username = "";
int _btnCounter = 0, isAnonymous, oldSar;
bool isLoggedIn = false;
DocumentSnapshot snap;

class PasswordPage extends StatefulWidget {
  final RegisterArguments arguments;

  PasswordPage({this.arguments});

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = new TextEditingController();

  Widget getIsAnonymousUser() {
    return FutureBuilder(
      future: FirebaseCheck().getUserUsername(widget.arguments.usernameSecond),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                snap = snapshot.data[index];
                isAnonymous = snap.data['is_anonymous'];
                oldSar = snap.data['sar'];
                return EmptyContainer();
              });
        }
        return EmptyContainer();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getIsAnonymousUser();
  }

  @override
  Widget build(BuildContext context) {
    Constant().responsive(context);
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        title: new Text(""),
        backgroundColor: Color.fromRGBO(74, 85, 98, 1.0),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: MyColor().white,
          onPressed: () {
            Navigator.of(context).push(
              CardAnimationTween(
                widget: NameAndDOB(
                    arguments: RegisterArguments(
                      email: widget.arguments.email,
                        verId: widget.arguments.verId,
                        nameAndUsername: widget.arguments.nameAndUsername,
                        dateBirth: widget.arguments.dateBirth,
                        username: widget.arguments.username,
                        usernameSecond: widget.arguments.usernameSecond,
                        phone: widget.arguments.phone)),
              ),
            );
          },
        ),
      ),
      backgroundColor: Color.fromRGBO(74, 85, 98, 1.0),
      body: Builder(
        builder: (context) => new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  getIsAnonymousUser(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil.instance.setWidth(28.0),
                        bottom: ScreenUtil.instance.setWidth(35.0)),
                    child: MyTextComponent(
                        text: AppLocalizations.of(context)
                            .translate('setUpAPassword')),
                  ),
                  Text(AppLocalizations.of(context).translate('fiveSAR'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setSp(40),
                        color: MyColor().white,
                      )),
                  Container(
                      width: ScreenUtil.instance.setWidth(316.0),
                      height: ScreenUtil.instance.setHeight(92.0),
                      margin: EdgeInsets.only(
                          bottom: ScreenUtil.instance.setWidth(19.0),
                          top: ScreenUtil.instance.setWidth(28.0)),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          enableSuggestions: false,
                          controller: passwordController,
                          decoration: InputDecoration(
                            hasFloatingPlaceholder: false,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: ScreenUtil.instance.setWidth(20.0),
                                horizontal: ScreenUtil.instance.setWidth(35.0)),
                            labelText: AppLocalizations.of(context)
                                .translate('password'),
                            labelStyle: TextStyle(
                                color: MyColor().white,
                                fontSize: ScreenUtil.instance.setSp(16.0)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33.5)),
                              borderSide: BorderSide(color: MyColor().white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33.5)),
                              borderSide: BorderSide(color: MyColor().white),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33.5)),
                              borderSide: BorderSide(
                                color: MyColor().error,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(33.5)),
                              borderSide: BorderSide(
                                color: MyColor().error,
                              ),
                            ),
                          ),
                          style: TextStyle(color: MyColor().white),
                          obscureText: true,
                          validator: (password) => MyValidation()
                              .validatePassword(password, context),
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: ScreenUtil.instance.setWidth(21.0),
                        left: ScreenUtil.instance.setWidth(43.0),
                        right: ScreenUtil.instance.setWidth(43.0)),
                    width: ScreenUtil.instance.setWidth(316.0),
                    child: RichText(
                      overflow: TextOverflow.visible,
                      text: new TextSpan(children: [
                        new TextSpan(
                          text: AppLocalizations.of(context)
                              .translate('byTappingSignIn&Accept'),
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil.instance.setSp(12)),
                        ),
                        new TextSpan(
                            text: AppLocalizations.of(context)
                                .translate('privacy'),
                            style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil.instance.setSp(12)),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                _save();
                                Navigator.of(context).push(
                                    CardAnimationTween(widget: Privacy()));
                              }),
                        new TextSpan(
                          text: AppLocalizations.of(context)
                              .translate('andAgree'),
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil.instance.setSp(12)),
                        ),
                        new TextSpan(
                            text:
                                AppLocalizations.of(context).translate('terms'),
                            style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil.instance.setSp(12)),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                _save();
                                Navigator.of(context)
                                    .push(CardAnimationTween(widget: Terms()));
                              })
                      ]),
                    ),
                  ),
                  Container(
                      width: ScreenUtil.instance.setWidth(316.0),
                      height: ScreenUtil.instance.setHeight(67.0),
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(33.5),
                          ),
                          onPressed: () async {
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              if (result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                onPressed(context);
                                _save();
                              }
                            } on SocketException catch (_) {
                              MySnackbar().showSnackbar(
                                  AppLocalizations.of(context)
                                      .translate('noIternent'),
                                  context,
                                  AppLocalizations.of(context)
                                      .translate('undo'));
                            }
                          },
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('signUp&Accept'),
                              style: TextStyle(
                                  fontSize: ScreenUtil.instance.setSp(18))))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onPressed(BuildContext context) {
    password = passwordController.text;
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      if (_btnCounter == 0) {
        loginUser(widget.arguments.username, isLoggedIn);
        if (isAnonymous == 1) {
          oldSar = oldSar + 5;
          FirebaseCrud().updateUser(
              snap,
              widget.arguments.email,
              widget.arguments.phone,
              widget.arguments.username,
              widget.arguments.nameAndUsername,
              widget.arguments.dateBirth,
              widget.arguments.usernameSecond,
              password,
              oldSar);
        } else {
          FirebaseCrud().createUser(
              widget.arguments.nameAndUsername,
              widget.arguments.dateBirth,
              widget.arguments.email,
              widget.arguments.phone,
              widget.arguments.username,
              password,
              5,
              0);
        }
        Navigator.of(context).push(
          CardAnimationTween(
            widget: BottomNavigationBarController(
                arguments: PasswordArguments(
                    email: widget.arguments.email,
                    phone: widget.arguments.phone,
                    username: widget.arguments.username,
                    password: password)),
          ),
        );
        _btnCounter = 1;
        Timer(Duration(seconds: 2), () {
          _btnCounter = 0;
        });
      }
    }
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_password';
    final value = password;
    prefs.setString(key, value);
  }

  Future<Null> loginUser(String username, bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    setState(() {
      username = username;
      isLoggedIn = true;
    });
  }
}
