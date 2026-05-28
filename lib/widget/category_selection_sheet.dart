import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/util/color_util.dart';
import 'package:bendy_jizhang/provider/data_provider.dart';

class CategorySelectionSheet extends ConsumerWidget {
  final CategoryType type;
  final int? selectedId;
  const CategorySelectionSheet({super.key, required this.type, this.selectedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesByTypeProvider(type));

    return categoriesAsync.when(
      data: (categories) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text('选择分类', style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat.id == selectedId;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ColorUtil.fromHex(cat.color),
                      child: Icon(Icons.category, color: Colors.white, size: 20),
                    ),
                    title: Text(cat.name),
                    trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                    selected: isSelected,
                    onTap: () => Navigator.pop(context, cat),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }

  static Future<Category?> show(BuildContext context, {required CategoryType type, int? selectedId}) {
    return showModalBottomSheet<Category>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CategorySelectionSheet(type: type, selectedId: selectedId),
    );
  }
}
