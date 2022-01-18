import 'package:fluent_ui/fluent_ui.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:win32_registry/win32_registry.dart';

import 'model.dart';

class RegistryDataView extends StatelessWidget {
  RegistryDataView({Key? key}) : super(key: key);

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
    PlutoColumn(
        title: 'Type',
        field: 'type',
        type: PlutoColumnType.text(),
        readOnly: false,
        renderer: (renderContext) {
          var icon = const Icon(FluentIcons.file_system);
          switch (renderContext.cell.value) {
            case 'REG_SZ':
              icon = const Icon(FluentIcons.text_field);
              break;
            case 'REG_DWORD':
            case 'REG_QWORD':
              icon = const Icon(FluentIcons.number_field);
              break;
          }
          return Chip(
            image: icon,
            text: Text(renderContext.cell.value.toString()),
          );
        }),
    PlutoColumn(
        title: 'Data', field: 'data', width: 400, type: PlutoColumnType.text()),
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
