import 'package:fluent_ui/fluent_ui.dart';

class RegistryTreeView extends StatelessWidget {
  const RegistryTreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TreeView(
      items: [
        TreeViewItem(
          content: const Text('Work Documents'),
          children: [
            TreeViewItem(content: const Text('XYZ Functional Spec')),
            TreeViewItem(content: const Text('Feature Schedule')),
            TreeViewItem(content: const Text('Overall Project Plan')),
            TreeViewItem(content: const Text('Feature Resources Allocation')),
          ],
        ),
        TreeViewItem(
          content: const Text('Personal Documents'),
          children: [
            TreeViewItem(
              content: const Text('Home Remodel'),
              children: [
                TreeViewItem(content: const Text('Contractor Contact Info')),
                TreeViewItem(content: const Text('Paint Color Scheme')),
                TreeViewItem(content: const Text('Flooring weedgrain type')),
                TreeViewItem(content: const Text('Kitchen cabinet style')),
              ],
            ),
          ],
        ),
      ],
      onItemInvoked: (item) => debugPrint(item.toString()), // (optional)
      selectionMode: TreeViewSelectionMode.single,
    );
  }
}
