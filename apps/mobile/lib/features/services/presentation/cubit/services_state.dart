library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/health_service_entity.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {
  const ServicesInitial();
}

class ServicesLoading extends ServicesState {
  const ServicesLoading();
}

class ServicesLoaded extends ServicesState {
  final List<HealthServiceEntity> allServices;
  final String selectedCategory;

  const ServicesLoaded({
    required this.allServices,
    this.selectedCategory = 'الكل',
  });

  List<HealthServiceEntity> get filteredServices => selectedCategory == 'الكل'
      ? allServices
      : allServices
          .where((s) => s.category == selectedCategory)
          .toList();

  ServicesLoaded copyWith({
    List<HealthServiceEntity>? allServices,
    String? selectedCategory,
  }) =>
      ServicesLoaded(
        allServices: allServices ?? this.allServices,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );

  @override
  List<Object?> get props => [allServices, selectedCategory];
}

class ServicesError extends ServicesState {
  final String message;
  const ServicesError(this.message);

  @override
  List<Object?> get props => [message];
}
