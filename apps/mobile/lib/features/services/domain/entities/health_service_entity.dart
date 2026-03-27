library;

import 'package:equatable/equatable.dart';

class HealthServiceEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String providerName;
  final double price;
  final double? rating;
  final String? imageUrl;
  final bool isAvailable;

  const HealthServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.providerName,
    required this.price,
    this.rating,
    this.imageUrl,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props =>
      [id, title, category, providerName, price, isAvailable];
}
