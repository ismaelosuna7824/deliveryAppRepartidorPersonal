import 'dart:async';

import 'package:TuGoRepartidor/api/mutations.dart';
import 'package:TuGoRepartidor/api/querys.dart';
import 'package:TuGoRepartidor/src/controllers/order_details_controller.dart';
import 'package:TuGoRepartidor/src/elements/DrawerWidget.dart';
import 'package:TuGoRepartidor/src/elements/OrderItemWidget.dart';
import 'package:TuGoRepartidor/src/elements/ShoppingCartButtonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/i18n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:maps_launcher/maps_launcher.dart';


GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
var _data;

class OrderWidget extends StatefulWidget {
  RouteArgument routeArgument;

  OrderWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderWidgetState createState() {
    return _OrderWidgetState();
  }
}

Future<void> getOrderDetail(int id) async {
  Graphql.QueryOptions queryOptions =
      Graphql.QueryOptions(documentNode: Graphql.gql("""
        {
        getOrderRestaurant(id: $id){
          id
          status
          total
          idInformationUser{
            name
            phone
          }
          idStore{
            name
            direction
            phone
            lat
            lng
          }
          products{
            descriptionProduct
            cant
            precioUnitario
          }
          dateOrder
          totalProductos
          addressOrder
          lat
          lng
          envio
        }
      }
    """));

  Graphql.QueryResult queryResult =
      await graphQLConfiguration.clientToQuery().query(queryOptions);
  if (queryResult.hasException) {
    throw queryResult.exception.graphqlErrors[0].message;
  }

  _data = queryResult.data;
  return queryResult.data["getOrderRestaurant"];
}

class _OrderWidgetState extends StateMVC<OrderWidget> {
  OrderDetailsController _con;

  _OrderWidgetState() : super(OrderDetailsController()) {
    _con = controller;
  }

  @override
  void initState() {
    // _con.listenForOrder(id: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _con.scaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detalle de Orden',
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: FutureBuilder(
        future: getOrderDetail(int.tryParse(widget.routeArgument.id)),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //print(snapshot.hasData);
          if (snapshot.hasData) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      //bottom: _con.order.orderStatus.id '5' == '5' ? 147 : 200),
                      bottom: '${_data["getOrderRestaurant"]["status"]}' ==
                              'Repartidor'
                          ? 147
                          : 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // _con.order.orderStatus.id == '5'
                              '${_data["getOrderRestaurant"]["status"]}' ==
                                      'Repartidor'
                                  ? Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.1)),
                                      child: Icon(
                                        Icons.update,
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.8),
                                        size: 30,
                                      ),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green.withOpacity(0.2)),
                                      child: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 32,
                                      ),
                                    ),
                              SizedBox(width: 15),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            //"#${_con.order.id}",
                                            " Order #${_data["getOrderRestaurant"]["id"]}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subhead,
                                          ),
                                          Text(
                                            // _con.order.payment?.method ??
                                            //     S.of(context).cash_on_delivery,
                                            'fecha',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                          Text(
                                            // DateFormat('yyyy-MM-dd HH:mm')
                                            //     .format(_con.order.dateTime),
                                            '${_data["getOrderRestaurant"]["dateOrder"]}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Helper.getPrice(
                                            double.tryParse(
                                                '${_data["getOrderRestaurant"]["total"]}'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .display1),
                                        Text(
                                          // 'Items: ${_con.order.foodOrders.length}',
                                          'Tarifa de Envío: \$${_data["getOrderRestaurant"]["envio"]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.person_pin,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              'Información del consumidor',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  // _con.order.user.name,
                                  '${_data["getOrderRestaurant"]["idInformationUser"]["name"]}',
                                  style: Theme.of(context).textTheme.body2,
                                ),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                width: 42,
                                height: 42,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  disabledColor: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.4),
                                  //onPressed: () {
//                                    Navigator.of(context).pushNamed('/Profile',
//                                        arguments: new RouteArgument(param: _con.order.deliveryAddress));
                                  //},
                                  child: Icon(
                                    Icons.person,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  // _con.order.deliveryAddress?.address ??
                                  //     S
                                  //         .of(context)
                                  //         .address_not_provided_please_call_the_client,
                                  '${_data["getOrderRestaurant"]["addressOrder"]}',
                                  style: Theme.of(context).textTheme.body2,
                                ),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                width: 42,
                                height: 42,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  disabledColor: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.4),
                                     onPressed: () async {
                                      //  Navigator.of(context).pushNamed('/Map',
                                      //      arguments: new RouteArgument(param: _con.order.deliveryAddress));
                                      // final availableMaps = await MapLauncher.installedMaps;
                                      //print(double.tryParse(_data["getOrderRestaurant"]["lat"]));
                                      double lat = double.parse(_data["getOrderRestaurant"]["lat"]);
                                      double lng = double.parse(_data["getOrderRestaurant"]["lng"]);
                                     MapsLauncher.launchCoordinates(lat,lng);
                                     },
                                  child: Icon(
                                    Icons.directions,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  // _con.order.user.phone,
                                  'Teléfono',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.body2,
                                ),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: 42,
                                height: 42,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                     launch("tel:${_data["getOrderRestaurant"]["idInformationUser"]["phone"]}");
                                    //print( "tel:${_data["getOrderRestaurant"]["idInformationUser"]["phone"]}");
                                  },
                                  child: Icon(
                                    Icons.call,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.store,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              'Información de la Tienda',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  // _con.order.user.name,
                                  '${_data["getOrderRestaurant"]["idStore"]["name"]}',
                                  style: Theme.of(context).textTheme.body2,
                                ),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                width: 42,
                                height: 42,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  disabledColor: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.4),
                                  //onPressed: () {
//                                    Navigator.of(context).pushNamed('/Profile',
//                                        arguments: new RouteArgument(param: _con.order.deliveryAddress));
                                  //},
                                  child: Icon(
                                    Icons.store,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  // _con.order.user.name,
                                  '${_data["getOrderRestaurant"]["idStore"]["direction"]}',
                                  style: Theme.of(context).textTheme.body2,
                                ),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                width: 42,
                                height: 42,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  disabledColor: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.4),
                                      onPressed: () {
                                      //  Navigator.of(context).pushNamed('/Profile',
                                      //      arguments: new RouteArgument(param: _con.order.deliveryAddress));
                                      double lat = double.parse(_data["getOrderRestaurant"]["idStore"]["lat"]);
                                      double lng = double.parse(_data["getOrderRestaurant"]["idStore"]["lng"]);
                                      MapsLauncher.launchCoordinates(lat,lng);
                                      },
                                  child: Icon(
                                    Icons.directions,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  // _con.order.user.phone,
                                  'Teléfono',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.body2,
                                ),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: 42,
                                height: 42,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                   launch("tel:${_data["getOrderRestaurant"]["idStore"]["phone"]}");
                                  },
                                  child: Icon(
                                    Icons.call,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.9),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.fastfood,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              'Productos ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                        ),
                        ListView.separated(
                          padding: EdgeInsets.only(bottom: 50),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          // itemCount: _con.order.foodOrders.length,
                          itemCount:
                              _data["getOrderRestaurant"]["products"].length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return OrderItemWidget(
                              heroTag: 'my_orders',
                              description:
                                  '${_data["getOrderRestaurant"]["products"][index]["descriptionProduct"]}',
                              cant: int.tryParse(
                                  '${_data["getOrderRestaurant"]["products"][index]["cant"]}'),
                              price: double.tryParse(
                                  '${_data["getOrderRestaurant"]["products"][index]["precioUnitario"]}'),
                              idorder: '${_data["getOrderRestaurant"]["id"]}',
                              // order: _con.order,
                              // // foodOrder: _con.order.foodOrders.elementAt(index));
                              // foodOrder:
                              //     _con.order.foodOrders.elementAt(index)
                            );
                            //return Text('hola');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                '${_data["getOrderRestaurant"]["status"]}' == 'Repartidor'
                    ? Positioned(
                        bottom: 0,
                        child: Container(
                          // height: _con.order.orderStatus.id == '5' ? 177 : 230,
                          height: '${_data["getOrderRestaurant"]["status"]}' ==
                                  'Repartidor'
                              ? 170
                              : 177,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, -2),
                                    blurRadius: 5.0)
                              ]),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Divider(height: 30),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        S.of(context).total,
                                        style:
                                            Theme.of(context).textTheme.title,
                                      ),
                                    ),
                                    Helper.getPrice(
                                        double.tryParse(
                                            '${_data["getOrderRestaurant"]["total"]}'),
                                        style:
                                            Theme.of(context).textTheme.title)
                                  ],
                                ),
                                SizedBox(height: 20),
                                // _con.order.orderStatus.id != '5'
                                
                                '${_data["getOrderRestaurant"]["status"]}' ==
                                        'Repartidor'
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: FlatButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Confirmar Pedido'),
                                                    content: Text(
                                                        '¿Desea confirmar este pedido?'),
                                                    actions: <Widget>[
                                                      // usually buttons at the bottom of the dialog
                                                      FlatButton(
                                                        child: new Text(
                                                            'Confirmar'),
                                                        onPressed: () {
                                                          getUserName().then(
                                                              (resp) async {
                                                            bool status = await 
                                                            registerOrder(int.tryParse(widget.routeArgument.id), int.tryParse(resp),"Recogido");
                                                            if (status) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.pushNamed(context, '/Pages');
                                                            }else{
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                                  showDialog(
                                                                  context: context,
                                                                  builder: (context){
                                                                    return AlertDialog(
                                                                      title: Text('Ocurrio un Problema'),
                                                                      content: Text('Ha ocurrido un problema al aceptar el pedido, o este pedido ya ha sido aceptado por otro repartidor.'),
                                                                    );
                                                                  } 
                                                                  );
                                                            }
                                                          });
                                                          // _con.doDeliveredOrder(
                                                          //     _con.order);
                                                          // Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: new Text(
                                                            'Cancelar'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          color: Theme.of(context).accentColor,
                                          shape: StadiumBorder(),
                                          child: Text(
                                            'Confirmar',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      )
                                    : 
                                    
                                    SizedBox(height: 0),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      )
                    : 
                     '${_data["getOrderRestaurant"]["status"]}' == 'Recogido'
                    ?
                    Positioned(
                        bottom: 0,
                        child: Container(
                          // height: _con.order.orderStatus.id == '5' ? 177 : 230,
                          height: '${_data["getOrderRestaurant"]["status"]}' ==
                                  'Recogido'
                              ? 170
                              : 177,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, -2),
                                    blurRadius: 5.0)
                              ]),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Divider(height: 30),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        S.of(context).total,
                                        style:
                                            Theme.of(context).textTheme.title,
                                      ),
                                    ),
                                    Helper.getPrice(
                                        double.tryParse(
                                            '${_data["getOrderRestaurant"]["total"]}'),
                                        style:
                                            Theme.of(context).textTheme.title)
                                  ],
                                ),
                                SizedBox(height: 20),
                                // _con.order.orderStatus.id != '5'
                                
                                '${_data["getOrderRestaurant"]["status"]}' ==
                                        'Recogido'
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: FlatButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Finalizar Pedido'),
                                                    content: Text(
                                                        '¿Desea finalizar este pedido?'),
                                                    actions: <Widget>[
                                                      // usually buttons at the bottom of the dialog
                                                      FlatButton(
                                                        child: new Text(
                                                            'Finalizar'),
                                                        onPressed: () {
                                                          getUserName().then(
                                                              (resp) async {
                                                            bool status = await 
                                                            finalizarOrder(int.tryParse(widget.routeArgument.id), int.tryParse(resp),"Finalizado");
                                                            if (status) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                                   showDialog(
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  builder: (context){
                                                                    return AlertDialog(
                                                                    
                                                                      title: Text('Pedido Finalizado'),
                                                                      content: Text('Se ha finalizado el pedido correctamente.'),
                                                                       actions: <Widget>[
                                                      // usually buttons at the bottom of the dialog
                                                                        FlatButton(
                                                                          child: new Text(
                                                                              'Continuar'),
                                                                          onPressed: () {
                                                                             Navigator.pushNamed(context, '/Pages');
                                                                            }
                                                                            // _con.doDeliveredOrder(
                                                                            //     _con.order);
                                                                            // Navigator.of(context).pop();
                                                                          
                                                                        ),
                                                                        
                                                                      ],
                                                                    );
                                                                  
                                                                  } 
                                                                );
                                                               
                                                             
                                                            }else{
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                                  showDialog(
                                                                  context: context,
                                                                  builder: (context){
                                                                    return AlertDialog(
                                                                      title: Text('Ocurrio un Problema'),
                                                                      content: Text('Ha ocurrido un problema al aceptar el pedido, o este pedido ya ha sido aceptado por otro repartidor.'),
                                                                    );
                                                                  } 
                                                                  );
                                                            }
                                                          });
                                                          // _con.doDeliveredOrder(
                                                          //     _con.order);
                                                          // Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: new Text(
                                                            'Cancelar'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          color: Theme.of(context).accentColor,
                                          shape: StadiumBorder(),
                                          child: Text(
                                            'Finalizar',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      )
                                    : 
                                    
                                    SizedBox(height: 0),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      )
                    :Container()
              ],
            );
          } else {
            return CircularLoadingWidget(height: 500);
          }
        },
      ),
    );
  }

  Future<String> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('stringValue') ?? '';
  }
}
