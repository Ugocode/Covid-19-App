import 'package:coronavirus_app/app/services/api.dart';
import 'package:coronavirus_app/app/services/endpoint_data.dart';

class EndpointsData {
  final Map<EndPoint?, EndpointData> values;
  // ignore: invalid_required_named_param
  EndpointsData({required this.values});

  EndpointData? get cases => values[EndPoint.cases];
  EndpointData? get casesSuspected => values[EndPoint.casesSuspected];
  EndpointData? get casesConfiremd => values[EndPoint.casesConfirmed];
  EndpointData? get deaths => values[EndPoint.deaths];
  EndpointData? get recovered => values[EndPoint.recovered];

  //optional:
  @override
  String toString() =>
      'cases: $cases, suspected: $casesSuspected, confirmed: $casesConfiremd, deaths: $deaths, recovered: $recovered';
}
