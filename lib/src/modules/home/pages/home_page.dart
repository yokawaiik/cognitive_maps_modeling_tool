import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/home/controllers/home_controller.dart';
import 'package:mdmwcm_app/src/modules/home/tabs/tab_analysis.dart';

import '../tabs/tab_map_editor.dart';

class HomePage extends GetView<HomeController> {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dynamic calculation"),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.menu),
              itemBuilder: (context) => [
                PopupMenuItem(
                  // todo:Save to file
                  onTap: () => {},
                  child: ListTile(
                    leading: Icon(Icons.save),
                    title: Text("Save to file"),
                  ),
                )
              ],
            )
          ],
          bottom: TabBar(
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            tabs: [
              Tab(
                icon: Icon(Icons.grid_3x3),
                text: "Map editor",
              ),
              Tab(
                icon: Icon(Icons.show_chart),
                text: "Analysis",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TabMapEditor(),
            TabAnalysis(),
          ],
        ),
      ),
    );
  }
}
