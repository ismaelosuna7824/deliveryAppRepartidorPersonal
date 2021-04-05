import 'package:TuGoRepartidor/api/querys.dart';
import 'package:TuGoRepartidor/api/stoarge.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/i18n.dart';
import '../controllers/settings_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ProfileSettingsDialog.dart';
import '../helpers/helper.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
var _data;

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
  
}
Future<dynamic> getDetailUser(int id) async {
  Graphql.QueryOptions queryOptions =
      Graphql.QueryOptions(documentNode: Graphql.gql("""
        {
        informationBoy(id: $id){
          id
          name
          lastname
          phone
          documents
          user{
            email
          }
        }
      }
    """));

  Graphql.QueryResult queryResult =
      await graphQLConfiguration.clientToQuery().query(queryOptions);
      // SharedPreferences prefs =
      //                     await SharedPreferences.getInstance();
      //                 //Remove String
      //                 prefs.remove("stringValue");
  if (queryResult.hasException) {
    throw queryResult.exception.graphqlErrors[0].message;
  }

  _data = queryResult.data;
  return queryResult.data["informationBoy"];
}
class _SettingsWidgetState extends StateMVC<SettingsWidget> {
  SettingsController _con;

  _SettingsWidgetState() : super(SettingsController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Configuraciones',
            style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        // body: _con.user.id == null
        //     ? CircularLoadingWidget(height: 500)
        //     :
        body: FutureBuilder(
          future: getUserName().then((value) => getDetailUser(int.tryParse(value))),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //print('${_data["informationBoy"]["id"]}');
                if(snapshot.hasData){
                  return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          children: <Widget>[
                            // Expanded(
                            //   child: Column(
                            //     children: <Widget>[
                            //       Text(
                            //         "Nombre",
                            //         textAlign: TextAlign.left,
                            //         style: Theme.of(context).textTheme.display2,
                            //       ),
                            //       Text(
                            //         "email",
                            //         style: Theme.of(context).textTheme.caption,
                            //       )
                            //     ],
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //   ),
                            // ),
                            // // SizedBox(
                            //     width: 55,
                            //     height: 55,
                            //     child: InkWell(
                            //       borderRadius: BorderRadius.circular(300),
                            //       onTap: () {
                            //         Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                            //       },
                            //       child: CircleAvatar(
                            //         backgroundImage: NetworkImage(_con.user.image.thumb),
                            //       ),
                            //     )),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).hintColor.withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 10)
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Información Personal',
                                style: Theme.of(context).textTheme.body2,
                              ),
                              trailing: ButtonTheme(
                                padding: EdgeInsets.all(0),
                                minWidth: 50.0,
                                height: 25.0,
                                child: ProfileSettingsDialog(
                                  id:  _data["informationBoy"]["id"],
                                  nombre: _data["informationBoy"]["name"] ,
                                  apellido: _data["informationBoy"]["lastname"],
                                  telefono: _data["informationBoy"]["phone"],
                                  onChanged: () {
                                   // _con.update(_con.user);
                                    //setState(() {});
                                    
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text(
                                'Nombre Completo',
                                style: Theme.of(context).textTheme.body1,
                              ),
                              trailing: Text(
                                '${_data["informationBoy"]["name"]} ${_data["informationBoy"]["lastname"]}',
                                style: TextStyle(color: Theme.of(context).focusColor),
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text(
                                'Correo Electrónico',
                                style: Theme.of(context).textTheme.body1,
                              ),
                              trailing: Text(
                                '${_data["informationBoy"]["user"]["email"]}',
                                style: TextStyle(color: Theme.of(context).focusColor),
                              ),
                            ),
                            ListTile(
                              onTap: () {},
                              dense: true,
                              title: Text(
                                'Teléfono',
                                style: Theme.of(context).textTheme.body1,
                              ),
                              trailing: Text(
                                '${_data["informationBoy"]["phone"]}',
                                style: TextStyle(color: Theme.of(context).focusColor),
                              ),
                            ),
                            
                            
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).hintColor.withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 10)
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.settings),
                              title: Text(
                                'Configuración',
                                style: Theme.of(context).textTheme.body2,
                              ),
                            ),
                          
                            ListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed('/Help');
                              },
                              dense: true,
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.help,
                                    size: 22,
                                    color: Theme.of(context).focusColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Ayuda y soporte',
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                //Remove String
                                prefs.remove("stringValue");
                                Navigator.of(context).pushReplacementNamed('/Login');
                              },
                              dense: true,
                              title: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.logout,
                                    size: 22,
                                    color: Theme.of(context).focusColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Cerrar Sesión',
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ),
                  );
                }else{
                  return CircularLoadingWidget(height: 100);
                }
              },
            )
            );
  }
}
