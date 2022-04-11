import 'package:coronavirus_app/Repositories/endpoints_data.dart';
import 'package:coronavirus_app/app/services/api.dart';
import 'package:coronavirus_app/app/services/api_service.dart';
import 'package:coronavirus_app/app/services/data_catch_service.dart';
import 'package:coronavirus_app/app/services/endpoint_data.dart';
import 'package:http/http.dart';

class DataRepository {
  final APIService? apiService;
  final DAtaCacheService? dataCacheService;

  DataRepository({this.dataCacheService, this.apiService});

  String? _accessToken;

  Future<EndpointData> getEndpointData(EndPoint endpoint) async =>
      await _getDataRefreshingToken<EndpointData>(
          onGetData: () => apiService!
              .getEndPointData(accessToken: _accessToken, endpoint: endpoint));

  //to get the data from the cached system:
  EndpointsData getAllEndpointsCachedData() => dataCacheService!.getData();

  Future<EndpointsData> getAllEndpointsData() async {
    final endpointsData = await _getDataRefreshingToken<EndpointsData>(
      onGetData: _getAllEndpointsData,
    );
    //to save the data to the shared pref easily:
    await dataCacheService!.setData(endpointsData);
    return endpointsData;
  }

//because we need to get deferrent types of data sometimes
// 'endpointdata' and sometimes 'int' data type we do we need to put a
//generic style  of T like this:
  Future<T> _getDataRefreshingToken<T>(
      {Future<T> Function()? onGetData}) async {
    try {
      _accessToken ??= await apiService!.getAccessToken();
      return await onGetData!();
    } on Response catch (response) {
//if unauthurized, get access token again
      if (response.statusCode == 401) {
        _accessToken = await apiService!.getAccessToken();
        return await onGetData!();
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointsData() async {
    final values = await Future.wait([
      apiService!
          .getEndPointData(accessToken: _accessToken, endpoint: EndPoint.cases),
      apiService!.getEndPointData(
          accessToken: _accessToken, endpoint: EndPoint.casesConfirmed),
      apiService!.getEndPointData(
          accessToken: _accessToken, endpoint: EndPoint.casesSuspected),
      apiService!.getEndPointData(
          accessToken: _accessToken, endpoint: EndPoint.deaths),
      apiService!.getEndPointData(
          accessToken: _accessToken, endpoint: EndPoint.recovered),
    ]);
    return EndpointsData(values: {
      EndPoint.cases: values[0],
      EndPoint.casesConfirmed: values[1],
      EndPoint.casesSuspected: values[2],
      EndPoint.deaths: values[3],
      EndPoint.recovered: values[4],
    });
  }
}
