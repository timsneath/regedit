import 'dart:collection';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:win32_registry/win32_registry.dart';

class RegistryDataModel extends ChangeNotifier {
  final List<RegistryValue> _values = [];

  UnmodifiableListView<RegistryValue> get values =>
      UnmodifiableListView(_values);

  RegistryDataModel() {
    updatePath(RegistryHive.localMachine,
        r'SOFTWARE\Microsoft\Windows NT\CurrentVersion');
  }

  void updatePath(RegistryHive hive, String path) {
    final key = Registry.openPath(hive, path: path);
    _values.addAll(key.values);
    notifyListeners();
  }
}
