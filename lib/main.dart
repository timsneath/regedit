import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:win32_registry/win32_registry.dart';

import 'registry_data_view.dart';
import 'registry_tree_view.dart';

void main() {
  runApp(const RegistryEditor());
}

class RegistryEditor extends StatelessWidget {
  const RegistryEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Registry Editor',
      home: MainView(),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: const [
        RegistryTreeView(),
        RegistryDataView(
            hive: RegistryHive.localMachine,
            path: r'SOFTWARE\Microsoft\Windows NT\CurrentVersion'),
      ]),
    );
  }
}
