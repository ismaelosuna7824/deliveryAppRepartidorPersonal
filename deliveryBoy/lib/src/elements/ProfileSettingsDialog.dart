import 'package:TuGoRepartidor/api/register.dart';
import 'package:TuGoRepartidor/config/app_config.dart';
import 'package:flutter/material.dart';

import '../../generated/i18n.dart';
import '../models/user.dart';

class ProfileSettingsDialog extends StatefulWidget {
  String id;
  String nombre;
  String apellido;
  String telefono;
  VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.id, this.nombre, this.apellido, this.telefono, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                     'Información personal',
                      style: Theme.of(context).textTheme.body2,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration:
                              getInputDecoration(hintText: S.of(context).john_doe, labelText: 'Nombre`s'),
                          initialValue: widget.nombre,
                          validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_full_name : null,
                          onChanged: (input) { setState(() {
                             widget.nombre = input;
                          });},
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration:
                              getInputDecoration(hintText: S.of(context).john_doe, labelText: 'Apellidos'),
                          initialValue: widget.apellido,
                          validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_full_name : null,
                          onChanged: (input){
                            setState(() {
                              widget.apellido = input;
                            });
                          },
                        ),
                         new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: '+136 269 9765', labelText: 'Teléfono'),
                          initialValue: widget.telefono,
                          validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_phone : null,
                          onChanged: (input){setState(() {
                           widget.telefono = input;
                          });},
                        ),
                        
                       
                        
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                      MaterialButton(
                        onPressed: () async{
                           bool status = await updateUser(int.tryParse(widget.id), widget.nombre, widget.apellido, widget.telefono);
                          if(status){
                            Navigator.pop(context, true);
                          }
                          
                        },
                        child: Text(
                          'Guardar',
                          style: TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            }).then((value) => Navigator.pushNamed(context, '/Pages'));
      },
      child: Text(
        S.of(context).edit,
        style: Theme.of(context).textTheme.body1,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();
      widget.onChanged();
      Navigator.pop(context);
    }
  }
}
