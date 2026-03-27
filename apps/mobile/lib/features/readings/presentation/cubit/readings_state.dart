library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/reading_entity.dart';

abstract class ReadingsState extends Equatable {
  const ReadingsState();

  @override
  List<Object?> get props => [];
}

class ReadingsInitial extends ReadingsState {
  const ReadingsInitial();
}

class ReadingsLoading extends ReadingsState {
  const ReadingsLoading();
}

class ReadingsLoaded extends ReadingsState {
  final List<ReadingEntity> readings;
  final WeekSummaryEntity summary;

  const ReadingsLoaded({required this.readings, required this.summary});

  @override
  List<Object?> get props => [readings, summary];
}

class ReadingsError extends ReadingsState {
  final String message;
  const ReadingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Recording states
class RecordReadingLoading extends ReadingsState {
  const RecordReadingLoading();
}

class RecordReadingSuccess extends ReadingsState {
  const RecordReadingSuccess();
}

class RecordReadingError extends ReadingsState {
  final String message;
  const RecordReadingError(this.message);

  @override
  List<Object?> get props => [message];
}
