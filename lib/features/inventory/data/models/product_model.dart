import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.purchasePrice,
    required super.salePrice,
    required super.surveyPrice,
    required super.minQty,
    required super.showToSurvey,
    super.currentQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Supabase View (product_stock) سيتم دمجه مع هذا الـ JSON
    return ProductModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (json['sale_price'] as num?)?.toDouble() ?? 0.0,
      surveyPrice: (json['survey_price'] as num?)?.toDouble() ?? 0.0,
      minQty: json['min_qty'] as int? ?? 5,
      showToSurvey: json['show_to_survey'] as bool? ?? false,
      // الكمية المحسوبة من الـ View، إذا لم تكن موجودة نعطيها 0
      currentQuantity:
          (json['product_stock'] != null && json['product_stock'].isNotEmpty)
              ? (json['product_stock'][0]['current_quantity'] as int? ?? 0)
              : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'purchase_price': purchasePrice,
      'sale_price': salePrice,
      'survey_price': surveyPrice,
      'min_qty': minQty,
      'show_to_survey': showToSurvey,
    };
  }
}
