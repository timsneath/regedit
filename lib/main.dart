import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'registry_data_view.dart';
import 'registry_tree_view.dart';
import 'widgets/splitter.dart';

void main() {
  runApp(
    const RegistryEditor(),
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
    return ChangeNotifierProvider(
      create: (context) => RegistryDataModel(),
      builder: (context, widget) {
        return NavigationView(
          appBar: const NavigationAppBar(title: Text('Registry Editor')),
          content: ScaffoldPage(
              header: TextBox(
                  placeholder:
                      Provider.of<RegistryDataModel>(context).fullPath),
              content: Splitter(
                axis: Axis.horizontal,
                initialFractions: const [0.3, 0.7],
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      child: Wrap(
                        direction: Axis.vertical,
                        children: const [RegistryTreeView()],
                      ),
                      width: 400,
                    ),
                  ),
                  Expanded(
                    child: Material(child: RegistryDataView()),
                  ),
                ],
              ),
              bottomBar: () {
                final errorText =
                    Provider.of<RegistryDataModel>(context).errorText;
                if (errorText.isNotEmpty) {
                  return InfoBar(
                    severity: InfoBarSeverity.error,
                    title: Text(errorText),
                  );
                }
              }()),
        );
      },
    );
  }
}
