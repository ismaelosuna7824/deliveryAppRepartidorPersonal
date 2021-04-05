import 'package:TuGoRepartidor/api/querys.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:shared_preferences/shared_preferences.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
Future<bool> loginUser(String _email, String _password) async {
  //print(_email);
  //print(_password);

  var queryOptions = Graphql.QueryOptions(documentNode: Graphql.gql("""
            {
            login(email: "${_email.toLowerCase().trim()}", password: "$_password"){
            status
            message
            tipo
            }
          }
      """));

  Graphql.QueryResult queryResult =
      await graphQLConfiguration.clientToQuery().query(queryOptions);

  if (queryResult.hasException) {
    throw queryResult.exception.graphqlErrors[0].message;
  }
  print(queryResult.data['login']['message']);
  if (queryResult.data['login']['status'] == true) {
    if(queryResult.data['login']['tipo'] == "REPARTIDOR"){
      SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('stringValue', "${queryResult.data['login']['message']}");
          return true;
    }else{
      return false;
    }
    
  } else {
    return false;
  }
  //return queryResult.data['login']['token'].toString();
}
