import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final double purchasePrice;
  final double salePrice;
  final double surveyPrice;
  final int minQty;
  final bool showToSurvey;
  final int currentQuantity; // تُقرأ من قاعدة البيانات ولا تُعدل يدوياً

  const ProductEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.purchasePrice,
    required this.salePrice,
    required this.surveyPrice,
    required this.minQty,
    required this.showToSurvey,
    this.currentQuantity = 0,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        name,
        purchasePrice,
        salePrice,
        surveyPrice,
        minQty,
        showToSurvey,
        currentQuantity,
      ];
}
