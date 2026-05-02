class TempleModel {
  final String id;
  final String name;
  final String? description;
  final String address;
  final String city;
  final String state;
  final double? locationLat;
  final double? locationLng;
  final String? imageUrl;
  final double rating;
  final int totalReviews;
  final bool isVerified;
  final String? adminUserId;
  final String? phone;
  final String? openingTime;
  final String? closingTime;

  const TempleModel({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.city,
    required this.state,
    this.locationLat,
    this.locationLng,
    this.imageUrl,
    required this.rating,
    required this.totalReviews,
    required this.isVerified,
    this.adminUserId,
    this.phone,
    this.openingTime,
    this.closingTime,
  });

  factory TempleModel.fromMap(Map<String, dynamic> map) {
    return TempleModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      description: map['description'] as String?,
      address: map['address'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      locationLat: (map['location_lat'] as num?)?.toDouble(),
      locationLng: (map['location_lng'] as num?)?.toDouble(),
      imageUrl: map['image_url'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (map['total_reviews'] as num?)?.toInt() ?? 0,
      isVerified: map['is_verified'] as bool? ?? false,
      adminUserId: map['admin_user_id'] as String?,
      phone: map['phone'] as String?,
      openingTime: map['opening_time'] as String?,
      closingTime: map['closing_time'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'address': address,
        'city': city,
        'state': state,
        'location_lat': locationLat,
        'location_lng': locationLng,
        'image_url': imageUrl,
        'rating': rating,
        'total_reviews': totalReviews,
        'is_verified': isVerified,
        'admin_user_id': adminUserId,
        'phone': phone,
        'opening_time': openingTime,
        'closing_time': closingTime,
      };
}

class PoojaModel {
  final String id;
  final String? templeId;
  final String nameEn;
  final String? nameTe;
  final String? nameHi;
  final int durationMins;
  final int basePrice;
  final String? description;
  final String? imageUrl;
  final String category; // temple | home | both
  final List<String> requirements;

  const PoojaModel({
    required this.id,
    this.templeId,
    required this.nameEn,
    this.nameTe,
    this.nameHi,
    required this.durationMins,
    required this.basePrice,
    this.description,
    this.imageUrl,
    required this.category,
    required this.requirements,
  });

  factory PoojaModel.fromMap(Map<String, dynamic> map) {
    return PoojaModel(
      id: map['id'] as String,
      templeId: map['temple_id'] as String?,
      nameEn: map['name_en'] as String? ?? '',
      nameTe: map['name_te'] as String?,
      nameHi: map['name_hi'] as String?,
      durationMins: (map['duration_mins'] as num?)?.toInt() ?? 60,
      basePrice: (map['base_price'] as num?)?.toInt() ?? 0,
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
      category: map['category'] as String? ?? 'both',
      requirements: List<String>.from(map['requirements'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'temple_id': templeId,
        'name_en': nameEn,
        'name_te': nameTe,
        'name_hi': nameHi,
        'duration_mins': durationMins,
        'base_price': basePrice,
        'description': description,
        'image_url': imageUrl,
        'category': category,
        'requirements': requirements,
      };
}

// Demo temples
List<TempleModel> get demoTemples => [
      const TempleModel(
        id: 't1',
        name: 'Sri Venkateswara Swamy Temple',
        description: 'One of the most sacred temples in Hyderabad. Daily poojas and special homams available.',
        address: 'Chilkur, Ranga Reddy',
        city: 'Hyderabad',
        state: 'Telangana',
        locationLat: 17.3200,
        locationLng: 78.2900,
        imageUrl: null,
        rating: 4.9,
        totalReviews: 1253,
        isVerified: true,
        openingTime: '05:30 AM',
        closingTime: '09:00 PM',
      ),
      const TempleModel(
        id: 't2',
        name: 'Birla Mandir',
        description: 'Beautiful white marble temple on a hilltop with stunning views of Hyderabad.',
        address: 'Naubat Pahad, Khairatabad',
        city: 'Hyderabad',
        state: 'Telangana',
        locationLat: 17.4062,
        locationLng: 78.4691,
        imageUrl: null,
        rating: 4.7,
        totalReviews: 892,
        isVerified: true,
        openingTime: '07:00 AM',
        closingTime: '08:00 PM',
      ),
      const TempleModel(
        id: 't3',
        name: 'Keesara Gutta Temple',
        description: 'Ancient Shiva temple with special Shivaratri celebrations and daily abhishekams.',
        address: 'Keesara, Medchal District',
        city: 'Hyderabad',
        state: 'Telangana',
        locationLat: 17.5500,
        locationLng: 78.6000,
        imageUrl: null,
        rating: 4.8,
        totalReviews: 634,
        isVerified: true,
        openingTime: '06:00 AM',
        closingTime: '08:30 PM',
      ),
    ];

// Demo poojas
List<PoojaModel> get demoPoojas => [
      const PoojaModel(
        id: 'pj1',
        nameEn: 'Satyanarayana Puja',
        nameTe: 'సత్యనారాయణ పూజ',
        durationMins: 120,
        basePrice: 2500,
        description: 'Auspicious puja performed for well-being, prosperity and fulfillment of wishes.',
        category: 'both',
        requirements: ['Flowers', 'Fruits', 'Milk', 'Honey', 'Panchamrit'],
      ),
      const PoojaModel(
        id: 'pj2',
        nameEn: 'Griha Pravesh',
        nameTe: 'గృహ ప్రవేశం',
        durationMins: 180,
        basePrice: 5000,
        description: 'Auspicious housewarming ceremony to bless the new home with positive energy.',
        category: 'home',
        requirements: ['Flowers', 'Kalash', 'Rice', 'Coconut', 'Pooja materials'],
      ),
      const PoojaModel(
        id: 'pj3',
        nameEn: 'Lakshmi Puja',
        nameTe: 'లక్ష్మీ పూజ',
        durationMins: 90,
        basePrice: 1500,
        description: 'Goddess Lakshmi puja for wealth, prosperity and good fortune.',
        category: 'both',
        requirements: ['Red flowers', 'Lotus', 'Coins', 'Sweets', 'Incense'],
      ),
      const PoojaModel(
        id: 'pj4',
        nameEn: 'Navagraha Homam',
        nameTe: 'నవగ్రహ హోమం',
        durationMins: 240,
        basePrice: 7500,
        description: 'Powerful homam to appease all nine planetary deities and remove doshas.',
        category: 'both',
        requirements: ['Havan samgri', 'Ghee', '9 types of grains', 'Flowers', 'Fruits'],
      ),
      const PoojaModel(
        id: 'pj5',
        nameEn: 'Ganesh Puja',
        nameTe: 'గణేశ పూజ',
        durationMins: 60,
        basePrice: 1000,
        description: 'Remove obstacles and seek blessings from Lord Ganesha for new beginnings.',
        category: 'both',
        requirements: ['Durva grass', 'Modak', 'Red flowers', 'Coconut'],
      ),
      const PoojaModel(
        id: 'pj6',
        nameEn: 'Rudrabhishek',
        nameTe: 'రుద్రాభిషేకం',
        durationMins: 150,
        basePrice: 4000,
        description: 'Sacred abhishekam to Lord Shiva with Panchamrit for health and spiritual growth.',
        category: 'both',
        requirements: ['Milk', 'Honey', 'Curd', 'Ghee', 'Sugar', 'Bilva leaves'],
      ),
    ];
