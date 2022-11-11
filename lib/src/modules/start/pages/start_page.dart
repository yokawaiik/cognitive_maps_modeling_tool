import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/start/controllers/start_controller.dart';

class StartPage extends GetView<StartController> {
  static const routeName = "/start";
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cognitive Map Modeling Tool',
          style: textTheme.headline4,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12),
                ),
                onPressed: controller.setFactors,
                child: Text(
                  'Set factors',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12),
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                ),
                onPressed: controller.loadFile,
                child: Text(
                  'Load file',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
