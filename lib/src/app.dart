import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/home/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 47, 145, 81),
        ),
        // colorSchemeSeed: Colors.grey,
        useMaterial3: true,
        // iconTheme: const IconThemeData(color: Colors.black),
        // iconTheme: IconTheme.of(context).
      ),
      getPages: [
        GetPage(
          name: HomePage.routeName,
          page: () => HomePage(),
        ),
      ],
    );
  }
}
