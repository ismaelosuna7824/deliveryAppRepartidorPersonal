import 'package:TuGoRepartidor/api/querys.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as Graphql;
import 'package:shared_preferences/shared_preferences.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
Future<bool> registerUser(String _email, String _password) async {
    //print(_email);
    const String addStar = r'''
      mutation addUser($user: UserInput) {
         register(user: $user) {
          status 
    			message
          user{
              id
            }
        }
      }
    ''';
    Graphql.MutationOptions queryOptions = Graphql.MutationOptions(
        documentNode: Graphql.gql(addStar),
        variables: <String, dynamic>{
          "user": {
            'email': '$_email', 
            'password': '$_password',
            'tipo': 'REPARTIDOR'
            }
        });

    final Graphql.QueryResult result =
        await graphQLConfiguration.clientToQuery().mutate(queryOptions);

    if (result.hasException) {
      print(result.exception.toString());
    }

    //print(result.data['register']['user']['id']);
    if (result.data['register']['status'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'stringValue', "${result.data['register']['user']['id']}");
      return true;
    } else {
      return false;
    }
    
  }

  Future<bool> completeProfileUser(int user, String name, String lastname, String phone, String birthdate,  String dni, String doc) async {
    //print(_email);
    const String addStar = r'''
      mutation addInformation( $informationMan: InformationManInput){
      registerInformationMan(informationMan: $informationMan){
        status
        message
      }
    }
    ''';
    Graphql.MutationOptions queryOptions = Graphql.MutationOptions(
        documentNode: Graphql.gql(addStar),
        variables: <String, dynamic>{
          "informationMan": {
            "user": user,
            "name": "$name",
            "lastname": "$lastname",
            "phone": "$phone",
            "birthdate": "$birthdate",
            "image": "",
            "documents": [
              "$dni",
              "$doc"
            ],
            "ratingStar": 0,
            "rating": 0,
            "status": "PENDIENTE"
          }
        });

    final Graphql.QueryResult result =
        await graphQLConfiguration.clientToQuery().mutate(queryOptions);

    if (result.hasException) {
      print(result.exception.toString());
    }

    //print(result.data['register']['user']['id']);
    if (result.data['registerInformationMan']['status'] == true) {
    
      return true;
    } else {
      return false;
    }
    
  }
Future<bool> updateUser(int id, String name, String lastname, String phone) async {
    //print(_email);
    const String addStar = r'''
      mutation updateboy($information: InformationManInput){
        updateInformationMan(informationMan: $information){
          status
          message
        }
      }
    ''';
    Graphql.MutationOptions queryOptions = Graphql.MutationOptions(
        documentNode: Graphql.gql(addStar),
        variables: <String, dynamic>{
          "information": {
          "user": id,
          "name": "$name",
          "lastname":  "$lastname",
          "phone": "$phone"
          }
        });

    final Graphql.QueryResult result =
        await graphQLConfiguration.clientToQuery().mutate(queryOptions);

    if (result.hasException) {
      print(result.exception.toString());
    }

    //print(result.data['register']['user']['id']);
    if (result.data['updateInformationMan']['status'] == true) {
      return true;
    } else {
      return false;
    }
  }