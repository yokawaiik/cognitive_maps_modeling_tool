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
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Obx(
        () => WillPopScope(
          onWillPop: controller.closeMapEditor,
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dynamic calculation"),
                  Text(
                    'Choosed map: ${controller.CMEC.fileMapModel.value.name}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              actions: [
                PopupMenuButton(
                  icon: Icon(Icons.menu),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: controller.saveToFile,
                      child: ListTile(
                        leading: Icon(Icons.save),
                        title: Text("Save to file"),
                      ),
                    )
                  ],
                )
              ],
              bottom: TabBar(
                controller: controller.tabController,
                indicatorColor: colorScheme.primary,
                labelColor: colorScheme.primary,
                onTap: controller.onTap,
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
              controller: controller.tabController,
              children: [
                TabMapEditor(),
                TabAnalysis(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
