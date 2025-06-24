import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastermanager/features/product_category/presentation/cubit/local.category.manager.cubit.dart';
import 'package:mastermanager/features/product_category/presentation/cubit/local.category.manager.state.dart';
import 'package:mastermanager/features/product_pricing/domain/entities/product.pricing.dart';
import 'package:mastermanager/features/product_pricing/presentation/cubit/product.pricing.cubit.dart';
import 'package:mastermanager/features/product_pricing/presentation/cubit/product.pricing.state.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/product.dart';
import '../cubit/product.cubit.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _name;
  late TextEditingController _description;
  late TextEditingController _categoryId;
  late TextEditingController _unit;
  late TextEditingController _barcode;
  late TextEditingController _imageUrl;
  late TextEditingController _pricingId;
  bool _active = true;
  String? _selectedCategoryId;
  String? _selectedPricingId;
  late List<Category> categories;
  late List<ProductPricing> pricing;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _name = TextEditingController(text: product?.name ?? '');
    _description = TextEditingController(text: product?.description ?? '');
    _categoryId = TextEditingController(text: product?.categoryId ?? '');
    _unit = TextEditingController(text: product?.unit ?? '');
    _barcode = TextEditingController(text: product?.barcode ?? '');
    _imageUrl = TextEditingController(text: product?.imageUrl ?? '');
    _pricingId = TextEditingController(text: product?.pricingId ?? '');
    _active = product?.active ?? true;
    context.read<ProductPricingCubit>().loadPricing();
    context.read<LocalCategoryManagerCubit>().loadCategories();
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _categoryId.dispose();
    _unit.dispose();
    _barcode.dispose();
    _imageUrl.dispose();
    _pricingId.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final product = Product(
      id: widget.product?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      description: _description.text.trim(),
      categoryId: _categoryId.text.trim(),
      unit: _unit.text.trim(),
      barcode: _barcode.text.trim(),
      imageUrl: _imageUrl.text.trim(),
      pricingId: _pricingId.text.trim(),
      active: _active,
      createdAt: widget.product?.createdAt ?? now,
      updatedAt: now,
    );

    final cubit = context.read<ProductCubit>();

    if (widget.product == null) {
      cubit.addProduct(product);
    } else {
      cubit.updateProduct(product);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              BlocConsumer<LocalCategoryManagerCubit,
                  LocalCategoryManagerState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return state is LocalCategoryManagerLoaded
                      ? DropdownButtonFormField<String>(
                          value: _selectedCategoryId,
                          decoration:
                              const InputDecoration(labelText: 'Category'),
                          items: state.categories.map((c) {
                            return DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCategoryId = val),
                          validator: (val) =>
                              val == null ? 'Select a category' : null,
                        )
                      : const SizedBox();
                },
              ),
              TextFormField(
                controller: _unit,
                decoration:
                    const InputDecoration(labelText: 'Unit (e.g. kg, box)'),
              ),
              TextFormField(
                controller: _barcode,
                decoration: const InputDecoration(labelText: 'Barcode'),
              ),
              TextFormField(
                controller: _imageUrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              BlocConsumer<ProductPricingCubit, ProductPricingState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return state is ProductPricingManagerLoaded
                      ? DropdownButtonFormField<String>(
                          value: _selectedPricingId,
                          decoration:
                              const InputDecoration(labelText: 'Pricing Tier'),
                          items: state.pricingList
                              .map((p) => DropdownMenuItem(
                                    value: p.id,
                                    child: Text(
                                        '${p.country} - ${p.amount.toStringAsFixed(2)}'),
                                  ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedPricingId = val),
                          validator: (val) =>
                              val == null ? 'Choose a pricing option' : null,
                        )
                      : const SizedBox();
                },
              ),
              SwitchListTile(
                title: const Text('Active'),
                value: _active,
                onChanged: (val) => setState(() => _active = val),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
