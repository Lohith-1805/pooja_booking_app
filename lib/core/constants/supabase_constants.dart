// Supabase table names — must match the schema in assets/data/supabase_schema.sql
class Tables {
  static const String users = 'users';
  static const String pandits = 'pandits';
  // 'pandit_specializations' was renamed — the join table is pandit_poojas
  static const String panditPoojas = 'pandit_poojas';
  static const String temples = 'temples';
  // Schema table is pooja_master (not 'poojas')
  static const String poojas = 'pooja_master';
  static const String templeSlots = 'temple_slots';
  static const String panditAvailability = 'pandit_availability';
  static const String bookings = 'bookings';
  static const String payments = 'payments';
  static const String reviews = 'reviews';
  static const String notifications = 'notifications';
  static const String banners = 'banners';
  // festivalEvents ('festival_events') does not exist in the schema — do not use in queries.
  // static const String festivalEvents = 'festival_events';
}

// Storage bucket names
class Buckets {
  static const String panditPhotos = 'pandit-photos';
  static const String templePhotos = 'temple-photos';
  static const String poojaImages = 'pooja-images';
  static const String userAvatars = 'user-avatars';
  static const String documents = 'documents';
  static const String banners = 'banners';
}
