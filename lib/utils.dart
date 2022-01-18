import 'package:win32_registry/win32_registry.dart';

RegistryHive hiveFromFullPath(String fullPath) {
  final hive = fullPath.split(r'\').first;
  switch (hive) {
    case 'HKEY_CLASSES_ROOT':
      return RegistryHive.classesRoot;
    case 'HKEY_CURRENT_USER':
      return RegistryHive.currentUser;
    case 'HKEY_LOCAL_MACHINE':
      return RegistryHive.localMachine;
    case 'HKEY_USERS':
      return RegistryHive.allUsers;
    case 'HKEY_CURRENT_CONFIG':
      return RegistryHive.currentConfig;
    default:
      throw ArgumentError('Tag $hive is not a valid hive.');
  }
}
