import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../features/medical_profile/domain/entities/medical_profile_entity.dart';
import '../../features/medical_profile/presentation/cubit/profile_setup_cubit.dart';
import '../../features/medical_profile/presentation/cubit/profile_setup_state.dart';

/// معالج إكمال الملف الطبي — 4 خطوات
class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        final stepTitles = [
          l.setup_step1,
          l.setup_step2,
          l.setup_step3,
          l.setup_step4,
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // 1. Transactional Header (Stitch Style)
                _buildHeader(context, state.currentStep,
                    stepTitles[state.currentStep]),

                // 2. Step Content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: [
                      _Step1BasicInfo(
                          key: const ValueKey(0),
                          profile: state.profile),
                      _Step2Diseases(
                          key: const ValueKey(1),
                          profile: state.profile),
                      _Step3Medications(
                          key: const ValueKey(2),
                          profile: state.profile),
                      _Step4EmergencyContacts(
                          key: const ValueKey(3),
                          profile: state.profile),
                    ][state.currentStep],
                  ),
                ),

                // 3. Action Footer
                _buildFooter(context, state, l),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context, int currentStep, String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon:
                    const Icon(Icons.arrow_forward, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading3
                        .copyWith(color: AppColors.primary),
                  ),
                  Text(
                    S.of(context).setup_stepOf(currentStep + 1, 4),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                S.of(context).appTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        // Progress Bar
        Container(
          width: double.infinity,
          height: 6,
          color: AppColors.surfaceContainerHigh,
          child: FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: (currentStep + 1) / 4,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, AppColors.primary],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
      BuildContext context, ProfileSetupState state, S l) {
    final cubit = context.read<ProfileSetupCubit>();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: const Border(
            top: BorderSide(
                color: AppColors.outlineVariant, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (state.currentStep > 0)
                TextButton(
                  onPressed: cubit.previousStep,
                  child: Text(l.setup_previous),
                )
              else
                const SizedBox.shrink(),
              Text(
                l.setup_progressSaved,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isSaving
                  ? null
                  : () {
                      if (state.currentStep < 3) {
                        cubit.nextStep();
                      } else {
                        cubit.submit().then((_) {
                          if (context.mounted) Navigator.pop(context);
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
              ),
              child: state.isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.currentStep == 0
                              ? l.setup_nextDiseases
                              : state.currentStep == 1
                                  ? l.setup_nextMeds
                                  : state.currentStep == 2
                                      ? l.setup_nextEmergency
                                      : l.setup_save,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_left),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Step 1 — Basic Info
// ══════════════════════════════════════════════
class _Step1BasicInfo extends StatefulWidget {
  final MedicalProfileEntity profile;
  const _Step1BasicInfo({super.key, required this.profile});

  @override
  State<_Step1BasicInfo> createState() => _Step1BasicInfoState();
}

class _Step1BasicInfoState extends State<_Step1BasicInfo> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _weightCtrl;
  String? _bloodType;

  @override
  void initState() {
    super.initState();
    _nameCtrl =
        TextEditingController(text: widget.profile.fullName);
    _ageCtrl = TextEditingController(
        text: widget.profile.age > 0 ? '${widget.profile.age}' : '');
    _heightCtrl = TextEditingController(
        text: widget.profile.height?.toStringAsFixed(0) ?? '');
    _weightCtrl = TextEditingController(
        text: widget.profile.weight?.toStringAsFixed(0) ?? '');
    _bloodType = widget.profile.bloodType;
  }

  void _save() {
    context.read<ProfileSetupCubit>().updateProfile(
          widget.profile.copyWith(
            fullName: _nameCtrl.text,
            age: int.tryParse(_ageCtrl.text) ?? 0,
            height: double.tryParse(_heightCtrl.text),
            weight: double.tryParse(_weightCtrl.text),
            bloodType: _bloodType,
          ),
        );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
      children: [
        // 1. Contextual Welcome Banner
        Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.tertiaryFixedDim.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                  color:
                      AppColors.tertiaryFixedDim.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.volunteer_activism,
                    color: AppColors.tertiary, size: 20),
                const SizedBox(width: 8),
                Text(
                  l.setup_welcomeCaregiver,
                  style: AppTextStyles.label.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        Text(
           l.setup_settingUpProfile,
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMd
              .copyWith(fontWeight: FontWeight.w900, height: 1.1),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
           l.setup_tailorExperience,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySecondary.copyWith(fontSize: 16),
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // 2. Full Name (Bento Card)
        _buildBentoCard(
          label: l.setup_fullName,
          icon: Icons.person_outline,
          child: TextField(
            controller: _nameCtrl,
            onChanged: (_) => _save(),
            style:
                AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: l.setup_enterFullName,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 3. Age & Gender
        Row(
          children: [
            Expanded(
              child: _buildBentoCard(
                label: l.setup_age,
                icon: Icons.cake_outlined,
                child: TextField(
                  controller: _ageCtrl,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _save(),
                  style: AppTextStyles.bodyLg
                      .copyWith(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: l.setup_ageInYears,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: _buildBentoCard(
                label: l.setup_gender,
                icon: Icons.wc_outlined,
                child: Row(
                  children: [
                    _buildGenderButton(l.setup_male, Icons.male),
                    const SizedBox(width: 8),
                    _buildGenderButton(l.setup_female, Icons.female),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // 4. Insight Chip
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.tertiaryFixedDim.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppColors.tertiaryFixedDim.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb,
                  color: AppColors.tertiary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.tertiary, height: 1.5),
                    children: [
                      TextSpan(
                          text: l.setup_whyMattersLabel,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              l.setup_whyBasicInfo),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xxxl),
      ],
    );
  }

  Widget _buildBentoCard(
      {required String label,
      required IconData icon,
      required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
          const Divider(height: 1, color: AppColors.outlineVariant),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String label, IconData icon) {
    final isSelected = widget.profile.gender == label;
    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<ProfileSetupCubit>().updateProfile(
                widget.profile.copyWith(gender: label),
              );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryFixed
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.outlineVariant,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Step 2 — Diseases & Allergies
// ══════════════════════════════════════════════
class _Step2Diseases extends StatefulWidget {
  final MedicalProfileEntity profile;
  const _Step2Diseases({super.key, required this.profile});

  @override
  State<_Step2Diseases> createState() => _Step2DiseasesState();
}

class _Step2DiseasesState extends State<_Step2Diseases> {
  late List<DiseaseEntity> _diseases;
  late List<AllergyEntity> _allergies;
  final _diseaseCtrl = TextEditingController();
  final _allergyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _diseases = List.from(widget.profile.diseases);
    _allergies = List.from(widget.profile.allergies);
  }

  void _save() {
    context.read<ProfileSetupCubit>().updateProfile(
          widget.profile
              .copyWith(diseases: _diseases, allergies: _allergies),
        );
  }

  @override
  void dispose() {
    _diseaseCtrl.dispose();
    _allergyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    final List<String> commonDiseases = [
      l.setup_disease_diabetes1,
      l.setup_disease_diabetes2,
      l.setup_disease_hypertension,
      l.setup_disease_heart,
      l.setup_disease_asthma,
      l.setup_disease_kidney,
      l.setup_disease_osteoporosis,
      l.setup_disease_alzheimers,
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
      children: [
        // 1. Chronic Diseases Bento Grid
        _buildSectionCard(
          title: l.setup_chronicDiseases,
          subtitle: l.setup_selectOrAdd,
          icon: Icons.monitor_heart_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: commonDiseases.map((d) {
                  final selected =
                      _diseases.any((e) => e.name == d);
                  return FilterChip(
                    label: Text(d),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _diseases.add(DiseaseEntity(name: d));
                        } else {
                          _diseases.removeWhere((e) => e.name == d);
                        }
                      });
                      _save();
                    },
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected
                          ? Colors.white
                          : AppColors.onSurface,
                      fontSize: 12,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: AppColors.surfaceContainerHigh,
                    side: BorderSide.none,
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _diseaseCtrl,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        hintText: l.setup_otherDisease,
                        filled: true,
                        fillColor: AppColors.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: () {
                      if (_diseaseCtrl.text.isNotEmpty) {
                        setState(() => _diseases.add(
                            DiseaseEntity(name: _diseaseCtrl.text)));
                        _diseaseCtrl.clear();
                        _save();
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // 2. Allergies Bento Input
        _buildSectionCard(
          title: l.profile_allergies,
          subtitle: l.setup_addAllergy,
          icon: Icons.warning_amber_outlined,
          child: Column(
            children: [
              TextField(
                controller: _allergyCtrl,
                maxLines: 3,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: l.setup_allergyHint,
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              if (_allergies.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: _allergies
                      .map((a) => Chip(
                            label: Text(a.name,
                                style:
                                    const TextStyle(fontSize: 12)),
                            onDeleted: () {
                              setState(
                                  () => _allergies.remove(a));
                              _save();
                            },
                            deleteIcon:
                                const Icon(Icons.close, size: 14),
                          ))
                      .toList(),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (_allergyCtrl.text.isNotEmpty) {
                      setState(() => _allergies.add(
                          AllergyEntity(name: _allergyCtrl.text)));
                      _allergyCtrl.clear();
                      _save();
                    }
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l.setup_addAllergyBtn),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // 3. Security Insight Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.security,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Why this matters?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.setup_whyMedHistory,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.heading3
                          .copyWith(fontSize: 18)),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Step 3 — Medications & Dosages
// ══════════════════════════════════════════════
class _Step3Medications extends StatefulWidget {
  final MedicalProfileEntity profile;
  const _Step3Medications({super.key, required this.profile});

  @override
  State<_Step3Medications> createState() => _Step3MedicationsState();
}

class _Step3MedicationsState extends State<_Step3Medications> {
  late List<MedicationEntity> _medications;
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _medications = List.from(widget.profile.medications);
  }

  void _save() {
    context.read<ProfileSetupCubit>().updateProfile(
          widget.profile.copyWith(medications: _medications),
        );
  }

  void _addMedication() {
    if (_nameCtrl.text.isNotEmpty && _dosageCtrl.text.isNotEmpty) {
      setState(() {
        _medications.add(MedicationEntity(
          name: _nameCtrl.text,
          dosage: _dosageCtrl.text,
          frequency: '',
        ));
      });
      _nameCtrl.clear();
      _dosageCtrl.clear();
      _save();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Manual Entry Column
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  _buildSectionCard(
                    title: l.setup_currentMeds,
                    subtitle: l.setup_addAllMeds,
                    icon: Icons.medication_outlined,
                    child: Column(
                      children: [
                        if (_medications.isNotEmpty) ...[
                          ..._medications.map((m) => Container(
                                margin: const EdgeInsets.only(
                                    bottom: AppSpacing.sm),
                                padding:
                                    const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.surfaceContainerLowest,
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                        Icons.check_circle_outline,
                                        color: AppColors.primary,
                                        size: 20),
                                    const SizedBox(
                                        width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        '${m.name} (${m.dosage})',
                                        style: AppTextStyles.body
                                            .copyWith(
                                                fontWeight:
                                                    FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          size: 18),
                                      onPressed: () {
                                        setState(() =>
                                            _medications.remove(m));
                                        _save();
                                      },
                                    ),
                                  ],
                                ),
                              )),
                          const Divider(height: 32),
                        ],
                        TextField(
                          controller: _nameCtrl,
                          style: AppTextStyles.body,
                          decoration: InputDecoration(
                            hintText: l.setup_medName,
                            labelText: l.setup_medNameLabel,
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _dosageCtrl,
                          style: AppTextStyles.body,
                          decoration: InputDecoration(
                            hintText: l.setup_doseHint,
                            labelText: l.setup_doseLabel,
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _addMedication,
                            icon: const Icon(Icons.add),
                            label: Text(l.setup_addMedBtn),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                              side: const BorderSide(
                                  color: AppColors.outlineVariant,
                                  style: BorderStyle.solid),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixedDim
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.tertiary
                              .withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: AppColors.tertiary, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(l.setup_aiTip,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.tertiary)),
                              const SizedBox(height: 4),
                              Text(
                                l.setup_aiTipDetail,
                                style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: AppColors.tertiary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            // 2. Photo Upload Column
            Expanded(
              flex: 5,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [AppDesign.ambientShadow],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.photo_camera,
                                  color: Colors.white, size: 32),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text(
                              'Upload Prescription',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Our AI will extract medicine names, dosages, and schedules.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        AppColors.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                S.of(context).setup_featureComingSoon,
                                textAlign: TextAlign.right,
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        icon: const Icon(Icons.upload_file),
                        label: Text(l.setup_browseFiles),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size(double.infinity, 54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxxl),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.heading3
                          .copyWith(fontSize: 18)),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Step 4 — Emergency Contacts
// ══════════════════════════════════════════════
class _Step4EmergencyContacts extends StatefulWidget {
  final MedicalProfileEntity profile;
  const _Step4EmergencyContacts(
      {super.key, required this.profile});

  @override
  State<_Step4EmergencyContacts> createState() =>
      _Step4EmergencyContactsState();
}

class _Step4EmergencyContactsState
    extends State<_Step4EmergencyContacts> {
  late List<EmergencyContactEntity> _contacts;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  late String _relationKey;

  @override
  void initState() {
    super.initState();
    _contacts = List.from(widget.profile.emergencyContacts);
    _relationKey = 'child';
  }

  void _save() {
    context.read<ProfileSetupCubit>().updateProfile(
          widget.profile.copyWith(emergencyContacts: _contacts),
        );
  }

  String _getRelLabel(S l, String key) {
    return switch (key) {
      'child' => l.setup_rel_child,
      'spouse' => l.setup_rel_spouse,
      'sibling' => l.setup_rel_sibling,
      'parent' => l.setup_rel_parent,
      'otherRelative' => l.setup_rel_otherRelative,
      'friend' => l.setup_rel_friend,
      _ => l.setup_rel_child,
    };
  }

  void _addContact() {
    if (_nameCtrl.text.isNotEmpty && _phoneCtrl.text.isNotEmpty) {
      final l = S.of(context);
      final relLabel = _getRelLabel(l, _relationKey);
      setState(() {
        _contacts.add(EmergencyContactEntity(
          name: _nameCtrl.text,
          phone: _phoneCtrl.text,
          relation: relLabel,
        ));
      });
      _nameCtrl.clear();
      _phoneCtrl.clear();
      _save();
      _showWhatsAppAlert(context);
    }
  }

  void _showWhatsAppAlert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).setup_whatsappAlert),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  void _updateNotifications({
    bool? dailyFollowUp,
    bool? emergencyOnly,
    bool? weeklyReport,
    bool? vitalSignsReminder,
  }) {
    final prefs =
        widget.profile.notificationPreferences.copyWith(
      dailyFollowUp: dailyFollowUp,
      emergencyOnly: emergencyOnly,
      weeklyReport: weeklyReport,
      vitalSignsReminder: vitalSignsReminder,
    );
    context.read<ProfileSetupCubit>().updateProfile(
          widget.profile
              .copyWith(notificationPreferences: prefs),
        );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    final relations = [
      (key: 'child', label: l.setup_rel_child),
      (key: 'spouse', label: l.setup_rel_spouse),
      (key: 'sibling', label: l.setup_rel_sibling),
      (key: 'parent', label: l.setup_rel_parent),
      (key: 'otherRelative', label: l.setup_rel_otherRelative),
      (key: 'friend', label: l.setup_rel_friend),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Contact Form Column
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  _buildSectionCard(
                    title: l.setup_emergencyTitle,
                    subtitle: l.setup_emergencyDetail,
                    icon: Icons.person_add_outlined,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        if (_contacts.isNotEmpty) ...[
                          ..._contacts.asMap().entries.map((entry) {
                            final c = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(
                                  bottom: AppSpacing.sm),
                              padding:
                                  const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.surfaceContainerLowest,
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: AppColors
                                        .secondary
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      c.name.isNotEmpty
                                          ? c.name[0]
                                          : '?',
                                      style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontWeight:
                                              FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                      width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(c.name,
                                            style: AppTextStyles.body
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight
                                                            .bold)),
                                        Text(
                                            '${c.relation} — ${c.phone}',
                                            style:
                                                AppTextStyles.caption),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        size: 18),
                                    onPressed: () {
                                      setState(() => _contacts
                                          .removeAt(entry.key));
                                      _save();
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                          const Divider(height: 32),
                        ],
                        TextField(
                          controller: _nameCtrl,
                          style: AppTextStyles.body,
                          decoration: InputDecoration(
                            hintText: l.setup_contactName,
                            labelText: l.setup_contactNameLabel,
                            filled: true,
                            fillColor:
                                AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child:
                                  DropdownButtonFormField<String>(
                                initialValue: _relationKey,
                                style: AppTextStyles.body,
                                decoration: InputDecoration(
                                   labelText: l.setup_relationLabel,
                                  filled: true,
                                  fillColor: AppColors
                                      .surfaceContainerLowest,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide.none),
                                ),
                                items: relations
                                    .map((r) => DropdownMenuItem(
                                        value: r.key,
                                        child: Text(r.label)))
                                    .toList(),
                                onChanged: (v) => setState(
                                    () => _relationKey = v!),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextField(
                                controller: _phoneCtrl,
                                style: AppTextStyles.body,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: l.setup_contactPhone,
                                   labelText: l.setup_phoneLabel,
                                  suffixIcon: const Icon(Icons.call,
                                      size: 18),
                                  filled: true,
                                  fillColor: AppColors
                                      .surfaceContainerLowest,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _addContact,
                            icon: const Icon(
                                Icons.add_circle_outline),
                            label: Text(
                                l.setup_addAnotherContact),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                              side: const BorderSide(
                                  color: AppColors.outlineVariant,
                                  style: BorderStyle.solid),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            // 2. Notifications & Vitals Column
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  _buildSectionCard(
                    title: l.setup_notificationOptions,
                    subtitle: l.setup_optionalSettings,
                    icon: Icons.notifications_active_outlined,
                    child: Column(
                      children: [
                        _buildNotificationTile(
                          l.setup_dailyFollowUp,
                          widget.profile.notificationPreferences
                              .dailyFollowUp,
                          (v) => _updateNotifications(
                              dailyFollowUp: v),
                        ),
                        _buildNotificationTile(
                          l.setup_emergencyOnly,
                          widget.profile.notificationPreferences
                              .emergencyOnly,
                          (v) => _updateNotifications(
                              emergencyOnly: v),
                        ),
                        _buildNotificationTile(
                          l.setup_weeklyReport,
                          widget.profile.notificationPreferences
                              .weeklyReport,
                          (v) => _updateNotifications(
                              weeklyReport: v),
                        ),
                        _buildNotificationTile(
                          l.setup_vitalsAlert,
                          widget.profile.notificationPreferences
                              .vitalSignsReminder,
                          (v) => _updateNotifications(
                              vitalSignsReminder: v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [AppDesign.ambientShadow],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryFixedDim,
                            borderRadius:
                                BorderRadius.circular(100),
                          ),
                          child: Text(l.setup_dailyCareFeature,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5)),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(l.setup_vitalsLogging,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Text(
                          l.setup_vitalsLoggingDetail,
                          style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildVitalsMockup(
                            Icons.water_drop,
                            AppColors.tertiary,
                            0.7),
                        const SizedBox(height: AppSpacing.sm),
                        _buildVitalsMockup(
                            Icons.monitor_heart,
                            AppColors.secondary,
                            0.5),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.outlineVariant
                              .withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.verified_user,
                            color: AppColors.secondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(l.setup_dataPrivacy,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(
                                l.setup_dataPrivacyDetail,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.outline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxxl),
      ],
    );
  }

  Widget _buildVitalsMockup(
      IconData icon, Color color, double percent) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(100),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
      String label, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(label,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500)),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: AppColors.primary,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon,
                    color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.heading3
                          .copyWith(fontSize: 18)),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}
