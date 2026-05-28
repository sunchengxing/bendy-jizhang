import 'package:flutter/material.dart';
import 'package:bendy_jizhang/util/color_util.dart';

Future<String?> showColorPickerSheet(BuildContext context, {String? selected}) {
  return showModalBottomSheet<String>(
    context: context,
    builder: (_) => _ColorPickerGrid(selected: selected),
  );
}

class _ColorPickerGrid extends StatelessWidget {
  final String? selected;
  const _ColorPickerGrid({this.selected});

  static const colors = [
    '#F44336', '#E91E63', '#9C27B0', '#673AB7',
    '#3F51B5', '#2196F3', '#00BCD4', '#009688',
    '#4CAF50', '#8BC34A', '#CDDC39', '#FFC107',
    '#FF9800', '#FF5722', '#795548', '#607D8B',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8, runSpacing: 8,
        children: colors.map((hex) {
          return GestureDetector(
            onTap: () => Navigator.pop(context, hex),
            child: CircleAvatar(
              backgroundColor: ColorUtil.fromHex(hex),
              radius: 20,
              child: hex == selected ? const Icon(Icons.check, color: Colors.white) : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
