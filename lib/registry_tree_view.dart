import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:win32_registry/win32_registry.dart';

import 'custom_tree_view_item.dart';
import 'model.dart';
import 'utils.dart';

class RegistryTreeView extends StatelessWidget {
  const RegistryTreeView({Key? key}) : super(key: key);

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
            leading: const Icon(FluentIcons.folder),
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
          leading: const Icon(FluentIcons.t_v_monitor),
          content: const Text('Computer'),
          children: [
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_CLASSES_ROOT',
              leading: const Icon(FluentIcons.folder),
              content: const Text('HKEY_CLASSES_ROOT'),
              expanded: false,
              children: [PlaceholderTreeViewItem()],
            ),
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_CURRENT_USER',
              leading: const Icon(FluentIcons.folder),
              content: const Text('HKEY_CURRENT_USER'),
              expanded: false,
              children: [PlaceholderTreeViewItem()],
            ),
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_LOCAL_MACHINE',
              leading: const Icon(FluentIcons.folder),
              content: const Text('HKEY_LOCAL_MACHINE'),
              expanded: false,
              children: [PlaceholderTreeViewItem()],
            ),
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_USERS',
              leading: const Icon(FluentIcons.folder),
              content: const Text('HKEY_USERS'),
              expanded: false,
              children: [PlaceholderTreeViewItem()],
            ),
            LazilyExpandingTreeViewItem(
              tag: 'HKEY_CURRENT_CONFIG',
              leading: const Icon(FluentIcons.folder),
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
