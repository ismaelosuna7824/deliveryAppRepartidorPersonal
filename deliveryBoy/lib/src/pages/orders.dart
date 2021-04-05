import 'package:TuGoRepartidor/src/models/route_argument.dart';
import 'package:flutter/material.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';

import '../elements/OrderItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import 'package:TuGoRepartidor/api/querys.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:graphql/client.dart' as GraphqlClient;

class OrdersWidget extends StatefulWidget {
  static final GraphqlClient.WebSocketLink _webSocketLink =
      GraphqlClient.WebSocketLink(
    url: 'wss://delivery-personal-tqwme.ondigitalocean.app/graphql',
    config: GraphqlClient.SocketClientConfig(
      autoReconnect: true,
    ),
  );

  static final GraphqlClient.Link _link = _webSocketLink;

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

var _data;

Future<List> getOrders() async {
  Graphql.QueryOptions queryOptions =
      Graphql.QueryOptions(documentNode: Graphql.gql("""
        {
        getOrdesRestaurantWithStatus(status: "Repartidor"){
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
  return queryResult.data["getOrdesRestaurantWithStatus"];
}

class _OrdersWidgetState extends State<OrdersWidget> {
  final GraphqlClient.GraphQLClient _client = GraphqlClient.GraphQLClient(
    link: OrdersWidget._link,
    cache: GraphqlClient.InMemoryCache(),
  );

  final String subscribeQuery = '''
    subscription{
      newStatus{
        id
        status
        addressOrder
      }
    }
    ''';
  GraphqlClient.Operation operation;

  Stream<GraphqlClient.FetchResult> _logStream;

  @override
  void initState() {
    super.initState();
    operation = GraphqlClient.Operation(
        documentNode: GraphqlClient.gql(subscribeQuery));
    _logStream = _client.subscribe(operation);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      // key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          //onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Pedidos',
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          // new ShoppingCartButtonWidget(
          //     iconColor: Theme.of(context).hintColor,
          //     labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            StreamBuilder(
              stream: _logStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                   
                }
                if (snapshot.hasData) {
                  print(" ${snapshot.data.data['newStatus']}");
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data.data['newStatus'].length,
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
                                      id: snapshot.data.data['newStatus'][index]
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
                              '${S.of(context).order_id}: #${snapshot.data.data['newStatus'][index]["id"]}'),
                          subtitle: Text(
                            "${snapshot.data.data['newStatus'][index]["addressOrder"]}",
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
                  return _getOrderOffline(theme);
                }
                // return Container();
              },
              // builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              //   if (snapshot.hasData) {

              //   } else {
              //     return Container(
              //         height: 400.0,
              //         child: Center(child: CircularProgressIndicator()));
              //   }
              // },
            )
          ],
        ),
      ),
    );
  }
  Widget _getOrderOffline(ThemeData theme){
    return FutureBuilder(
          future: getOrders(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if(snapshot.hasData){
                            return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _data['getOrdesRestaurantWithStatus'].length,
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
                                            id: _data['getOrdesRestaurantWithStatus'][index]
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
                                    '${S.of(context).order_id}: #${_data['getOrdesRestaurantWithStatus'][index]["id"]}'),
                                subtitle: Text(
                                  "${_data['getOrdesRestaurantWithStatus'][index]["addressOrder"]}",
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
