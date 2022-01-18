import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

const double _whiteSpace = 10;

class PlaceholderTreeViewItem extends LazilyExpandingTreeViewItem {
  PlaceholderTreeViewItem() : super(content: const ProgressBar());
}

class LazilyExpandingTreeViewItem with Diagnosticable {
  final Key? key;

  /// The item leading
  ///
  /// Usually an [Icon]
  final Widget? leading;

  /// The item content
  ///
  /// Usually a [Text]
  final Widget content;

  /// The children of this item.
  final List<LazilyExpandingTreeViewItem> children;

  /// Whether the item can be collapsable by user-input or not.
  ///
  /// Defaults to `true`
  final bool collapsable;

  LazilyExpandingTreeViewItem? _parent;

  /// [TreeViewItem] that owns the [children] collection that this node is part
  /// of.
  ///
  /// If null, this is the root node
  LazilyExpandingTreeViewItem? get parent => _parent;

  /// Whether the current item is expanded.
  ///
  /// It has no effect if [children] is empty.
  bool expanded;

  /// Whether the current item is selected.
  ///
  /// If [LazilyExpandingTreeView.selectionMode] is [TreeViewSelectionMode.none], this has no
  /// effect. If it's [TreeViewSelectionMode.single], this item is going to be
  /// the only selected item. If it's [TreeViewSelectionMode.multiple], this
  /// item is going to be one of the selected items
  bool? selected;

  /// Called when this item is invoked
  final VoidCallback? onInvoked;

  /// Called when this item is expanded
  final VoidCallback? onExpanded;

  /// The background color of this item.
  ///
  /// See also:
  ///
  ///   * [ButtonThemeData.uncheckedInputColor], which is used by default
  final ButtonState<Color>? backgroundColor;

  /// Whether this item is visible or not. Used to not lose the item state while
  /// it's not on the screen
  bool _visible = true;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// An easily referencable piece of data that represents this node.
  final String tag;

  /// {@macro fluent_ui.controls.inputs.HoverButton.semanticLabel}
  final String? semanticLabel;

  /// Creates a tab view item
  LazilyExpandingTreeViewItem({
    this.key,
    this.leading,
    required this.content,
    this.children = const [],
    this.collapsable = true,
    this.expanded = true,
    this.selected = false,
    this.onInvoked,
    this.onExpanded,
    this.backgroundColor,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.tag = '',
  });

  /// Indicates how far from the root node this child node is.
  ///
  /// If this is the root node, the depth is 0
  int get depth {
    if (parent != null) {
      var count = 1;
      LazilyExpandingTreeViewItem? currentParent = parent!;
      while (currentParent?.parent != null) {
        count++;
        currentParent = currentParent?.parent;
      }

      return count;
    }

    return 0;
  }

  /// Gets the last parent in the tree, in decrescent order.
  ///
  /// If this is the root parent, [this] is returned
  LazilyExpandingTreeViewItem get lastParent {
    if (parent != null) {
      var currentParent = parent!;
      while (currentParent.parent != null) {
        if (currentParent.parent != null) currentParent = currentParent.parent!;
      }
      return currentParent;
    }
    return this;
  }

  /// Executes [callback] for every parent found in the tree
  void executeForAllParents(
      ValueChanged<LazilyExpandingTreeViewItem?> callback) {
    if (parent == null) return;
    LazilyExpandingTreeViewItem? currentParent = parent!;
    callback(currentParent);
    while (currentParent?.parent != null) {
      currentParent = currentParent?.parent;
      callback(currentParent);
    }
  }

  /// Updates [selected] based on the [children]s' state
  void updateSelected() {
    var hasNull = false;
    var hasFalse = false;
    var hasTrue = false;

    for (final child in children.build(assignParent: false)) {
      if (child.selected == null) {
        hasNull = true;
      } else if (child.selected == false) {
        hasFalse = true;
      } else if (child.selected == true) {
        hasTrue = true;
      }
    }

    selected = hasNull || (hasTrue && hasFalse) ? null : hasTrue;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('hasLeading',
          value: leading != null, ifFalse: 'no leading'))
      ..add(FlagProperty('hasChildren',
          value: children.isNotEmpty, ifFalse: 'has children'))
      ..add(FlagProperty('collapsable',
          value: collapsable, defaultValue: true, ifFalse: 'uncollapsable'))
      ..add(FlagProperty('isRootNode',
          value: parent == null, ifFalse: 'has parent'))
      ..add(FlagProperty('expanded',
          value: expanded, defaultValue: true, ifFalse: 'collapsed'))
      ..add(FlagProperty('selected',
          value: selected, defaultValue: false, ifFalse: 'unselected'));
  }
}

extension TreeViewItemCollection on List<LazilyExpandingTreeViewItem> {
  /// Adds the [TreeViewItem.parent] property to the [TreeViewItem]s
  List<LazilyExpandingTreeViewItem> build({
    LazilyExpandingTreeViewItem? parent,
    bool assignParent = true,
  }) {
    if (isNotEmpty) {
      final list = <LazilyExpandingTreeViewItem>[];
      for (final item in [...this]) {
        list.add(item);
        if (assignParent) item._parent = parent;
        if (parent != null) {
          item._visible = parent._visible;
        }
        for (final child in item.children) {
          // only add the children when it's expanded
          child._visible = item.expanded;
          if (assignParent) child._parent = item;
          list.add(child);
          if (child.expanded) {
            list.addAll(child.children.build(parent: child));
          }
        }
      }
      return list;
    }

    return this;
  }

  void executeForAll(ValueChanged<LazilyExpandingTreeViewItem> callback) {
    for (final child in this) {
      callback(child);
      child.children.executeForAll(callback);
    }
  }
}

/// The `TreeView` control enables a hierarchical list with expanding and
/// collapsing nodes that contain nested items. It can be used to illustrate a
/// folder structure or nested relationships in your UI.
///
/// The tree view uses a combination of indentation and icons to represent the
/// nested relationship between parent nodes and child nodes. Collapsed items
/// use a chevron pointing to the right, and expanded nodes use a chevron
/// pointing down.
///
/// ![TreeView Simple](https://docs.microsoft.com/en-us/windows/apps/design/controls/images/treeview-simple.png)
///
/// You can include an icon in the [TreeViewItem] template to represent items.
/// For example, if you show a file system hierarchy, you could use folder
/// icons for the parent items and file icons for the leaf items.
///
/// ![TreeView with Icons](https://docs.microsoft.com/en-us/windows/apps/design/controls/images/treeview-icons.png)
///
/// See also:
///
///  * <https://docs.microsoft.com/en-us/windows/apps/design/controls/tree-view>
///  * [TreeViewItem], used to render the tiles
///  * [Checkbox], used on multiple selection mode
class LazilyExpandingTreeView extends StatefulWidget {
  /// Creates a tree view.
  ///
  /// [items] must not be empty
  const LazilyExpandingTreeView({
    Key? key,
    required this.items,
    this.selectionMode = TreeViewSelectionMode.none,
    this.onItemInvoked,
    this.onItemExpanded,
  })  : assert(items.length > 0, 'There must be at least one item'),
        super(key: key);

  /// The items of the tree view.
  ///
  /// Must not be empty
  final List<LazilyExpandingTreeViewItem> items;

  /// The current selection mode.
  ///
  /// [TreeViewSelectionMode.none] is used by default
  final TreeViewSelectionMode selectionMode;

  /// Called when an item is invoked
  final ValueChanged<LazilyExpandingTreeViewItem>? onItemInvoked;

  /// Called when an item is expanded
  final ValueChanged<LazilyExpandingTreeViewItem>? onItemExpanded;

  @override
  _LazilyExpandingTreeViewState createState() =>
      _LazilyExpandingTreeViewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty('selectionMode', selectionMode,
          defaultValue: TreeViewSelectionMode.none))
      ..add(IterableProperty<LazilyExpandingTreeViewItem>('items', items));
  }
}

class _LazilyExpandingTreeViewState extends State<LazilyExpandingTreeView> {
  late List<LazilyExpandingTreeViewItem> items;

  @override
  void initState() {
    super.initState();
    items = widget.items.build();
  }

  @override
  void didUpdateWidget(LazilyExpandingTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      items = widget.items.build();
    }
  }

  @override
  void dispose() {
    items.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return Container(
      constraints: const BoxConstraints(minHeight: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final item = items[index];

          return _TreeViewItem(
            key: item.key ?? ValueKey<LazilyExpandingTreeViewItem>(item),
            item: item,
            selectionMode: widget.selectionMode,
            onSelect: () {
              switch (widget.selectionMode) {
                case TreeViewSelectionMode.single:
                  setState(() {
                    for (final item in items) {
                      item.selected = false;
                    }
                    item.selected = true;
                  });
                  break;
                case TreeViewSelectionMode.multiple:
                  setState(() {
                    // if it's root
                    if (item.selected == null || item.selected == false) {
                      item
                        ..selected = true
                        ..children.executeForAll((item) {
                          item.selected = true;
                        })
                        ..executeForAllParents((p) => p?.updateSelected());
                    } else {
                      item
                        ..selected = false
                        ..children.executeForAll((item) {
                          item.selected = false;
                        })
                        ..executeForAllParents((p) => p?.updateSelected());
                    }
                  });
                  break;
                default:
                  break;
              }
            },
            onExpandToggle: () {
              item.onExpanded?.call();
              widget.onItemExpanded?.call(item);

              if (item.collapsable) {
                setState(() {
                  item.expanded = !item.expanded;
                  items = widget.items.build();
                });
              }
            },
            onInvoked: () {
              item.onInvoked?.call();
              widget.onItemInvoked?.call(item);
            },
          );
        }),
      ),
    );
  }
}

class _TreeViewItem extends StatelessWidget {
  const _TreeViewItem({
    Key? key,
    required this.item,
    required this.selectionMode,
    required this.onSelect,
    required this.onExpandToggle,
    required this.onInvoked,
  }) : super(key: key);

  final LazilyExpandingTreeViewItem item;
  final TreeViewSelectionMode selectionMode;
  final VoidCallback onSelect;
  final VoidCallback onExpandToggle;
  final VoidCallback onInvoked;

  @override
  Widget build(BuildContext context) {
    if (!item._visible) return const SizedBox.shrink();
    final theme = FluentTheme.of(context);
    final selected = item.selected ?? false;
    return HoverButton(
      onPressed: selectionMode == TreeViewSelectionMode.none
          ? onInvoked
          : selectionMode == TreeViewSelectionMode.single
              ? () {
                  onSelect();
                  onInvoked();
                }
              : onInvoked,
      autofocus: item.autofocus,
      focusNode: item.focusNode,
      semanticLabel: item.semanticLabel,
      margin: const EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 4.0,
      ),
      builder: (context, states) {
        return Stack(
          children: [
            Container(
              height:
                  selectionMode == TreeViewSelectionMode.multiple ? 28.0 : 26.0,
              padding: EdgeInsets.only(
                left: 20.0 + item.depth * _whiteSpace,
              ),
              decoration: BoxDecoration(
                color: item.backgroundColor?.resolve(states) ??
                    ButtonThemeData.uncheckedInputColor(
                      theme,
                      [
                        TreeViewSelectionMode.multiple,
                        TreeViewSelectionMode.none
                      ].contains(selectionMode)
                          ? states
                          : selected && (states.isPressing || states.isNone)
                              ? {ButtonStates.hovering}
                              : selected && states.isHovering
                                  ? {ButtonStates.pressing}
                                  : states,
                    ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (selectionMode == TreeViewSelectionMode.multiple)
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Checkbox(
                        checked: item.selected,
                        onChanged: (value) {
                          onSelect();
                          onInvoked();
                        },
                      ),
                    ),
                  if (item.children.isNotEmpty)
                    GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: onExpandToggle,
                      child: Icon(
                        item.expanded
                            ? FluentIcons.chevron_down
                            : FluentIcons.chevron_right,
                        size: 8.0,
                        color: Colors.grey[80],
                      ),
                    ),
                  if (item.leading != null)
                    Container(
                      margin: const EdgeInsets.only(left: 18.0),
                      width: 20.0,
                      child: IconTheme.merge(
                        data: const IconThemeData(size: 20.0),
                        child: item.leading!,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 12.0,
                        color: theme.typography.body!.color!.withOpacity(
                          states.isPressing ? 0.7 : 1.0,
                        ),
                      ),
                      child: item.content,
                    ),
                  ),
                ],
              ),
            ),
            if (selected && selectionMode == TreeViewSelectionMode.single)
              Positioned(
                top: 6.0,
                bottom: 6.0,
                left: 0.0,
                child: Container(
                  width: 3.0,
                  decoration: BoxDecoration(
                    color: theme.accentColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
