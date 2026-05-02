class AppConstants {
  // App Info
  static const String appName = 'PoojaConnect';
  static const String appTagline = 'Book Poojas & Pandits';
  static const String appVersion = '1.0.0';

  // Supabase - Replace with your actual credentials after creating Supabase project
  static const String supabaseUrl = 'https://wtviyppiqrcthjqcsxvg.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind0dml5cHBpcXJjdGhqcWNzeHZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc2OTA0NDgsImV4cCI6MjA5MzI2NjQ0OH0.4xuPFffJWpHtEKYXmerhL6jKiacapCsqIVjfrSiDBOs';

  // Razorpay - TEST mode (safe to use, no real money charged)
  // ✅ Use this for development & testing
  // 🔴 Switch to 'rzp_live_XXXX' only when going to production
  //
  // To get your own test key:
  //   1. Go to https://dashboard.razorpay.com
  //   2. Sign up (free) → Settings → API Keys → Generate Test Key
  //   3. Replace the key below with your rzp_test_XXXXX key
  // ✅ PASTE YOUR rzp_test_XXXXXXXX KEY BELOW (API Key from Razorpay Dashboard)
  // ⚠️  Secret Key must NEVER go here — store it in Supabase Edge Function env vars only
  static const String razorpayKeyId = 'PASTE_YOUR_rzp_test_KEY_HERE';
  static const bool razorpayTestMode = true;
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
