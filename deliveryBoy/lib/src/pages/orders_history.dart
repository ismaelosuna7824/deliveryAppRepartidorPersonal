import 'package:TuGoRepartidor/api/querys.dart';
import 'package:TuGoRepartidor/api/stoarge.dart';
import 'package:TuGoRepartidor/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/order_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;

class OrdersHistoryWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OrdersHistoryWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _OrdersHistoryWidgetState createState() => _OrdersHistoryWidgetState();
}

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
var _data;

Future<List> getOrders(int id) async {
  Graphql.QueryOptions queryOptions =
      Graphql.QueryOptions(documentNode: Graphql.gql("""
        {
          getOrdersBoy(id: $id){
          id
          status
          addressOrder
        }
      }
    """));
  Graphql.QueryResult queryResult =
      await graphQLConfiguration.clientToQuery().query(queryOptions);
  if (queryResult.hasException) {
    throw queryResult.exception.graphqlErrors[0].message;
  }

  _data = queryResult.data;
  return queryResult.data["getOrdersBoy"];
}

class _OrdersHistoryWidgetState extends StateMVC<OrdersHistoryWidget> {
  OrderController _con;

  _OrdersHistoryWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    //_con.listenForOrdersHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Ordenes Activas',
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
      body: _getOrderOffline(theme)
    );
  }
  Widget _getOrderOffline(ThemeData theme){
    return FutureBuilder(
          future: getUserName().then((value) => getOrders(int.tryParse(value))),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if(snapshot.hasData){
                            return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _data['getOrdersBoy'].length,
                            itemBuilder: (context, index) {
                            return Theme(
                              data: theme,
                              child: ExpansionTile(
                                backgroundColor:
                                    Theme.of(context).focusColor.withOpacity(0.05),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/OrderDetails',
                                        arguments: RouteArgument(
                                            id: _data['getOrdersBoy'][index]
                                                ["id"]));
                                    // print(
                                    //     '${snapshot.data.data['newStatus'][index]["id"]}');
                                  },
                                ),
                                leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.1)),
                                child: Icon(
                                  Icons.update,
                                  color:
                                      Theme.of(context).hintColor.withOpacity(0.8),
                                  size: 30,
                                ),
                                ),
                                initiallyExpanded: true,
                                title: Text(
                                    '${S.of(context).order_id}: #${_data['getOrdersBoy'][index]["id"]}'),
                                subtitle: Text(
                                  "${_data['getOrdersBoy'][index]["addressOrder"]}",
                                  style: Theme.of(context).textTheme.caption,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                                  // children: List.generate(
                                  //    _data["getOrdersUser"].length,
                                  //     (indexFood) {
                                  //   return OrderItemWidget(
                                  //       heroTag: 'my_orders',
                                  //       order: _con.orders.elementAt(index),
                                  //       foodOrder: _con.orders
                                  //           .elementAt(index)
                                  //           .foodOrders
                                  //           .elementAt(indexFood));
                                  //   }
                                  // ),
                                  ),
                                );
                              },
                            );
                          }else{
                            return Container();
                          }
                        }
                      
                    );
      }
}
