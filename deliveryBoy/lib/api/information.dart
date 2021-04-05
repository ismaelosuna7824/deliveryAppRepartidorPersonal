import 'package:TuGoRepartidor/api/querys.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
Future<dynamic> getDetailUserInformation(int id) async {
  Graphql.QueryOptions queryOptions =
      Graphql.QueryOptions(documentNode: Graphql.gql("""
        {
        informationBoy(id: $id){
          id
          status
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
  //print(queryResult.data["informationBoy"]["status"]);
  return queryResult.data["informationBoy"]["status"];
}