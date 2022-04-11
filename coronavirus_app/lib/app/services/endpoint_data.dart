import 'package:flutter/material.dart';

class EndpointData {
  final int? value;
  final DateTime? date;

  EndpointData({@required this.value, this.date});

  @override
  String toString() => 'date: $date, value: $value';
}
