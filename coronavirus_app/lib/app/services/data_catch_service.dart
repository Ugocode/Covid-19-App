import 'package:coronavirus_app/app/services/api.dart';
import 'package:coronavirus_app/app/services/endpoint_data.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Repositories/endpoints_data.dart';

class DAtaCacheService {
  DAtaCacheService({@required this.sharedPreferences});

  final SharedPreferences? sharedPreferences;

  static String endpointValueKey(EndPoint endpoint) => '$endpoint/value';
  static String endpointDateKey(EndPoint endpoint) => '$endpoint/date';

//to write to the sharepref
  Future<void> setData(EndpointsData endpointsData) async {
    endpointsData.values.forEach((endpoint, endpointData) async {
      await sharedPreferences!.setInt(
        endpointValueKey(endpoint!),
        endpointData.value!,
      );
      //for writing dates to shareprefrences we do:
      await sharedPreferences!.setString(
        endpointDateKey(endpoint),
        endpointData.date!.toIso8601String(),
      );
    });
  }

  //to read from the sharedpref:
  EndpointsData getData() {
    Map<EndPoint, EndpointData> values = {};

    for (var endpoint in EndPoint.values) {
      final value = sharedPreferences!.getInt(endpointValueKey(endpoint));
      final dateString =
          sharedPreferences!.getString(endpointDateKey(endpoint));

      if (value != null && dateString != null) {
        final date = DateTime.tryParse(dateString);
        values[endpoint] = EndpointData(value: value, date: date);
      }
    }
    return EndpointsData(values: values);
  }
}
