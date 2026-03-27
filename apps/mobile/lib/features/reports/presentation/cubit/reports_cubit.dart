library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/reports_repository.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository _repository;

  ReportsCubit({required ReportsRepository repository})
      : _repository = repository,
        super(const ReportsInitial());

  Future<void> loadReports(String patientId) async {
    emit(const ReportsLoading());
    final result = await _repository.getReports(patientId);
    result.fold(
      (failure) => emit(ReportsError(failure.message)),
      (reports) => emit(ReportsLoaded(reports)),
    );
  }

  Future<void> generateReport(String patientId) async {
    emit(const ReportGenerating());
    final result = await _repository.generateReport(patientId);
    result.fold(
      (failure) => emit(ReportsError(failure.message)),
      (_) => loadReports(patientId),
    );
  }
}
