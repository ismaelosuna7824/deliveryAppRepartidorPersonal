import 'package:TuGoRepartidor/api/querys.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
Future<bool> registerOrder(int idOrder, int idUser, String status) async {
  try {
    const String addInformation = r'''
        mutation acceptBoyOrder($idOrder: ID!, $idBoy: Int!, $status: String! ){
              updateStatusBoy(idOrder: $idOrder, idDeliveryBoy: $idBoy, status: $status ){
              status
              message
          }
        }
      ''';
    Graphql.MutationOptions queryOptions = Graphql.MutationOptions(
        documentNode: Graphql.gql(addInformation),
        variables: <String, dynamic>{
          "idOrder": idOrder,
          "idBoy": idUser,
          "status": status
        });

    final Graphql.QueryResult result =
        await graphQLConfiguration.clientToQuery().mutate(queryOptions);

    if (result.hasException) {
      print(result.exception.toString());
    }

    if (result.data['updateStatusBoy']['status'] == true) {
      //print(result.data['registerInformationUser']['message']);
      //print();
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
Future<bool> finalizarOrder(int idOrder, int idUser, String status) async {
  try {
    const String addInformation = r'''
       mutation status($id: ID!,  $status:String!){
          updateStatus(id: $id, status: $status){
            status
            message
            }
          }
      ''';
    Graphql.MutationOptions queryOptions = Graphql.MutationOptions(
        documentNode: Graphql.gql(addInformation),
        variables: <String, dynamic>{
          "id": idOrder,
          "status": status
        });

    final Graphql.QueryResult result =
        await graphQLConfiguration.clientToQuery().mutate(queryOptions);

    if (result.hasException) {
      print(result.exception.toString());
    }

    if (result.data['updateStatus']['status'] == true) {
      //print(result.data['registerInformationUser']['message']);
      //print();
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}