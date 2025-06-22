import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.categoryId,
    required super.unit,
    required super.barcode,
    required super.imageUrl,
    required super.pricingId,
    required super.active,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      categoryId: entity.categoryId,
      unit: entity.unit,
      barcode: entity.barcode,
      imageUrl: entity.imageUrl,
      pricingId: entity.pricingId,
      active: entity.active,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Product toEntity() => Product(
        id: id,
        name: name,
        description: description,
        categoryId: categoryId,
        unit: unit,
        barcode: barcode,
        imageUrl: imageUrl,
        pricingId: pricingId,
        active: active,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      categoryId: map['categoryId'] as String,
      unit: map['unit'] as String,
      barcode: map['barcode'] as String,
      imageUrl: map['imageUrl'] as String,
      pricingId: map['pricingId'] as String,
      active: map['active'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'unit': unit,
      'barcode': barcode,
      'imageUrl': imageUrl,
      'pricingId': pricingId,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
