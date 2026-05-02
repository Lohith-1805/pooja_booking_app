import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;
  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Success animation
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Booking Confirmed! 🎉',
                  style: AppTextStyles.headingLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'Your pooja has been successfully booked. The pandit will contact you shortly.',
                style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Booking ID: $bookingId',
                style: AppTextStyles.captionBold,
              ),
              const SizedBox(height: 32),

              // Booking details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('🪔', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 12),
                    Text('Satyanarayana Puja',
                        style: AppTextStyles.headingSmall),
                    const SizedBox(height: 4),
                    Text('with Pandit Suresh Sharma',
                        style: AppTextStyles.bodySmall),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(),
                    ),
                    _ConfirmRow(icon: Icons.calendar_month_rounded,
                        label: 'Date', value: '18 Feb 2025'),
                    const SizedBox(height: 8),
                    _ConfirmRow(icon: Icons.schedule_rounded,
                        label: 'Time', value: '9:00 AM - 11:00 AM'),
                    const SizedBox(height: 8),
                    _ConfirmRow(icon: Icons.location_on_rounded,
                        label: 'Address',
                        value: '123, Jubilee Hills, Hyderabad'),
                  ],
                ),
              ),
              const Spacer(),

              ElevatedButton(
                onPressed: () => context.go(AppRoutes.myBookings),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('View My Bookings'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ConfirmRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text('$label: ', style: AppTextStyles.bodySmall),
        Expanded(
          child: Text(value,
              style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              textAlign: TextAlign.right),
        ),
      ],
    );
  }
}
