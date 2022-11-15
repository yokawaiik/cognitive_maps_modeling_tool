import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CompactPlutoTable extends StatelessWidget {
  PlutoGridStateManager stateManager;

  final double height;
  Widget? header;

  void Function(PlutoGridOnRowCheckedEvent)? onRowChecked;

  final String isGridBlockedMessage;

  final bool isGridBlocked;

  CompactPlutoTable({
    super.key,
    required this.stateManager,
    this.header,
    this.height = 400,
    this.onRowChecked,
    this.isGridBlocked = false,
    this.isGridBlockedMessage = 'Grid is blocked',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          header ?? const SizedBox.shrink(),
          SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: isGridBlocked ||
                      stateManager.columns.isEmpty ||
                      stateManager.rows.isEmpty
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isGridBlockedMessage,
                          // "You didn't choose any factors.",
                          style: textTheme.headline5,
                        ),
                      ),
                    )
                  : PlutoGrid(
                      key: UniqueKey(),
                      configuration: PlutoGridConfiguration(
                        style: PlutoGridStyleConfig(
                          enableGridBorderShadow: true,
                          // gridBorderColor: Colors.transparent,
                          gridBackgroundColor: Colors.transparent,
                          // oddRowColor: colorScheme.primary,
                          activatedBorderColor: colorScheme.primary,
                          activatedColor: colorScheme.primaryContainer,
                        ),
                      ),
                      columns: stateManager.columns,
                      rows: stateManager.rows,
                      onChanged: (PlutoGridOnChangedEvent event) {
                        // print(event);

                        // if (event.row.cells['status']!.value == 'saved') {
                        //   event.row.cells['status']!.value = 'edited';
                        // }

                        stateManager.notifyListeners();
                      },
                      onLoaded: (PlutoGridOnLoadedEvent event) {
                        stateManager = event.stateManager;
                      },
                      onRowChecked: onRowChecked,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
