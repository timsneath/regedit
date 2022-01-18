import 'dart:collection';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:win32_registry/win32_registry.dart';

import 'utils.dart';

class RegistryDataModel extends ChangeNotifier {
  String fullPath = '';
  final List<RegistryValue> _values = [];
  String errorText = '';

  UnmodifiableListView<RegistryValue> get values =>
      UnmodifiableListView(_values);

  RegistryDataModel() {
    updatePath(
        r'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion');
  }

  void updatePath(String fullPath) {
    this.fullPath = fullPath;
    final hive = hiveFromFullPath(fullPath);
    final path = fullPath.split(r'\').skip(1).join(r'\');

    debugPrint('opening $hive \\ $path');
    try {
      final key = Registry.openPath(hive, path: path);
      errorText = '';
      _values
        ..clear()
        ..addAll(key.values);
      key.close();
    } catch (identifier) {
      errorText = 'Access denied.';
    } finally {
      notifyListeners();
    }
  }
}
