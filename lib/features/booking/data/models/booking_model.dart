class BookingModel {
  final String id;
  final String devoteeId;
  final String? panditId;
  final String? templeId;
  final String poojaId;
  final String? slotId;
  final String bookingType; // temple | home
  final DateTime bookingDate;
  final String startTime;
  final String? endTime;
  final String status; // pending | confirmed | completed | cancelled | rejected
  final String? gotram;
  final String? nakshatram;
  final String? address;
  final int totalAmount;
  final String? specialInstructions;
  final DateTime createdAt;

  // Joined data (not stored in bookings table directly)
  final String? devoteeName;
  final String? panditName;
  final String? panditPhotoUrl;
  final String? templeName;
  final String? poojaName;

  const BookingModel({
    required this.id,
    required this.devoteeId,
    this.panditId,
    this.templeId,
    required this.poojaId,
    this.slotId,
    required this.bookingType,
    required this.bookingDate,
    required this.startTime,
    this.endTime,
    required this.status,
    this.gotram,
    this.nakshatram,
    this.address,
    required this.totalAmount,
    this.specialInstructions,
    required this.createdAt,
    this.devoteeName,
    this.panditName,
    this.panditPhotoUrl,
    this.templeName,
    this.poojaName,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] as String,
      devoteeId: map['devotee_id'] as String,
      panditId: map['pandit_id'] as String?,
      templeId: map['temple_id'] as String?,
      poojaId: map['pooja_id'] as String,
      slotId: map['slot_id'] as String?,
      bookingType: map['booking_type'] as String? ?? 'home',
      bookingDate: DateTime.parse(map['booking_date'] as String),
      startTime: map['start_time'] as String? ?? '',
      endTime: map['end_time'] as String?,
      status: map['status'] as String? ?? 'pending',
      gotram: map['gotram'] as String?,
      nakshatram: map['nakshatram'] as String?,
      address: map['address'] as String?,
      totalAmount: (map['total_amount'] as num?)?.toInt() ?? 0,
      specialInstructions: map['special_instructions'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      devoteeName: map['devotee_name'] as String?,
      panditName: map['pandit_name'] as String?,
      panditPhotoUrl: map['pandit_photo_url'] as String?,
      templeName: map['temple_name'] as String?,
      poojaName: map['pooja_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'devotee_id': devoteeId,
        'pandit_id': panditId,
        'temple_id': templeId,
        'pooja_id': poojaId,
        'slot_id': slotId,
        'booking_type': bookingType,
        'booking_date': bookingDate.toIso8601String().split('T').first,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
        'gotram': gotram,
        'nakshatram': nakshatram,
        'address': address,
        'total_amount': totalAmount,
        'special_instructions': specialInstructions,
      };

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isTempleBooking => bookingType == 'temple';
  bool get isHomeBooking => bookingType == 'home';
}

class ReviewModel {
  final String id;
  final String bookingId;
  final String reviewerId;
  final String revieweeId;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final String? reviewerName;
  final String? reviewerAvatarUrl;

  const ReviewModel({
    required this.id,
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.reviewerName,
    this.reviewerAvatarUrl,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String,
      bookingId: map['booking_id'] as String,
      reviewerId: map['reviewer_id'] as String,
      revieweeId: map['reviewee_id'] as String,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      reviewerName: map['reviewer_name'] as String?,
      reviewerAvatarUrl: map['reviewer_avatar_url'] as String?,
    );
  }
}
