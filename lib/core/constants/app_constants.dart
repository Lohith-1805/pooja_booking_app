class AppConstants {
  // App Info
  static const String appName = 'PoojaConnect';
  static const String appTagline = 'Book Poojas & Pandits';
  static const String appVersion = '1.0.0';

  // Supabase - Replace with your actual credentials after creating Supabase project
  static const String supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';

  // Razorpay - Replace with your actual key after creating Razorpay account
  static const String razorpayKeyId = 'rzp_test_YOUR_KEY_ID';
  static const String razorpayCurrency = 'INR';

  // Pagination
  static const int pageSize = 20;
  static const int panditsPerPage = 10;
  static const int templesPerPage = 10;

  // Booking
  static const int cancellationHoursLimit = 24;
  static const double platformCommissionPercent = 15.0;

  // Cache
  static const int cacheExpiryMinutes = 30;

  // Google Maps
  static const double defaultLatitude = 17.3850; // Hyderabad
  static const double defaultLongitude = 78.4867;
  static const double searchRadiusKm = 25.0;

  // Pooja categories
  static const List<String> poojaCategories = [
    'All',
    'Satyanarayana Puja',
    'Griha Pravesh',
    'Lakshmi Puja',
    'Ganesh Puja',
    'Navagraha Homam',
    'Rudrabhishek',
    'Vivah',
    'Namkaran',
    'Annaprasanna',
    'Upanayanam',
    'Pitru Paksha',
  ];

  // Indian Languages
  static const List<String> languages = [
    'Telugu',
    'Sanskrit',
    'Hindi',
    'Tamil',
    'Kannada',
    'Malayalam',
    'Bengali',
    'Marathi',
  ];

  // Gotrams (common ones)
  static const List<String> gotrams = [
    'Kashyapa',
    'Bharadwaja',
    'Vasistha',
    'Atri',
    'Jamadagni',
    'Vishwamitra',
    'Goutama',
    'Agastya',
    'Kaundinya',
    'Harita',
    'Angirasa',
    'Srivatsa',
    'Other',
  ];

  // Nakshatrams (27 stars)
  static const List<String> nakshatrams = [
    'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira',
    'Ardra', 'Punarvasu', 'Pushya', 'Ashlesha', 'Magha',
    'Purva Phalguni', 'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati',
    'Vishakha', 'Anuradha', 'Jyeshtha', 'Mula', 'Purva Ashadha',
    'Uttara Ashadha', 'Shravana', 'Dhanishtha', 'Shatabhisha',
    'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati',
  ];

  // Booking status
  static const String bookingPending = 'pending';
  static const String bookingConfirmed = 'confirmed';
  static const String bookingCompleted = 'completed';
  static const String bookingCancelled = 'cancelled';
  static const String bookingRejected = 'rejected';

  // User roles
  static const String roleDevotee = 'devotee';
  static const String rolePandit = 'pandit';
  static const String roleTempleAdmin = 'temple_admin';
  static const String roleSuperAdmin = 'super_admin';
}
