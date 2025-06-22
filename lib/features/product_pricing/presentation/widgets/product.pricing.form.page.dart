import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/product.pricing.dart';
import '../cubit/product.pricing.cubit.dart';

class ProductPricingFormPage extends StatefulWidget {
  final ProductPricing? pricing;

  const ProductPricingFormPage({super.key, this.pricing});

  @override
  State<ProductPricingFormPage> createState() => _ProductPricingFormPageState();
}

class _ProductPricingFormPageState extends State<ProductPricingFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _currency;
  late TextEditingController _country;
  late TextEditingController _amount;
  late TextEditingController _discount;
  bool _active = true;

  @override
  void initState() {
    super.initState();
    final pricing = widget.pricing;
    _currency = TextEditingController(text: pricing?.currency ?? '');
    _country = TextEditingController(text: pricing?.country ?? '');
    _amount = TextEditingController(text: pricing?.amount.toString() ?? '');
    _discount =
        TextEditingController(text: pricing?.discountPercent.toString() ?? '');
    _active = pricing?.active ?? true;
  }

  @override
  void dispose() {
    _currency.dispose();
    _country.dispose();
    _amount.dispose();
    _discount.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final pricing = ProductPricing(
      id: widget.pricing?.id ?? const Uuid().v4(),
      productId: widget.pricing?.productId ??
          'dummy-product-id', // Replace with actual product ref
      currency: _currency.text.trim(),
      country: _country.text.trim(),
      amount: double.parse(_amount.text.trim()),
      discountPercent: double.parse(_discount.text.trim()),
      active: _active,
      createdAt: widget.pricing?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final cubit = context.read<ProductPricingCubit>();

    if (widget.pricing == null) {
      cubit.addPricing(pricing);
    } else {
      cubit.updatePricing(pricing);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.pricing == null ? 'Add Pricing' : 'Edit Pricing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _currency,
                decoration:
                    const InputDecoration(labelText: 'Currency (e.g. USD)'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _country,
                decoration:
                    const InputDecoration(labelText: 'Country (e.g. US)'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _amount,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _discount,
                decoration: const InputDecoration(labelText: 'Discount %'),
                keyboardType: TextInputType.number,
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
