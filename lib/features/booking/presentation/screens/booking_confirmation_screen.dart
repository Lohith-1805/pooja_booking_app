import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String bookingId;
  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends State<BookingConfirmationScreen> {
  Map<String, dynamic>? _booking;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBooking();
  }

  Future<void> _fetchBooking() async {
    // Skip fetch if bookingId looks like a temp local ID (not a real UUID)
    if (widget.bookingId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final data = await Supabase.instance.client
          .from('bookings')
          .select(
            'id, booking_date, start_time, end_time, address, status, '
            'pooja_master(name_en), '
            'pandits(name), '
            'users(full_name)',
          )
          .eq('id', widget.bookingId)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _booking = data as Map<String, dynamic>?;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? _buildError()
                  : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 56, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Could not load booking details',
              style: AppTextStyles.headingSmall),
          const SizedBox(height: 8),
          Text('Booking ID: ${widget.bookingId}',
              style: AppTextStyles.captionBold),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.myBookings),
            child: const Text('View My Bookings'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Resolve values from Supabase join, or fall back to a generic message.
    final poojaName =
        (_booking?['pooja_master'] as Map<String, dynamic>?)?['name_en']
            as String? ??
        'Your Pooja';
    final panditName =
        (_booking?['pandits'] as Map<String, dynamic>?)?['name']
            as String? ??
        '';
    final devoteeName =
        (_booking?['users'] as Map<String, dynamic>?)?['full_name']
            as String? ??
        '';
    final date = _booking?['booking_date'] as String? ?? '';
    final startTime = _booking?['start_time'] as String? ?? '';
    final endTime = _booking?['end_time'] as String? ?? '';
    final timeRange = (startTime.isNotEmpty && endTime.isNotEmpty)
        ? '$startTime - $endTime'
        : startTime.isNotEmpty
            ? startTime
            : '—';
    final address = _booking?['address'] as String? ?? '—';

    return Column(
      children: [
        const SizedBox(height: 40),
        // Success icon
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
          'Booking ID: ${widget.bookingId}',
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
              Text(poojaName, style: AppTextStyles.headingSmall),
              if (panditName.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('with $panditName', style: AppTextStyles.bodySmall),
              ],
              if (devoteeName.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Booked by $devoteeName',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textHint)),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(),
              ),
              if (date.isNotEmpty)
                _ConfirmRow(
                    icon: Icons.calendar_month_rounded,
                    label: 'Date',
                    value: date),
              if (timeRange != '—') ...[
                const SizedBox(height: 8),
                _ConfirmRow(
                    icon: Icons.schedule_rounded,
                    label: 'Time',
                    value: timeRange),
              ],
              const SizedBox(height: 8),
              _ConfirmRow(
                  icon: Icons.location_on_rounded,
                  label: 'Address',
                  value: address),
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
