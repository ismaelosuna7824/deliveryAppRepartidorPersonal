import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:TuGoRepartidor/src/elements/CircularLoadingWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart' as config;
import '../../generated/i18n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class CompleteInformationWidget extends StatefulWidget {
  @override
  _CompleteInformationWidgetState createState() => _CompleteInformationWidgetState();
}

class _CompleteInformationWidgetState extends StateMVC<CompleteInformationWidget> {
  UserController _con;
  bool dni = false;
  bool documment = false;
  String dniS = '';
  String docS= '';
  bool loading = false;
  _CompleteInformationWidgetState() : super(UserController()) {
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                  "Ingrasa los datos faltantes para continuar",
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
                        onSaved: (input) => _con.user.name = input,
                        validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
                        decoration: InputDecoration(
                          labelText: "Nombre's",
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '',
                          hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
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
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => _con.user.lastname = input,
                        validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
                        decoration: InputDecoration(
                          labelText: "Apellidos's",
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '',
                          hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
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
                        keyboardType: TextInputType.phone,
                        onSaved: (input) => _con.user.phone = input,
                        validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
                        decoration: InputDecoration(
                          labelText: "Teléfono",
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '',
                          hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Documentos",
                              style: Theme.of(context).textTheme.display3.merge(TextStyle(color: Theme.of(context).accentColor, fontSize: 15.0)),
                            ),
                           
                          ],
                        )
                      ),
                       SizedBox(height: 5),
                       Container(
                        width: 210,
                        child: RaisedButton(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () async { 
                         
                         getPdfAndUpload(0);
                           
                         },
                        textColor: Colors.white,
                        color: dni == false ? Colors.pink : Colors.green,
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Padding(
                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        
                          Container(
                            
                            padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                            child: Text('(ine, ife, dni, id)', 
                            style: TextStyle(color: Colors.white),),
                          ),
            
                          Padding(
                            padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                            child: dni == false ? Icon(
                              Icons.backup,
                              color:Colors.white,
                              size: 30,
                            ) : Icon(
                              Icons.check_circle_outline,
                              color:Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                        )))),
                        Container(
                        width: 210,
                        child: RaisedButton(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () async { 
                         
                         getPdfAndUpload(1);
                           
                         },
                        textColor: Colors.white,
                        color: documment == false ? Colors.pink : Colors.green,
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Padding(
                        padding: EdgeInsets.fromLTRB(0,0,0,0),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        
                          Container(
                            
                            padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                            child: Text('Documento', 
                            style: TextStyle(color: Colors.white),),
                          ),
            
                          Padding(
                            padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                            child: documment == false ? Icon(
                              Icons.backup,
                              color:Colors.white,
                              size: 30,
                            ) : Icon(
                              Icons.check_circle_outline,
                              color:Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                        )))),
                        SizedBox(height: 5),
                        loading == true ?
                        Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          )
                        ) : BlockButtonWidget(
                        
                        text: Text(
                          "Continuar",
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          getUserName().then((value) => {
                            _con.registerComplete(int.tryParse(value)).then((status) {

                              if(dniS == '' || docS == ''){
                               
                              }else{
                                setState(() {
                                  loading = true;
                                });
                                if(status){
                                 setState(() {
                                  loading = false;
                                });
                                Navigator.pushReplacementNamed(context, '/Pages');
                                }else{
                                  setState(() {
                                  loading = false;
                                });
                                }
                              }
                            })
                          });

                          //print('el nonmbre es $dniS');
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
            // Positioned(
            //   bottom: 10,
            //   child: FlatButton(
            //     onPressed: () {
            //       Navigator.of(context).pushNamed('/Login');
            //     },
            //     textColor: Theme.of(context).hintColor,
            //     child: Text('¿Ya tienes una cuenta?, Inicia Sesíon'),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
  Future getPdfAndUpload(int type)async{
    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      //generate
    }
    File file = await FilePicker.getFile(type: FileType.image);
    String fileName = '${randomName}.pdf';
    //print(file);
    if(file != null){
      uploadImageHTTP(file, type);
    }else{
      print(" es  null");
    }
    //function call
  }
 Future uploadImageHTTP(file, int type) async {
  var request = http.MultipartRequest('POST', Uri.parse("https://www.somostugo.com/microserviceupload-file"));
  request.files.add(await http.MultipartFile.fromPath('avatar', file.path));
  request.send().then((result) async {

    http.Response.fromStream(result)
        .then((response) {

      if (response.statusCode == 200)
      {
        print("Uploaded! ");
        print('response.body '+response.body);
        var data = jsonDecode(response.body);
        print(data['data']['name']);
        if(type == 0){
          setState(() {
            dni = true;
            dniS = data['data']['name'];
            _con.user.dni = dniS;
         });
        }else{
           setState(() {
            documment = true;
            docS = data['data']['name'];
            _con.user.doc = docS;
         });
        }
      }
      
      //return response.body;

    });
    }).catchError((err) => print('error : '+err.toString()))
        .whenComplete(()
    {});
  // return res.reasonPhrase;

  }
  Future<String> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('stringValue') ?? '';
  }

}
