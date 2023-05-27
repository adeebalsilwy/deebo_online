import 'package:flutter/material.dart';
import 'package:deebo_online/Mysql_DB_roq/sample2_curdPages_roq/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(CURD_Mysql_sample2_Roq());

class CURD_Mysql_sample2_Roq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ar'),
      ],
      debugShowCheckedModeBanner: false,
      title: "Inventory Product ",
      // theme: ThemeData(
      //   primarySwatch: Colors.indigo,
      // ),
      home: SplashScreen(),
    );
  }
}
