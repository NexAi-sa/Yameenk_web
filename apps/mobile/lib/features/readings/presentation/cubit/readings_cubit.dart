library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/reading_entity.dart';
import '../../domain/usecases/get_readings_usecase.dart';
import '../../domain/usecases/record_reading_usecase.dart';
import 'readings_state.dart';

class ReadingsCubit extends Cubit<ReadingsState> {
  final GetReadingsUseCase _getReadings;
  final RecordReadingUseCase _recordReading;

  ReadingsCubit({
    required GetReadingsUseCase getReadings,
    required RecordReadingUseCase recordReading,
  })  : _getReadings = getReadings,
        _recordReading = recordReading,
        super(const ReadingsInitial());

  Future<void> loadReadings(String patientId, {int days = 7}) async {
    emit(const ReadingsLoading());

    final result = await _getReadings(
        GetReadingsParams(patientId: patientId, days: days));

    result.fold(
      (failure) => emit(ReadingsError(failure.message)),
      (readings) {
        final normal = readings.where((r) => r.isNormal).length;
        emit(ReadingsLoaded(
          readings: readings,
          summary: WeekSummaryEntity(
            total: readings.length,
            normal: normal,
            alerts: readings.length - normal,
          ),
        ));
      },
    );
  }

  Future<void> record(RecordReadingParams params) async {
    emit(const RecordReadingLoading());

    final result = await _recordReading(params);

    result.fold(
      (failure) => emit(RecordReadingError(failure.message)),
      (_) => emit(const RecordReadingSuccess()),
    );
  }
}
