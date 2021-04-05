import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../config/app_config.dart' as config;
import '../../generated/i18n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
          child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _con.scaffoldKey,
          resizeToAvoidBottomPadding: false,
          body: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Positioned(
                top: 0,
                child: Container(
                  width: config.App(context).appWidth(100),
                  height: config.App(context).appHeight(29.5),
                  decoration: BoxDecoration(color: Theme.of(context).accentColor),
                ),
              ),
              Positioned(
                top: config.App(context).appHeight(29.5) - 120,
                child: Container(
                  width: config.App(context).appWidth(84),
                  height: config.App(context).appHeight(29.5),
                  child: Text(
                    "¡Vamos!, Empecemos creando una cuenta.",
                    style: Theme.of(context).textTheme.display3.merge(TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
              Positioned(
                top: config.App(context).appHeight(29.5) - 50,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 50,
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                        )
                      ]),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 27),
                  width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                  child: Form(
                    key: _con.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => _con.user.email = input,
                          validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                          decoration: InputDecoration(
                            labelText: "Correo Electrónico",
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'johndoe@gmail.com',
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          obscureText: _con.hidePassword,
                          onSaved: (input) => _con.user.password = input,
                          validator: (input) => input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            labelStyle: TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: '••••••••••••',
                            hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                            prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _con.hidePassword = !_con.hidePassword;
                                });
                              },
                              color: Theme.of(context).focusColor,
                              icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          ),
                        ),
                        SizedBox(height: 30),
                        BlockButtonWidget(
                          text: Text(
                            "Registrarse",
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            EasyLoading.show(status: 'Cargando...');
                            _con.register().then((value) {
                              if(value){
                                EasyLoading.dismiss();
                                 Navigator.pushReplacementNamed(context, '/CompleteInformation');

                              }else{
                                EasyLoading.dismiss();
                              }
                            });
                          },
                        ),
                        SizedBox(height: 25),
//                      FlatButton(
//                        onPressed: () {
//                          Navigator.of(context).pushNamed('/MobileVerification');
//                        },
//                        padding: EdgeInsets.symmetric(vertical: 14),
//                        color: Theme.of(context).accentColor.withOpacity(0.1),
//                        shape: StadiumBorder(),
//                        child: Text(
//                          'Register with Google',
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                            color: Theme.of(context).accentColor,
//                          ),
//                        ),
//                      ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/Login');
                  },
                  textColor: Theme.of(context).hintColor,
                  child: Text('¿Ya tienes una cuenta?, Inicia Sesíon'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
