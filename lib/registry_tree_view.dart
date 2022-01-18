import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:win32_registry/win32_registry.dart';

import 'model.dart';
import 'utils.dart';
import 'widgets/treeview.dart';

class RegistryTreeView extends StatelessWidget {
  const RegistryTreeView({Key? key}) : super(key: key);

  static const folderIcon = Icon(FluentIcons.folder, size: 16);

  void updateDetailsView(
      LazilyExpandingTreeViewItem item, BuildContext context) {
    debugPrint('updating for ${item.tag}');
    Provider.of<RegistryDataModel>(context, listen: false).updatePath(item.tag);
  }

  void expandChildren(LazilyExpandingTreeViewItem item) {
    if (item.children.first is PlaceholderTreeViewItem) {
      // populate
      item.children.clear();

      final hive = hiveFromFullPath(item.tag);
      final path = item.tag.split(r'\').skip(1).join(r'\');
      final key = Registry.openPath(hive, path: path);
      for (final subkey in key.subkeyNames) {
        item.children.add(
          LazilyExpandingTreeViewItem(
            tag: '${item.tag}\\$subkey',
            leading: folderIcon,
            content: Text(subkey),
            expanded: false,
            children: [PlaceholderTreeViewItem()],
          ),
        );
      }
    }
    debugPrint(
        '${item.tag}: expanded toggling from ${item.expanded} to ${!item.expanded}');
  }

  @override
  Widget build(BuildContext context) {
    return LazilyExpandingTreeView(
      items: [
        LazilyExpandingTreeViewItem(
          leading: const Icon(FluentIcons.t_v_monitor, size: 16),
          content: const Text('Computer'),
          children: [
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_CLASSES_ROOT',
              leading: folderIcon,
              content: const Text('HKEY_CLASSES_ROOT'),
              expanded: false,
              children: [PlaceholderTreeViewItem()],
            ),
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_CURRENT_USER',
              leading: folderIcon,
              content: const Text('HKEY_CURRENT_USER'),
              expanded: false,
              children: [PlaceholderTreeViewItem()],
            ),
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_LOCAL_MACHINE',
              leading: folderIcon,
              content: const Text('HKEY_LOCAL_MACHINE'),
              expanded: false,
              children: [PlaceholderTreeViewItem()],
            ),
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_USERS',
              leading: folderIcon,
              content: const Text('HKEY_USERS'),
              expanded: false,
              children: [PlaceholderTreeViewItem()],
            ),
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_CURRENT_CONFIG',
              leading: folderIcon,
              content: const Text('HKEY_CURRENT_CONFIG'),
              expanded: false,
              children: [PlaceholderTreeViewItem()],
            ),
          ],
        ),
      ],
      onItemInvoked: (item) => updateDetailsView(item, context),
      onItemExpanded: expandChildren,
      selectionMode: TreeViewSelectionMode.single,
    );
  }
}
