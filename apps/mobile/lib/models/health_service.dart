/// نموذج الخدمات الصحية — Health Service
library;

class HealthService {
  final String id;
  final String title;
  final String description;
  final String category;
  final String providerName;
  final double price;
  final double? rating;
  final String? imageUrl;
  final bool isAvailable;

  const HealthService({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.providerName,
    required this.price,
    this.rating,
    this.imageUrl,
    this.isAvailable = true,
  });

  factory HealthService.fromJson(Map<String, dynamic> json) => HealthService(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        providerName: json['provider_name'] as String,
        price: (json['price'] as num).toDouble(),
        rating: (json['rating'] as num?)?.toDouble(),
        imageUrl: json['image_url'] as String?,
        isAvailable: json['is_available'] as bool? ?? true,
      );

  /// بيانات وهمية للتطوير
  static List<HealthService> mockList() => const [
        HealthService(
          id: 's-001',
          title: 'تمريض منزلي',
          description: 'ممرض/ة مؤهل لتقديم الرعاية المنزلية الشاملة',
          category: 'تمريض',
          providerName: 'مركز رعاية بلس',
          price: 350,
          rating: 4.8,
        ),
        HealthService(
          id: 's-002',
          title: 'علاج طبيعي منزلي',
          description: 'جلسات علاج طبيعي متخصصة في المنزل',
          category: 'علاج طبيعي',
          providerName: 'عيادة الحركة',
          price: 280,
          rating: 4.6,
        ),
        HealthService(
          id: 's-003',
          title: 'مرافقة كبار السن',
          description: 'مرافقة يومية لكبار السن مع متابعة صحية',
          category: 'مرافقة',
          providerName: 'شركة سند',
          price: 200,
          rating: 4.9,
        ),
        HealthService(
          id: 's-004',
          title: 'فحص منزلي شامل',
          description: 'فحوصات مخبرية شاملة في المنزل مع تقرير طبي',
          category: 'فحوصات',
          providerName: 'مختبرات الحياة',
          price: 450,
          rating: 4.7,
        ),
        HealthService(
          id: 's-005',
          title: 'استشارة طبية عن بُعد',
          description: 'استشارة مع طبيب متخصص عبر مكالمة فيديو',
          category: 'استشارات',
          providerName: 'طبيبك أونلاين',
          price: 150,
          rating: 4.5,
        ),
        HealthService(
          id: 's-006',
          title: 'توصيل أدوية',
          description: 'توصيل الأدوية من الصيدلية إلى المنزل',
          category: 'صيدلية',
          providerName: 'صيدلية الدواء',
          price: 25,
          rating: 4.3,
        ),
      ];

  static List<String> get categories => const [
        'الكل',
        'تمريض',
        'علاج طبيعي',
        'مرافقة',
        'فحوصات',
        'استشارات',
        'صيدلية'
      ];
}
