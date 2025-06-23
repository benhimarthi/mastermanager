import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              TextFormField(
                controller: _categoryId,
                decoration: const InputDecoration(labelText: 'Category ID'),
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
              TextFormField(
                controller: _pricingId,
                decoration: const InputDecoration(labelText: 'Pricing ID'),
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
