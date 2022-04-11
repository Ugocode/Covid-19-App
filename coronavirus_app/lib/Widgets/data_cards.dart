import 'package:coronavirus_app/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//creating an design for our cards
class DataCardFeatures {
  final String? title;
  final String? assetName;
  final Color? color;

  DataCardFeatures(this.title, this.assetName, this.color);
}

class DataCard extends StatelessWidget {
  final EndPoint? endpoint;
  final int? value;
  const DataCard({
    Key? key,
    this.endpoint,
    this.value,
  }) : super(key: key);

// creat a map to define each endpoint
  static final Map<EndPoint, DataCardFeatures> _cardData = {
    EndPoint.cases: DataCardFeatures(
        "Cases", 'assets/count.png', const Color.fromARGB(255, 255, 146, 242)),
    EndPoint.casesConfirmed: DataCardFeatures("Confiremd Cases",
        'assets/fever.png', const Color.fromARGB(249, 24, 40, 213)),
    EndPoint.casesSuspected: DataCardFeatures("Suspected Cases",
        'assets/suspect.png', const Color.fromARGB(255, 205, 189, 46)),
    EndPoint.deaths: DataCardFeatures(
        "Deaths", 'assets/death.png', const Color.fromARGB(255, 213, 14, 14)),
    EndPoint.recovered: DataCardFeatures("Recovered", 'assets/patient.png',
        const Color.fromARGB(255, 70, 213, 62)),
  };

  //formatting the numbers properly:

  String get formattedValue {
    if (value == null) {
      return '';
    }
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardData[endpoint];

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: cardData!.color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardData.title.toString(),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 35,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(cardData.assetName.toString()),
                      Text(
                        formattedValue,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
