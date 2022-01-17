import 'package:flutter/material.dart';

import 'grid.dart';

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
    return Container(
      padding: const EdgeInsets.all(15),
      child: const RegistryDataView(),
    );
  }
}
