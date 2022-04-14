import 'dart:io';

import 'package:coronavirus_app/Repositories/data_repository.dart';
import 'package:coronavirus_app/Repositories/endpoints_data.dart';
import 'package:coronavirus_app/Widgets/data_cards.dart';
import 'package:coronavirus_app/Widgets/last_updated_status_text.dart';
import 'package:coronavirus_app/app/services/api.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/alert_dialoge_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EndpointsData? _endpointsData;

  @override
  void initState() {
    super.initState();
    //to getthe data from the cached service first:
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _endpointsData = dataRepository.getAllEndpointsCachedData();
    //to get the data from the API service:
    _updateData();
  }

//Now We use Provider to get the data to the home page:
  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointsData();
      setState(() => _endpointsData = endpointsData);
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrive data. Please check network',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact Support or try again later',
        defaultActionText: 'OK',
      );
    }
  }

//dispose this if done:
  @override
  void dispose() {
    super.dispose();
    _updateData();
  }

  @override
  Widget build(BuildContext context) {
//format the date with :
    final formatter = LastUpdatedDataFormeter(
      lastUpdated: _endpointsData != null
          ? _endpointsData!.values[EndPoint.cases]?.date
          : null,
    );

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromARGB(249, 80, 71, 181),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _updateData,
            child: ListView(
              children: [
                //top menue icons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.notifications,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                // text of statistics
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Statistics',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                //contaner of country
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 50,
                    width: 160,
                    decoration: BoxDecoration(
                        color: Colors.purple[200],
                        borderRadius: BorderRadius.circular(100)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 48,
                            width: width / 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Center(
                              child: Text('My country'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        const Text('Global')
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      'Total',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      'Today',
                      style: TextStyle(color: Colors.white54, fontSize: 18),
                    ),
                    Text(
                      'Yesterday',
                      style: TextStyle(color: Colors.white54, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //add a collection for:
                for (var endpoint in EndPoint.values)
                  DataCard(
                    endpoint: endpoint,
                    value: _endpointsData != null
                        ? _endpointsData!.values[endpoint]?.value
                        : null,
                  ),

                LastUpdatedStatusText(
                  text: formatter.lastUpdatedStatusText(),
                ),
              ],
            ),
          ),
        ));
  }
}



// final casesConfiremd =
    //     await dataRepository.getAllEndpointData(EndPoint.casesConfirmed);
    // final recovered = await dataRepository.getEndPointData(EndPoint.recovered);
    // final deaths = await dataRepository.getEndPointData(EndPoint.deaths);
    // final suspected =
    //     await dataRepository.getEndPointData(EndPoint.casesSuspected);


 // final int _casesConfiremd = 0;
  // final int _recovered = 0;
  // final int _deaths = 0;
  // final int _suspected = 0;

  // _casesConfiremd = casesConfiremd!;
      // _recovered = recovered!;
      // _suspected = suspected!;
      // _deaths = deaths!;