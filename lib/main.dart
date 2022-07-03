import 'package:flutter/material.dart';
import 'package:hls_player/screens/home.dart';

ValueNotifier<int> themechange = ValueNotifier(0);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, int value, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Yellow_Class_Task',
            theme: ThemeData(
              primarySwatch: Colors.yellow,
              appBarTheme: AppBarTheme(
                  backgroundColor: Color.fromRGBO(255, 247, 197, 1.0)),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: (value == 0) ? ThemeMode.light : ThemeMode.dark,
            home: const HomePage());
      },
      valueListenable: themechange,
    );
  }
}
