/// شاشة تسجيل القراءة اليومية للمسن — بسيطة جداً
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/success_overlay.dart';

class RecordReadingScreen extends ConsumerStatefulWidget {
  final String type;
  final String label;

  const RecordReadingScreen(
      {super.key, required this.type, required this.label});

  @override
  ConsumerState<RecordReadingScreen> createState() =>
      _RecordReadingScreenState();
}

class _RecordReadingScreenState extends ConsumerState<RecordReadingScreen> {
  final _valueController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  String? _selectedContext;
  bool _saving = false;
  bool _showSuccess = false;

  bool get _isBP => widget.type == 'blood_pressure';

  @override
  void dispose() {
    _valueController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isBP) {
      if (_systolicController.text.isEmpty || _diastolicController.text.isEmpty) return;
    } else {
      if (_valueController.text.isEmpty) return;
    }

    setState(() => _saving = true);
    try {
      final api = ref.read(apiServiceProvider);
      final patientId = ref.read(authProvider).patientId;

      if (_isBP) {
        await api.recordReading(
          patientId: patientId,
          type: widget.type,
          systolic: int.parse(_systolicController.text),
          diastolic: int.parse(_diastolicController.text),
          context: _selectedContext,
        );
      } else {
        await api.recordReading(
          patientId: patientId,
          type: widget.type,
          value: double.parse(_valueController.text),
          context: _selectedContext,
        );
      }

      if (mounted) {
        setState(() {
          _saving = false;
          _showSuccess = true;
        });
      }
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(context.l10n.reading_errorSave, textAlign: TextAlign.right),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final contexts = [
      (label: l.reading_fasting, value: 'fasting'),
      (label: l.reading_afterMeal, value: 'after_meal'),
      (label: l.reading_beforeSleep, value: 'before_sleep'),
    ];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(l.reading_record(widget.label))),
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
                    _isBP ? Icons.favorite_rounded : Icons.water_drop_rounded,
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
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('/',
                              style: TextStyle(
                                  fontSize: 32, color: AppColors.textMuted)),
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
                        onSelected: (v) =>
                            setState(() => _selectedContext = v ? c.value : null),
                        selectedColor: AppColors.primaryLight,
                        backgroundColor: AppColors.surfaceContainerLow,
                        labelStyle: TextStyle(
                          color: selected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
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
                    onPressed: _saving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _saving
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
                                fontSize: 16, fontWeight: FontWeight.bold)),
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
        hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.3)),
        labelText: label,
        alignLabelWithHint: true,
      ),
    );
  }
}
