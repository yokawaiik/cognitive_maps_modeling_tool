import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/home/pages/home_page.dart';
import 'package:mdmwcm_app/src/modules/start/pages/edit_factors_page.dart';
import 'package:mdmwcm_app/src/modules/start/pages/start_page.dart';
import 'modules/home/bindings/home_bindings.dart';
import 'modules/start/bindings/edit_factors_bindings.dart';
import 'modules/start/bindings/start_bindings.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 47, 145, 81),
        ),
        useMaterial3: true,
      ),
      initialRoute: StartPage.routeName,
      getPages: [
        GetPage(
          name: StartPage.routeName,
          page: () => const StartPage(),
          binding: StartBindings(),
        ),
        GetPage(
          name: EditFactorsPage.routeName,
          page: () => EditFactorsPage(),
          binding: EditFactorsBindings(),
        ),
        GetPage(
          name: HomePage.routeName,
          page: () => const HomePage(),
          binding: HomeBindings(),
        ),
      ],
    );
  }
}
