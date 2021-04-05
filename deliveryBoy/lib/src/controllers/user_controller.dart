import 'package:TuGoRepartidor/api/register.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

import 'package:TuGoRepartidor/api/login.dart';

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  // FirebaseMessaging _firebaseMessaging;

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // _firebaseMessaging = FirebaseMessaging();
    // _firebaseMessaging.getToken().then((String _deviceToken) {
    //   user.deviceToken = _deviceToken;
    // });
  }

  void login() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      // repository.login(user).then((value) {
      //   //print(value.apiToken);
      //   if (value != null && value.apiToken != null) {
      //     scaffoldKey.currentState.showSnackBar(SnackBar(
      //       content: Text(S.current.welcome + value.name),
      //     ));
      //     Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
      //   } else {
      //     scaffoldKey.currentState.showSnackBar(SnackBar(
      //       content: Text(S.current.wrong_email_or_password),
      //     ));
      //   }
      // });

      bool status = await loginUser("${user.email}", "${user.password}");
      if (status) {
        Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed('/Pages', arguments: 2);
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("El usuario o contraseña son incorrectos"),
        ));
      }
    }
  }

  Future<bool> register() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      // repository.register(user).then((value) {
      //   if (value != null && value.apiToken != null) {
      //     scaffoldKey.currentState.showSnackBar(SnackBar(
      //       content: Text(S.current.welcome + value.name),
      //     ));
      //     Navigator.of(scaffoldKey.currentContext)
      //         .pushReplacementNamed('/Pages', arguments: 2);
      //   } else {
      //     scaffoldKey.currentState.showSnackBar(SnackBar(
      //       content: Text(S.current.wrong_email_or_password),
      //     ));
      //   }
      // });
      bool status = await registerUser("${user.email}", "${user.password}");
      if(status){
            // Navigator.of(scaffoldKey.currentContext)
            // .pushReplacementNamed('/CompleteInformation');
            return true;  
      }else{
        // scaffoldKey.currentState.showSnackBar(SnackBar(
        //   content: Text("Ha ocurrido un problema"),
        // ));
        return false;
      }
    } 
  }
  Future<bool> registerComplete(int idUser) async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      // repository.register(user).then((value) {
      //   if (value != null && value.apiToken != null) {
      //     scaffoldKey.currentState.showSnackBar(SnackBar(
      //       content: Text(S.current.welcome + value.name),
      //     ));
      //     Navigator.of(scaffoldKey.currentContext)
      //         .pushReplacementNamed('/Pages', arguments: 2);
      //   } else {
      //     scaffoldKey.currentState.showSnackBar(SnackBar(
      //       content: Text(S.current.wrong_email_or_password),
      //     ));
      //   }
      // });
      bool status = await completeProfileUser( idUser, "${user.name}", "${user.lastname}", "${user.phone}", "${user.birthdate}", "${user.dni}", "${user.doc}");
      if(status){
            // Navigator.of(scaffoldKey.currentContext)
            // .pushReplacementNamed('/Pages'); 
            return true; 
      }else{
        // scaffoldKey.currentState.showSnackBar(SnackBar(
        //   content: Text("Ha ocurrido un problema"),
        // ));
        return false;
        }
      //print("el controlador es ${user.dni}");
      }
    } 
  }

