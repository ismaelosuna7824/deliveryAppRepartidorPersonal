import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';

class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
    uri: "https://delivery-personal-tqwme.ondigitalocean.app/graphql",
    httpClient: _client()
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    ),
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink,
    );
  }

}
IOClient _client() {
  // Workaround for self-signed certificate execption (to be used in dev mode only)
  HttpClient _httpClient = new HttpClient();
  _httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  IOClient _ioClient = new IOClient(_httpClient);
  return _ioClient;
  // Link to the GraphQL Endpoint
}
