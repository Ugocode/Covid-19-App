import 'package:coronavirus_app/app/services/apikeys_file.dart';
import 'package:flutter/material.dart';

//lets create an enum for all the special endpoints:
enum EndPoint {
  cases,
  casesSuspected,
  casesConfirmed,
  deaths,
  recovered,
}

class API {
  final String? apiKey;
  API({@required this.apiKey});

//create a factory method to return our api key easily:
  factory API.sandbox() {
    return API(apiKey: APIkeys.ncovSandboxKey);
  }

  static const String host = 'ncov2019-admin.firebaseapp.com';

  //here we are using URI method and not the url style please take note:
  Uri tokenUri() => Uri(
        scheme: 'https',
        host: host,
        path: 'token',
      );

  //lets create the endpoints:
  //remember that this enpoints are gotten from the API itself
  static final Map<EndPoint, String> _paths = {
    EndPoint.cases: 'cases',
    EndPoint.casesConfirmed: 'casesConfirmed',
    EndPoint.casesSuspected: 'casesSuspected',
    EndPoint.deaths: 'deaths',
    EndPoint.recovered: 'recovered',
  };

//now lets create a url with these endpoints:
  Uri endpointUri(EndPoint endpoint) => Uri(
        scheme: 'https',
        host: host,
        path: _paths[endpoint],
      );
}
