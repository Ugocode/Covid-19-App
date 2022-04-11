import 'package:coronavirus_app/Repositories/data_repository.dart';
import 'package:coronavirus_app/app/services/api.dart';
import 'package:coronavirus_app/app/services/api_service.dart';
import 'package:coronavirus_app/app/services/data_catch_service.dart';
import 'package:coronavirus_app/screens/front_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //LETS CONFUGURE OUR RED ERROR SCREEN
  ErrorWidget.builder = (FlutterErrorDetails details) => Material(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                'assets/cry.png',
                height: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Error',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(details.exceptionAsString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.normal))
            ]),
          ),
        ),
      );
//end off error screen configureation

//adding internalisation for the local:
  // Intl.defaultLocale = 'en_GB';
  // await initializeDateFormatting('en_GB', '');

  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefrences = await SharedPreferences.getInstance();

  runApp(MyApp(
    sharedPreferences: sharedPrefrences,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, @required this.sharedPreferences}) : super(key: key);
  final SharedPreferences? sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (context) => DataRepository(
          apiService: APIService(API.sandbox()),
          dataCacheService:
              DAtaCacheService(sharedPreferences: sharedPreferences)),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CORONA VIRUS APP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const FrontScreen(),
      ),
    );
  }
}
