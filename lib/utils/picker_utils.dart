// picker_utils.dart
import 'package:flutter/cupertino.dart';
import 'package:siffrum_sa/models/role.dart';

void showRolePicker({
  required BuildContext context,
  required List<Role> roles,
  required String selectedValue,
  required Function(String) onSelected,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => Container(
      height: 300,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              backgroundColor: CupertinoColors.systemBackground.resolveFrom(
                context,
              ),
              scrollController: FixedExtentScrollController(
                initialItem: roles.indexWhere((r) => r.value == selectedValue),
              ),
              onSelectedItemChanged: (index) {
                onSelected(roles[index].value);
              },
              children: roles.map((r) => Center(child: Text(r.label))).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}
