library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/health_service_model.dart';
import '../../domain/repositories/services_repository.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepository _repository;

  ServicesCubit({required ServicesRepository repository})
      : _repository = repository,
        super(const ServicesInitial());

  Future<void> loadServices() async {
    emit(const ServicesLoading());
    final result = await _repository.getServices();
    result.fold(
      (failure) => emit(ServicesError(failure.message)),
      (services) => emit(ServicesLoaded(
        allServices: services
            .map((e) => HealthServiceModel(
                  id: e.id,
                  title: e.title,
                  description: e.description,
                  category: e.category,
                  providerName: e.providerName,
                  price: e.price,
                  rating: e.rating,
                  imageUrl: e.imageUrl,
                  isAvailable: e.isAvailable,
                ))
            .toList(),
      )),
    );
  }

  void selectCategory(String category) {
    if (state is ServicesLoaded) {
      emit((state as ServicesLoaded).copyWith(selectedCategory: category));
    }
  }
}
