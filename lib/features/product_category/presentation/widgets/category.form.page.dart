import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/service/depenedancy.injection.dart';
import '../../domain/entities/product.category.dart';
import '../../domain/usecases/get.all.product.categories.dart';
import '../cubit/local.category.manager.cubit.dart';
import '../cubit/local.category.manager.state.dart';
import 'category.icons.dart';

class CategoryFormPage extends StatefulWidget {
  final ProductCategory? category; // null for create mode

  const CategoryFormPage({super.key, this.category});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  ProductCategory? _selectedParent;
  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    final cat = widget.category;
    _name = TextEditingController(text: cat?.name ?? '');
    _description = TextEditingController(text: cat?.description ?? '');
    _selectedIcon = widget.category?.iconCodePoint != null
        ? IconData(widget.category!.iconCodePoint!, fontFamily: 'MaterialIcons')
        : null;

    if (cat != null && cat.parentId != null) {
      // Load parent reference for dropdown
      final state = context.read<LocalCategoryManagerCubit>().state;
      final allCategories =
          state is LocalCategoryManagerLoaded ? state.categories : [];

      try {
        _selectedParent = allCategories.firstWhere((c) => c.id == cat.parentId);
      } catch (_) {
        _selectedParent = null; // No match found
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final isNew = widget.category == null;
    final newCategory = ProductCategory(
      id: widget.category?.id ??
          const Uuid().v4(), // generate ID for new entries
      name: _name.text.trim(),
      description:
          _description.text.trim().isEmpty ? null : _description.text.trim(),
      parentId: _selectedParent?.id,
      imageUrl: null,
      iconCodePoint: _selectedIcon?.codePoint,
      isActive: true,
      createdAt: widget.category?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final cubit = context.read<LocalCategoryManagerCubit>();
    isNew ? cubit.addCategory(newCategory) : cubit.updateCategory(newCategory);
    Navigator.pop(context); // return to list after submission
  }

  Future<List<ProductCategory>> _loadParentOptions() async {
    final result = await getIt<GetAllProductCategories>()();
    return result.fold((_) => [], (categories) {
      // Exclude self to prevent circular parenting
      return widget.category == null
          ? categories
          : categories.where((c) => c.id != widget.category!.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Category' : 'New Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Wrap(
                  spacing: 12,
                  children: categoryIcons.map((icon) {
                    final isSelected = _selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: CircleAvatar(
                        backgroundColor: isSelected
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                        child: Icon(icon,
                            color: isSelected ? Colors.blue : Colors.black54),
                      ),
                    );
                  }).toList(),
                ),
              ),
              FutureBuilder<List<ProductCategory>>(
                future: _loadParentOptions(),
                builder: (_, snapshot) {
                  final items = snapshot.data ?? [];

                  return DropdownButtonFormField<ProductCategory>(
                    value: _selectedParent,
                    items: items.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    decoration:
                        const InputDecoration(labelText: 'Parent Category'),
                    onChanged: (val) => setState(() => _selectedParent = val),
                    isExpanded: true,
                  );
                },
              ),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Name is required'
                    : null,
              ),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? 'Save Changes' : 'Create Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
