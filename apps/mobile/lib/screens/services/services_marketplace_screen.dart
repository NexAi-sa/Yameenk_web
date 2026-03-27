/// سوق الخدمات الصحية — Services Marketplace
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';
import '../../core/responsive_utils.dart';
import '../../core/responsive_scaffold.dart';
import '../../main.dart';
import '../../models/health_service.dart';
import '../../widgets/plus_gate.dart';

class ServicesMarketplaceScreen extends ConsumerStatefulWidget {
  const ServicesMarketplaceScreen({super.key});

  @override
  ConsumerState<ServicesMarketplaceScreen> createState() =>
      _ServicesMarketplaceScreenState();
}

class _ServicesMarketplaceScreenState
    extends ConsumerState<ServicesMarketplaceScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    // Categories localized
    final categories = [
      (key: 'all', label: l.services_catAll),
      (key: 'تمريض', label: l.services_catNursing),
      (key: 'علاج طبيعي', label: l.services_catPhysio),
      (key: 'مرافقة', label: l.services_catCompanion),
      (key: 'فحوصات', label: l.services_catTests),
      (key: 'استشارات', label: l.services_catConsult),
      (key: 'صيدلية', label: l.services_catPharmacy),
    ];

    final allServices = HealthService.mockList();
    final filtered = allServices.where((s) {
      final matchCategory =
          _selectedCategory == 'all' || s.category == _selectedCategory;
      final matchSearch =
          _searchQuery.isEmpty || s.title.contains(_searchQuery);
      return matchCategory && matchSearch;
    }).toList();

    return PlusGate(
      featureName: l.services_title,
      child: Scaffold(
        appBar: AppBar(title: Text(l.services_title)),
        body: ResponsiveCenter(
          maxWidth: 900,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: TextField(
                  textAlign: TextAlign.right,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: l.services_searchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    isDense: true,
                  ),
                ),
              ),

              // Category chips
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    final selected = _selectedCategory == cat.key;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(cat.label),
                        selected: selected,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat.key),
                        selectedColor: AppColors.primaryLight,
                        backgroundColor: AppColors.surfaceContainerLow,
                        labelStyle: TextStyle(
                          color: selected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: const StadiumBorder(),
                        side: BorderSide.none,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Services grid
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(l.services_noServices,
                            style: AppTextStyles.bodySecondary),
                      )
                    : GridView.builder(
                        padding: AppSpacing.screenPadding,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: context.responsiveGridCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) =>
                            _ServiceCard(service: filtered[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final HealthService service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDesign.cardRadius),
        onTap: () {
          // TODO: navigate to service details
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(service.category,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.primary)),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(service.title, style: AppTextStyles.heading3),
              const SizedBox(height: 4),
              Text(service.description,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const Spacer(),
              Row(
                children: [
                  if (service.rating != null) ...[
                    const Icon(Icons.star_rounded,
                        size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(service.rating!.toStringAsFixed(1),
                        style: AppTextStyles.caption),
                    const Spacer(),
                  ],
                  Text(
                    '${service.price.toInt()} ${l.common_sar}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
