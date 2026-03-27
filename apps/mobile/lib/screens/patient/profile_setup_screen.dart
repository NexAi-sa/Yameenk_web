import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/medical_profile.dart';
import '../../providers/medical_profile_provider.dart';

/// معالج إكمال الملف الطبي — 4 خطوات
class ProfileSetupScreen extends ConsumerWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileSetupProvider);
    final notifier = ref.read(profileSetupProvider.notifier);
    final l = S.of(context);

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
            _buildHeader(context, state.currentStep, stepTitles[state.currentStep]),

            // 2. Step Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: [
                  _Step1BasicInfo(
                      key: const ValueKey(0), profile: state.profile),
                  _Step2Diseases(
                      key: const ValueKey(1), profile: state.profile),
                  _Step3Medications(
                      key: const ValueKey(2), profile: state.profile),
                  _Step4EmergencyContacts(
                      key: const ValueKey(3), profile: state.profile),
                ][state.currentStep],
              ),
            ),

            // 3. Action Footer
            _buildFooter(context, state, notifier, l),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int currentStep, String title) {
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
                icon: const Icon(Icons.arrow_forward, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
                  ),
                  Text(
                    'Step ${currentStep + 1} of 4',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'Yameenak',
                style: TextStyle(
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

  Widget _buildFooter(BuildContext context, dynamic state, dynamic notifier, dynamic l) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: const Border(top: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (state.currentStep > 0)
                TextButton(
                  onPressed: notifier.previousStep,
                  child: Text(l.setup_previous),
                )
              else
                const SizedBox.shrink(),
              const Text(
                'Progress saved automatically',
                style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isSaving ? null : () {
                if (state.currentStep < 3) {
                  notifier.nextStep();
                } else {
                  notifier.submit().then((_) {
                    if (context.mounted) Navigator.pop(context);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
              child: state.isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.currentStep == 0 ? 'Next Step: Chronic Diseases' :
                          state.currentStep == 1 ? 'Next Step: Medications' :
                          state.currentStep == 2 ? 'Next Step: Emergency Contacts' :
                          l.setup_save,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
class _Step1BasicInfo extends ConsumerStatefulWidget {
  final MedicalProfile profile;
  const _Step1BasicInfo({super.key, required this.profile});

  @override
  ConsumerState<_Step1BasicInfo> createState() => _Step1BasicInfoState();
}

class _Step1BasicInfoState extends ConsumerState<_Step1BasicInfo> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _weightCtrl;
  String? _bloodType;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.fullName);
    _ageCtrl = TextEditingController(
        text: widget.profile.age > 0 ? '${widget.profile.age}' : '');
    _heightCtrl = TextEditingController(
        text: widget.profile.height?.toStringAsFixed(0) ?? '');
    _weightCtrl = TextEditingController(
        text: widget.profile.weight?.toStringAsFixed(0) ?? '');
    _bloodType = widget.profile.bloodType;
  }

  void _save() {
    ref.read(profileSetupProvider.notifier).updateProfile(
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
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
      children: [
        // 1. Contextual Welcome Banner
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.tertiaryFixedDim.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.tertiaryFixedDim.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.volunteer_activism, color: AppColors.tertiary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Welcome, Caregiver',
                  style: AppTextStyles.label.copyWith(color: AppColors.tertiary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        Text(
          'You are setting up the\nprofile for your loved one.',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.w900, height: 1.1),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'This information helps us tailor the medical sanctuary experience to their specific biological and health needs.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySecondary.copyWith(fontSize: 16),
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // 2. Full Name (Bento Card)
        _buildBentoCard(
          label: 'Full Name',
          icon: Icons.person_outline,
          child: TextField(
            controller: _nameCtrl,
            onChanged: (_) => _save(),
            style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: 'Enter full legal name',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 3. Age & Gender (Responsive Grid/Row)
        Row(
          children: [
            Expanded(
              child: _buildBentoCard(
                label: 'Age',
                icon: Icons.cake_outlined,
                child: TextField(
                  controller: _ageCtrl,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _save(),
                  style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: 'Age in years',
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
                label: 'Gender',
                icon: Icons.wc_outlined,
                child: Row(
                  children: [
                    _buildGenderButton('Male', Icons.male),
                    const SizedBox(width: 8),
                    _buildGenderButton('Female', Icons.female),
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
            border: Border.all(color: AppColors.tertiaryFixedDim.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb, color: AppColors.tertiary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(color: AppColors.tertiary, height: 1.5),
                    children: const [
                      TextSpan(text: 'Why this matters: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'Providing accurate basic info allows our AI system to calculate the correct dosage levels and health risk factors based on demographic standards.'),
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

  Widget _buildBentoCard({required String label, required IconData icon, required Widget child}) {
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
                style: AppTextStyles.label.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
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
          ref.read(profileSetupProvider.notifier).updateProfile(
            widget.profile.copyWith(gender: label),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryFixed : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.outlineVariant,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
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
class _Step2Diseases extends ConsumerStatefulWidget {
  final MedicalProfile profile;
  const _Step2Diseases({super.key, required this.profile});

  @override
  ConsumerState<_Step2Diseases> createState() => _Step2DiseasesState();
}

class _Step2DiseasesState extends ConsumerState<_Step2Diseases> {
  late List<Disease> _diseases;
  late List<Allergy> _allergies;
  final _diseaseCtrl = TextEditingController();
  final _allergyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _diseases = List.from(widget.profile.diseases);
    _allergies = List.from(widget.profile.allergies);
  }

  void _save() {
    ref.read(profileSetupProvider.notifier).updateProfile(
          widget.profile.copyWith(diseases: _diseases, allergies: _allergies),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
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
                  final selected = _diseases.any((e) => e.name == d);
                  return FilterChip(
                    label: Text(d),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _diseases.add(Disease(name: d));
                        } else {
                          _diseases.removeWhere((e) => e.name == d);
                        }
                      });
                      _save();
                    },
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.onSurface,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: () {
                      if (_diseaseCtrl.text.isNotEmpty) {
                        setState(() => _diseases.add(Disease(name: _diseaseCtrl.text)));
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
                  hintText: 'e.g., Penicillin, Peanuts, Latex...',
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (_) {
                  // Simplified for Step 2 design
                },
              ),
              if (_allergies.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: _allergies.map((a) => Chip(
                    label: Text(a.name, style: const TextStyle(fontSize: 12)),
                    onDeleted: () {
                      setState(() => _allergies.remove(a));
                      _save();
                    },
                    deleteIcon: const Icon(Icons.close, size: 14),
                  )).toList(),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (_allergyCtrl.text.isNotEmpty) {
                      setState(() => _allergies.add(Allergy(name: _allergyCtrl.text)));
                      _allergyCtrl.clear();
                      _save();
                    }
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Allergy'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // 3. Security / Insight Gradient Card
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
                child: const Icon(Icons.security, color: Colors.white, size: 24),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Why this matters?',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your medical history helps our AI-powered care system prevent drug interactions and tailor your nutrition plan specifically to your needs.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, height: 1.5),
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
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 18)),
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
class _Step3Medications extends ConsumerStatefulWidget {
  final MedicalProfile profile;
  const _Step3Medications({super.key, required this.profile});

  @override
  ConsumerState<_Step3Medications> createState() => _Step3MedicationsState();
}

class _Step3MedicationsState extends ConsumerState<_Step3Medications> {
  late List<Medication> _medications;
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _medications = List.from(widget.profile.medications);
  }

  void _save() {
    ref.read(profileSetupProvider.notifier).updateProfile(
          widget.profile.copyWith(medications: _medications),
        );
  }

  void _addMedication() {
    if (_nameCtrl.text.isNotEmpty && _dosageCtrl.text.isNotEmpty) {
      setState(() {
        _medications.add(Medication(
          name: _nameCtrl.text,
          dosage: _dosageCtrl.text,
          frequency: '', // Combined in dosage field in new UI
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
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
                            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    '${m.name} (${m.dosage} - ${m.frequency})',
                                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    setState(() => _medications.remove(m));
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
                            labelText: 'Medication Name',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _dosageCtrl,
                          style: AppTextStyles.body,
                          decoration: InputDecoration(
                            hintText: 'e.g., 500mg, twice daily',
                            labelText: 'Dose & Frequency',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _addMedication,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Medication'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: AppColors.outlineVariant, style: BorderStyle.solid),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // AI Assistant Tip
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixedDim.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.1)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome, color: AppColors.tertiary, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AI Assistant Tip', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                              SizedBox(height: 4),
                              Text(
                                'Accuracy is vital. If you\'re unsure about the dosage, use the photo upload feature to let our clinical AI verify the details for you.',
                                style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.tertiary),
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
                height: 400, // Fixed height for bento feel
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
                          border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.none),
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
                              child: const Icon(Icons.photo_camera, color: Colors.white, size: 32),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            const Text(
                              'Upload Prescription',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Our AI will extract medicine names, dosages, and schedules.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: ElevatedButton.icon(
                        onPressed: () {}, // File picker logic
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Browse Files'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 54),
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
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 18)),
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
class _Step4EmergencyContacts extends ConsumerStatefulWidget {
  final MedicalProfile profile;
  const _Step4EmergencyContacts({super.key, required this.profile});

  @override
  ConsumerState<_Step4EmergencyContacts> createState() =>
      _Step4EmergencyContactsState();
}

class _Step4EmergencyContactsState
    extends ConsumerState<_Step4EmergencyContacts> {
  late List<EmergencyContact> _contacts;
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
    ref.read(profileSetupProvider.notifier).updateProfile(
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
        _contacts.add(EmergencyContact(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    final prefs = widget.profile.notificationPreferences.copyWith(
      dailyFollowUp: dailyFollowUp,
      emergencyOnly: emergencyOnly,
      weeklyReport: weeklyReport,
      vitalSignsReminder: vitalSignsReminder,
    );
    ref.read(profileSetupProvider.notifier).updateProfile(
          widget.profile.copyWith(notificationPreferences: prefs),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_contacts.isNotEmpty) ...[
                          ..._contacts.asMap().entries.map((entry) {
                            final c = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                                    child: Text(c.name.isNotEmpty ? c.name[0] : '?', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                                        Text('${c.relation} — ${c.phone}', style: AppTextStyles.caption),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () {
                                      setState(() => _contacts.removeAt(entry.key));
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
                            labelText: 'Contact Name',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _relationKey,
                                style: AppTextStyles.body,
                                decoration: InputDecoration(
                                  labelText: 'Relationship',
                                  filled: true,
                                  fillColor: AppColors.surfaceContainerLowest,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                ),
                                items: relations
                                    .map((r) => DropdownMenuItem(value: r.key, child: Text(r.label)))
                                    .toList(),
                                onChanged: (v) => setState(() => _relationKey = v!),
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
                                  labelText: 'Phone Number',
                                  suffixIcon: const Icon(Icons.call, size: 18),
                                  filled: true,
                                  fillColor: AppColors.surfaceContainerLowest,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Add Another Contact'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: AppColors.outlineVariant, style: BorderStyle.solid),
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
                  // Notification Options Checklist
                  _buildSectionCard(
                    title: l.setup_notificationOptions,
                    subtitle: 'Optional settings',
                    icon: Icons.notifications_active_outlined,
                    child: Column(
                      children: [
                        _buildNotificationTile(
                          l.setup_dailyFollowUp,
                          widget.profile.notificationPreferences.dailyFollowUp,
                          (v) => _updateNotifications(dailyFollowUp: v),
                        ),
                        _buildNotificationTile(
                          l.setup_emergencyOnly,
                          widget.profile.notificationPreferences.emergencyOnly,
                          (v) => _updateNotifications(emergencyOnly: v),
                        ),
                        _buildNotificationTile(
                          l.setup_weeklyReport,
                          widget.profile.notificationPreferences.weeklyReport,
                          (v) => _updateNotifications(weeklyReport: v),
                        ),
                        _buildNotificationTile(
                          l.setup_vitalsAlert,
                          widget.profile.notificationPreferences.vitalSignsReminder,
                          (v) => _updateNotifications(vitalSignsReminder: v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Vitals Teaser Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [AppDesign.ambientShadow],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryFixedDim,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Text('DAILY CARE FEATURE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Text('Vitals Logging', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        const Text(
                          'Once your profile is active, we\'ll help you log critical readings like Blood Sugar and Blood Pressure every day.',
                          style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Vitals Visual Mockup
                        _buildVitalsMockup(Icons.water_drop, AppColors.tertiary, 0.7),
                        const SizedBox(height: AppSpacing.sm),
                        _buildVitalsMockup(Icons.monitor_heart, AppColors.secondary, 0.5),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Trust Message
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.verified_user, color: AppColors.secondary, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Data Privacy & Security', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              SizedBox(height: 2),
                              Text(
                                'Your medical data is encrypted and shared only with your authorized medical team and family members.',
                                style: TextStyle(fontSize: 11, color: AppColors.outline),
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

  Widget _buildVitalsMockup(IconData icon, Color color, double percent) {
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

  Widget _buildNotificationTile(String label, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
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
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 18)),
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
