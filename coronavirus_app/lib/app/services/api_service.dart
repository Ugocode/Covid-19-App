import 'dart:convert';

import 'package:coronavirus_app/app/services/api.dart';
import 'package:coronavirus_app/app/services/endpoint_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIService {
  final API api;
  APIService(this.api);

  //create a future method for posting/ getting access token:
  Future<String?> getAccessToken() async {
    final response = await http.post(
      Uri.parse(api.tokenUri().toString()),
      headers: {'Authorization': 'Basic ${api.apiKey}'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    // ignore: avoid_print
    print(
        'Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

//because our data is not coming in the same format we do this:
  static final Map<EndPoint, String> _responseJsonKeys = {
    EndPoint.cases: 'cases',
    EndPoint.casesSuspected: 'data',
    EndPoint.casesConfirmed: 'data',
    EndPoint.deaths: 'data',
    EndPoint.recovered: 'data',
  };

  //create a future method for getting the various cases
  Future<EndpointData> getEndPointData(
      {@required String? accessToken, @required EndPoint? endpoint}) async {
    final uri = api.endpointUri(endpoint!);
    final response = await http.get(Uri.parse(uri.toString()),
        headers: {'Authorization': 'Bearer $accessToken'});

    if (response.statusCode == 200) {
      //because the data is coming as a list from the api we do this:
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String responseJsonKey = _responseJsonKeys[endpoint]!;
        final int value = endpointData[responseJsonKey];
        final String dateString = endpointData['date'];
        final DateTime? date = DateTime.tryParse(dateString);
        return EndpointData(value: value, date: date);
      }
    }
    // ignore: avoid_print
    print(
        'Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }
}
