import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:win32_registry/win32_registry.dart';

import 'model.dart';

class RegistryDataView extends StatelessWidget {
  RegistryDataView({Key? key}) : super(key: key);

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
    PlutoColumn(title: 'Type', field: 'type', type: PlutoColumnType.text()),
    PlutoColumn(title: 'Data', field: 'data', type: PlutoColumnType.text()),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: Consumer<RegistryDataModel>(builder: (context, model, child) {
        debugPrint(model.fullPath);
        return PlutoGrid(
          key: Key('Grid_${model.fullPath}'),
          columns: columns,
          rows: [
            for (var row in model.values)
              PlutoRow(
                cells: {
                  'name': PlutoCell(value: row.name),
                  'type': PlutoCell(value: row.type.win32Type),
                  'data': PlutoCell(value: row.data),
                },
              ),
          ],
        );
      }),
    );
  }
}
