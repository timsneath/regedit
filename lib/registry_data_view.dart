import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:win32_registry/win32_registry.dart';

class RegistryDataView extends StatefulWidget {
  const RegistryDataView({Key? key, required this.hive, this.path = ''})
      : super(key: key);

  final RegistryHive hive;
  final String path;

  @override
  _RegistryDataViewState createState() => _RegistryDataViewState();
}

class _RegistryDataViewState extends State<RegistryDataView> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
    PlutoColumn(title: 'Type', field: 'type', type: PlutoColumnType.text()),
    PlutoColumn(title: 'Data', field: 'data', type: PlutoColumnType.text()),
  ];

  final List<PlutoRow> rows = <PlutoRow>[
    PlutoRow(cells: {
      'name': PlutoCell(value: 'BaseBuildRevisionNumber'),
      'type': PlutoCell(value: 'REG_DWORD'),
      'data': PlutoCell(value: '0x000003e9 (1001)'),
    }),
    PlutoRow(cells: {
      'name': PlutoCell(value: 'BuildBranch'),
      'type': PlutoCell(value: 'REG_SZ'),
      'data': PlutoCell(value: 'rs_prerelease'),
    })
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PlutoGrid(columns: columns, rows: rows),
    );
  }
}
