import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});
  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList('upcoming'),
          _buildBookingsList('completed'),
          _buildBookingsList('cancelled'),
        ],
      ),
    );
  }

  Widget _buildBookingsList(String status) {
    // Demo bookings
    if (status == 'upcoming') {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BookingCard(
            poojaName: 'Satyanarayana Puja',
            with_: 'Pandit Suresh Sharma',
            date: '18 Feb 2025',
            time: '9:00 AM',
            status: 'confirmed',
            amount: 2750,
            emoji: '🌸',
          ),
          const SizedBox(height: 12),
          _BookingCard(
            poojaName: 'Griha Pravesh',
            with_: 'Sri Venkateswara Temple',
            date: '25 Feb 2025',
            time: '6:00 AM',
            status: 'pending',
            amount: 5000,
            emoji: '🏠',
          ),
        ],
      );
    } else if (status == 'completed') {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BookingCard(
            poojaName: 'Ganesh Puja',
            with_: 'Pandit Ravi Shastri',
            date: '5 Jan 2025',
            time: '10:00 AM',
            status: 'completed',
            amount: 1100,
            emoji: '🐘',
            showReview: true,
          ),
        ],
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😌', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text('No cancelled bookings', style: AppTextStyles.headingSmall),
          ],
        ),
      );
    }
  }
}

class _BookingCard extends StatelessWidget {
  final String poojaName;
  final String with_;
  final String date;
  final String time;
  final String status;
  final int amount;
  final String emoji;
  final bool showReview;

  const _BookingCard({
    required this.poojaName,
    required this.with_,
    required this.date,
    required this.time,
    required this.status,
    required this.amount,
    required this.emoji,
    this.showReview = false,
  });

  Color get _statusColor {
    switch (status) {
      case 'confirmed': return AppColors.success;
      case 'pending': return AppColors.warning;
      case 'completed': return AppColors.primary;
      case 'cancelled': return AppColors.error;
      default: return AppColors.textHint;
    }
  }

  String get _statusLabel => status[0].toUpperCase() + status.substring(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(poojaName, style: AppTextStyles.headingSmall),
                    Text(with_, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_statusLabel,
                    style: AppTextStyles.labelSmall
                        .copyWith(color: _statusColor, fontSize: 11)),
              ),
            ],
          ),
          const Divider(height: 20, color: AppColors.divider),
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text('$date at $time', style: AppTextStyles.bodySmall),
              const Spacer(),
              Text('₹$amount',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.primary)),
            ],
          ),
          if (status == 'confirmed') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 38),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text('Cancel', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 38),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text('Track', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
          if (showReview) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 38),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.star_rounded, size: 16, color: AppColors.golden),
                  SizedBox(width: 6),
                  Text('Write a Review', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
