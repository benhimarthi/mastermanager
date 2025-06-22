import 'package:mastermanager/features/product_pricing/domain/entities/product.pricing.dart';

class ProductPricingModel extends ProductPricing {
  const ProductPricingModel({
    required super.id,
    required super.productId,
    required super.currency,
    required super.country,
    required super.amount,
    required super.discountPercent,
    required super.active,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductPricingModel.fromEntity(ProductPricing entity) {
    return ProductPricingModel(
      id: entity.id,
      productId: entity.productId,
      currency: entity.currency,
      country: entity.country,
      amount: entity.amount,
      discountPercent: entity.discountPercent,
      active: entity.active,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ProductPricing toEntity() {
    return ProductPricing(
      id: id,
      productId: productId,
      currency: currency,
      country: country,
      amount: amount,
      discountPercent: discountPercent,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductPricingModel.fromMap(Map<String, dynamic> map) {
    return ProductPricingModel(
      id: map['id'] as String,
      productId: map['productId'] as String,
      currency: map['currency'] as String,
      country: map['country'] as String,
      amount: (map['amount'] as num).toDouble(),
      discountPercent: (map['discountPercent'] as num).toDouble(),
      active: map['active'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'currency': currency,
      'country': country,
      'amount': amount,
      'discountPercent': discountPercent,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        currency,
        country,
        amount,
        discountPercent,
        active,
        createdAt,
        updatedAt,
      ];
}
