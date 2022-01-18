import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'registry_data_view.dart';
import 'registry_tree_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RegistryDataModel(),
      child: const RegistryEditor(),
    ),
  );
}

class RegistryEditor extends StatelessWidget {
  const RegistryEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
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
      // appBar: const NavigationAppBar(title: Text('Registry Editor')),

      body: Column(
        children: [
          // TextBox(),
          Expanded(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SingleChildScrollView(
                child: SizedBox(
                  child: RegistryTreeView(),
                  width: 400,
                ),
              ),
              Expanded(
                child: RegistryDataView(),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
