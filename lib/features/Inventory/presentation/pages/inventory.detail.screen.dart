import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory_meta_data/domain/entities/inventory.meta.data.dart';
import '../../../synchronisation/cubit/inventory_meta_data_cubit/inventory.meta.data.cubit.dart';
import '../../domain/entities/inventory.dart';
import '../cubit/inventory.cubit.dart';

// Assume Inventory and InventoryMetadata entities are imported

class InventoryDetailScreen extends StatefulWidget {
  final Inventory? inventory;
  final InventoryMetadata? metadata;

  const InventoryDetailScreen({Key? key, this.inventory, this.metadata})
      : super(key: key);

  @override
  _InventoryDetailScreenState createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  // Inventory controllers
  late TextEditingController _productIdController;
  late TextEditingController _warehouseIdController;
  late TextEditingController _quantityAvailableController;
  late TextEditingController _quantityReservedController;
  late TextEditingController _quantitySoldController;
  late TextEditingController _reorderLevelController;
  late TextEditingController _minimumStockController;
  late TextEditingController _maximumStockController;
  late bool _isOutOfStock;
  late bool _isLowStock;
  late bool _isBlocked;
  late DateTime _lastRestockDate;

  // Metadata controllers
  late TextEditingController _costPerUnitController;
  late TextEditingController _totalStockValueController;
  late TextEditingController _markupPercentageController;
  late TextEditingController _averageDailySalesController;
  late TextEditingController _stockTurnoverRateController;
  late TextEditingController _leadTimeInDaysController;
  late TextEditingController _demandForecastController;
  late TextEditingController _seasonalityFactorController;
  late TextEditingController _inventorySourceController;
  late TextEditingController _createdByController;
  late TextEditingController _updatedByController;

  @override
  void initState() {
    super.initState();

    final inv = widget.inventory;
    final meta = widget.metadata;

    // Inventory init
    _productIdController = TextEditingController(text: inv?.productId ?? '');
    _warehouseIdController =
        TextEditingController(text: inv?.warehouseId ?? '');
    _quantityAvailableController =
        TextEditingController(text: inv?.quantityAvailable.toString() ?? '0');
    _quantityReservedController =
        TextEditingController(text: inv?.quantityReserved.toString() ?? '0');
    _quantitySoldController =
        TextEditingController(text: inv?.quantitySold.toString() ?? '0');
    _reorderLevelController =
        TextEditingController(text: inv?.reorderLevel.toString() ?? '0');
    _minimumStockController =
        TextEditingController(text: inv?.minimumStock.toString() ?? '0');
    _maximumStockController =
        TextEditingController(text: inv?.maximumStock.toString() ?? '0');
    _isOutOfStock = inv?.isOutOfStock ?? false;
    _isLowStock = inv?.isLowStock ?? false;
    _isBlocked = inv?.isBlocked ?? false;
    _lastRestockDate = inv?.lastRestockDate ?? DateTime.now();

    // Metadata init
    _costPerUnitController =
        TextEditingController(text: meta?.costPerUnit.toString() ?? '0.0');
    _totalStockValueController =
        TextEditingController(text: meta?.totalStockValue.toString() ?? '0.0');
    _markupPercentageController =
        TextEditingController(text: meta?.markupPercentage.toString() ?? '0.0');
    _averageDailySalesController = TextEditingController(
        text: meta?.averageDailySales.toString() ?? '0.0');
    _stockTurnoverRateController = TextEditingController(
        text: meta?.stockTurnoverRate.toString() ?? '0.0');
    _leadTimeInDaysController =
        TextEditingController(text: meta?.leadTimeInDays.toString() ?? '0');
    _demandForecastController =
        TextEditingController(text: meta?.demandForecast.toString() ?? '0.0');
    _seasonalityFactorController = TextEditingController(
        text: meta?.seasonalityFactor.toString() ?? '0.0');
    _inventorySourceController =
        TextEditingController(text: meta?.inventorySource ?? '');
    _createdByController = TextEditingController(text: meta?.createdBy ?? '');
    _updatedByController = TextEditingController(text: meta?.updatedBy ?? '');
  }

  @override
  void dispose() {
    // Inventory controllers
    _productIdController.dispose();
    _warehouseIdController.dispose();
    _quantityAvailableController.dispose();
    _quantityReservedController.dispose();
    _quantitySoldController.dispose();
    _reorderLevelController.dispose();
    _minimumStockController.dispose();
    _maximumStockController.dispose();

    // Metadata controllers
    _costPerUnitController.dispose();
    _totalStockValueController.dispose();
    _markupPercentageController.dispose();
    _averageDailySalesController.dispose();
    _stockTurnoverRateController.dispose();
    _leadTimeInDaysController.dispose();
    _demandForecastController.dispose();
    _seasonalityFactorController.dispose();
    _inventorySourceController.dispose();
    _createdByController.dispose();
    _updatedByController.dispose();

    super.dispose();
  }

  Future<void> _selectRestockDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastRestockDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _lastRestockDate) {
      setState(() {
        _lastRestockDate = picked;
      });
    }
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final inventory = Inventory(
        id: widget.inventory?.id ?? UniqueKey().toString(),
        productId: _productIdController.text,
        warehouseId: _warehouseIdController.text,
        quantityAvailable: int.parse(_quantityAvailableController.text),
        quantityReserved: int.parse(_quantityReservedController.text),
        quantitySold: int.parse(_quantitySoldController.text),
        reorderLevel: int.parse(_reorderLevelController.text),
        minimumStock: int.parse(_minimumStockController.text),
        maximumStock: int.parse(_maximumStockController.text),
        isOutOfStock: _isOutOfStock,
        isLowStock: _isLowStock,
        isBlocked: _isBlocked,
        lastRestockDate: _lastRestockDate,
        createdAt: widget.inventory?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final metadata = InventoryMetadata(
        id: widget.metadata?.id ?? UniqueKey().toString(),
        inventoryId: inventory.id,
        costPerUnit: double.parse(_costPerUnitController.text),
        totalStockValue: double.parse(_totalStockValueController.text),
        markupPercentage: double.parse(_markupPercentageController.text),
        averageDailySales: double.parse(_averageDailySalesController.text),
        stockTurnoverRate: double.parse(_stockTurnoverRateController.text),
        leadTimeInDays: int.parse(_leadTimeInDaysController.text),
        demandForecast: double.parse(_demandForecastController.text),
        seasonalityFactor: double.parse(_seasonalityFactorController.text),
        inventorySource: _inventorySourceController.text,
        createdBy: _createdByController.text,
        updatedBy: _updatedByController.text,
      );

      final inventoryCubit = context.read<InventoryCubit>();
      final metadataCubit = context.read<InventoryMetadataCubit>();

      if (widget.inventory == null) {
        inventoryCubit.addInventory(inventory);
        metadataCubit.addMetadata(metadata);
      } else {
        inventoryCubit.updateInventory(inventory);
        metadataCubit.updateMetadata(metadata);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.inventory != null;

    return Scaffold(
      appBar:
          AppBar(title: Text(isEditing ? 'Edit Inventory' : 'Add Inventory')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inventory Fields
              TextFormField(
                controller: _productIdController,
                decoration: const InputDecoration(labelText: 'Product ID'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _warehouseIdController,
                decoration: const InputDecoration(labelText: 'Warehouse ID'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _quantityAvailableController,
                decoration:
                    const InputDecoration(labelText: 'Quantity Available'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _quantityReservedController,
                decoration:
                    const InputDecoration(labelText: 'Quantity Reserved'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _quantitySoldController,
                decoration: const InputDecoration(labelText: 'Quantity Sold'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _reorderLevelController,
                decoration: const InputDecoration(labelText: 'Reorder Level'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _minimumStockController,
                decoration: const InputDecoration(labelText: 'Minimum Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _maximumStockController,
                decoration: const InputDecoration(labelText: 'Maximum Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),

              SwitchListTile(
                title: const Text('Out of Stock'),
                value: _isOutOfStock,
                onChanged: (val) => setState(() => _isOutOfStock = val),
              ),
              SwitchListTile(
                title: const Text('Low Stock'),
                value: _isLowStock,
                onChanged: (val) => setState(() => _isLowStock = val),
              ),
              SwitchListTile(
                title: const Text('Blocked'),
                value: _isBlocked,
                onChanged: (val) => setState(() => _isBlocked = val),
              ),

              ListTile(
                title: const Text('Last Restock Date'),
                subtitle: Text('${_lastRestockDate.toLocal()}'.split(' ')[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectRestockDate(context),
                ),
              ),

              const Divider(height: 40),
              const Text('Inventory Metadata',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              TextFormField(
                controller: _costPerUnitController,
                decoration: const InputDecoration(labelText: 'Cost Per Unit'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _totalStockValueController,
                decoration:
                    const InputDecoration(labelText: 'Total Stock Value'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _markupPercentageController,
                decoration:
                    const InputDecoration(labelText: 'Markup Percentage'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _averageDailySalesController,
                decoration:
                    const InputDecoration(labelText: 'Average Daily Sales'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _stockTurnoverRateController,
                decoration:
                    const InputDecoration(labelText: 'Stock Turnover Rate'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _leadTimeInDaysController,
                decoration:
                    const InputDecoration(labelText: 'Lead Time (Days)'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || int.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _demandForecastController,
                decoration: const InputDecoration(labelText: 'Demand Forecast'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _seasonalityFactorController,
                decoration:
                    const InputDecoration(labelText: 'Seasonality Factor'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Enter valid number'
                    : null,
              ),
              TextFormField(
                controller: _inventorySourceController,
                decoration:
                    const InputDecoration(labelText: 'Inventory Source'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _createdByController,
                decoration: const InputDecoration(labelText: 'Created By'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _updatedByController,
                decoration: const InputDecoration(labelText: 'Updated By'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
