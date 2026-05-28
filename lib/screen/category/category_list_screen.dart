import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/util/color_util.dart';
import 'package:bendy_jizhang/widget/color_picker_sheet.dart';
import 'package:bendy_jizhang/provider/data_provider.dart';
import 'package:bendy_jizhang/provider/repository_provider.dart';

class CategoryListScreen extends ConsumerStatefulWidget {
  const CategoryListScreen({super.key});

  @override
  ConsumerState<CategoryListScreen> createState() =>
      _CategoryListScreenState();
}

class _CategoryListScreenState extends ConsumerState<CategoryListScreen> {
  CategoryType _type = CategoryType.expense;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesByTypeProvider(_type));

    return Scaffold(
      appBar: AppBar(
        title: const Text('分类管理'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showEditDialog(context)),
        ],
      ),
      body: Column(
        children: [
          SegmentedButton<CategoryType>(
            segments: const [
              ButtonSegment(value: CategoryType.expense, label: Text('支出')),
              ButtonSegment(value: CategoryType.income, label: Text('收入')),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          Expanded(
            child: categoriesAsync.when(
              data: (categories) {
                final parents = categories.where((c) => c.parentId == null).toList();
                final children = categories.where((c) => c.parentId != null).toList();
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: parents.map((parent) {
                    final sub = children.where((c) => c.parentId == parent.id).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: ColorUtil.fromHex(parent.color),
                            child: const Icon(Icons.category, color: Colors.white, size: 20),
                          ),
                          title: Text(parent.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.add, size: 18), onPressed: () => _showEditDialog(context, parentId: parent.id)),
                              IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => _showEditDialog(context, category: parent)),
                            ],
                          ),
                          onLongPress: () => _confirmDelete(parent),
                        ),
                        if (sub.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: Column(
                              children: sub.map((child) => ListTile(
                                leading: CircleAvatar(backgroundColor: ColorUtil.fromHex(child.color), radius: 14, child: const Icon(Icons.category, color: Colors.white, size: 16)),
                                title: Text(child.name, style: Theme.of(context).textTheme.bodyMedium),
                                trailing: IconButton(icon: const Icon(Icons.edit, size: 16), onPressed: () => _showEditDialog(context, category: child)),
                                onLongPress: () => _confirmDelete(child),
                                dense: true,
                              )).toList(),
                            ),
                          ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('加载失败: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, {Category? category, int? parentId}) {
    final nameCtrl = TextEditingController(text: category?.name);
    var icon = category?.icon ?? 'category';
    var color = category?.color ?? '#607D8B';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(category != null ? '编辑分类' : '新建分类'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '分类名称'), maxLength: 30),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('颜色：'),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final c = await showColorPickerSheet(context, selected: color);
                      if (c != null) setDialogState(() => color = c);
                    },
                    child: CircleAvatar(backgroundColor: ColorUtil.fromHex(color), radius: 14),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            TextButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                final repo = ref.read(categoryRepositoryProvider);
                if (category != null) {
                  await repo.save(CategoriesCompanion(
                    id: Value(category.id), type: Value(_type),
                    parentId: Value(category.parentId ?? parentId),
                    name: Value(name), icon: Value(icon), color: Value(color),
                    sortOrder: Value(category.sortOrder), isHidden: Value(category.isHidden),
                  ));
                } else {
                  await repo.save(CategoriesCompanion.insert(
                    type: _type, parentId: Value(parentId),
                    name: name, icon: icon, color: color,
                  ));
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Category category) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('删除分类「${category.name}」？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () { ref.read(categoryRepositoryProvider).delete(category); Navigator.pop(ctx); },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
