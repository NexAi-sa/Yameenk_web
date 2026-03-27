/// شاشة تسجيل القراءة اليومية للمسن — بسيطة جداً
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../features/patient/presentation/cubit/patient_cubit.dart';
import '../../features/patient/presentation/cubit/patient_state.dart';
import '../../features/readings/domain/usecases/record_reading_usecase.dart';
import '../../features/readings/presentation/cubit/readings_cubit.dart';
import '../../features/readings/presentation/cubit/readings_state.dart';
import '../../widgets/success_overlay.dart';

class RecordReadingScreen extends StatefulWidget {
  final String type;
  final String label;

  const RecordReadingScreen(
      {super.key, required this.type, required this.label});

  @override
  State<RecordReadingScreen> createState() => _RecordReadingScreenState();
}

class _RecordReadingScreenState extends State<RecordReadingScreen> {
  final _valueController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  String? _selectedContext;
  bool _showSuccess = false;

  bool get _isBP => widget.type == 'blood_pressure';

  @override
  void dispose() {
    _valueController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_isBP) {
      if (_systolicController.text.isEmpty ||
          _diastolicController.text.isEmpty) {
        return;
      }
    } else {
      if (_valueController.text.isEmpty) {
        return;
      }
    }

    final patientState = context.read<PatientCubit>().state;
    final patientId =
        patientState is PatientLoaded ? patientState.patient.id : '';

    context.read<ReadingsCubit>().record(RecordReadingParams(
          patientId: patientId,
          type: widget.type,
          value: _isBP ? null : double.tryParse(_valueController.text),
          systolic:
              _isBP ? int.tryParse(_systolicController.text) : null,
          diastolic:
              _isBP ? int.tryParse(_diastolicController.text) : null,
          readingContext: _selectedContext,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final contexts = [
      (label: l.reading_fasting, value: 'fasting'),
      (label: l.reading_afterMeal, value: 'after_meal'),
      (label: l.reading_beforeSleep, value: 'before_sleep'),
    ];

    return BlocListener<ReadingsCubit, ReadingsState>(
      listener: (context, state) {
        if (state is RecordReadingSuccess) {
          setState(() => _showSuccess = true);
        } else if (state is RecordReadingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.reading_errorSave, textAlign: TextAlign.right),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: BlocBuilder<ReadingsCubit, ReadingsState>(
        builder: (context, state) {
          final isSaving = state is RecordReadingLoading;

          return Stack(
            children: [
              Scaffold(
                appBar:
                    AppBar(title: Text(l.reading_record(widget.label))),
                body: ResponsiveCenter(
                  maxWidth: 600,
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.xxl),

                        // Icon
                        Icon(
                          _isBP
                              ? Icons.favorite_rounded
                              : Icons.water_drop_rounded,
                          size: 64,
                          color: AppColors.primary,
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Input(s)
                        if (_isBP) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _ReadingTextField(
                                  controller: _diastolicController,
                                  label: l.reading_lowerBP,
                                  hint: '80',
                                ),
                              ),
                              const Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 12),
                                child: Text('/',
                                    style: TextStyle(
                                        fontSize: 32,
                                        color: AppColors.textMuted)),
                              ),
                              Expanded(
                                child: _ReadingTextField(
                                  controller: _systolicController,
                                  label: l.reading_upperBP,
                                  hint: '120',
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          _ReadingTextField(
                            controller: _valueController,
                            label: l.reading_enterValue,
                            hint: '120',
                          ),
                        ],

                        const SizedBox(height: AppSpacing.xxl),

                        // Context chips
                        Text(l.reading_timing,
                            style: AppTextStyles.heading3,
                            textAlign: TextAlign.right),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.end,
                          children: contexts.map((c) {
                            final selected = _selectedContext == c.value;
                            return ChoiceChip(
                              label: Text(c.label),
                              selected: selected,
                              onSelected: (v) => setState(() =>
                                  _selectedContext = v ? c.value : null),
                              selectedColor: AppColors.primaryLight,
                              backgroundColor:
                                  AppColors.surfaceContainerLow,
                              labelStyle: TextStyle(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              side: BorderSide(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                              shape: const StadiumBorder(),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: AppSpacing.xxxl),

                        // Submit
                        ElevatedButton(
                          onPressed: isSaving ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(l.reading_submit,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Success overlay
              if (_showSuccess)
                SuccessOverlay(
                  onDismiss: () {
                    if (mounted) context.go('/family');
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ReadingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const _ReadingTextField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      style: AppTextStyles.stat.copyWith(fontSize: 40),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: AppColors.textMuted.withValues(alpha: 0.3)),
        labelText: label,
        alignLabelWithHint: true,
      ),
    );
  }
}
