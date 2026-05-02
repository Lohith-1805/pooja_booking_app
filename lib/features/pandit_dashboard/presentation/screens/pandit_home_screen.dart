import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PanditHomeScreen extends StatelessWidget {
  const PanditHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome, Pandit Suresh 🙏', style: AppTextStyles.headingSmall),
                Text('Hyderabad', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  Row(
                    children: [
                      Expanded(child: _StatCard('Today', '2', 'Bookings', AppColors.primary)),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard('This Month', '₹18,500', 'Earned', AppColors.success)),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard('Rating', '4.8 ⭐', 'Avg', AppColors.golden)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Today's bookings
                  Text("Today's Bookings", style: AppTextStyles.headingSmall),
                  const SizedBox(height: 12),
                  _BookingRequest(
                    devoteeName: 'Priya Sharma',
                    poojaName: 'Satyanarayana Puja',
                    time: '9:00 AM',
                    address: '123, Jubilee Hills',
                    isPending: true,
                  ),
                  const SizedBox(height: 10),
                  _BookingRequest(
                    devoteeName: 'Ravi Kumar',
                    poojaName: 'Lakshmi Puja',
                    time: '2:00 PM',
                    address: '456, Banjara Hills',
                    isPending: false,
                  ),
                  const SizedBox(height: 24),

                  // Quick toggle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Available for Bookings',
                                style: AppTextStyles.labelLarge),
                            Text('Toggle off to pause new bookings',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                        const Spacer(),
                        Switch(
                          value: true,
                          onChanged: (v) {},
                          activeColor: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String period;
  final String value;
  final String label;
  final Color color;
  const _StatCard(this.period, this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(period, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyles.headingSmall.copyWith(color: color, fontSize: 16),
              textAlign: TextAlign.center),
          Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}

class _BookingRequest extends StatelessWidget {
  final String devoteeName;
  final String poojaName;
  final String time;
  final String address;
  final bool isPending;

  const _BookingRequest({
    required this.devoteeName,
    required this.poojaName,
    required this.time,
    required this.address,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(devoteeName[0],
                      style: const TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(devoteeName, style: AppTextStyles.labelLarge),
                    Text(poojaName, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPending
                      ? AppColors.warningLight
                      : AppColors.successLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(isPending ? 'Pending' : 'Confirmed',
                    style: AppTextStyles.labelSmall.copyWith(
                        color: isPending ? AppColors.warning : AppColors.success,
                        fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textHint),
            const SizedBox(width: 4),
            Text(time, style: AppTextStyles.bodySmall),
            const SizedBox(width: 12),
            const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(address, style: AppTextStyles.bodySmall),
          ]),
          if (isPending) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Reject',
                        style: TextStyle(color: AppColors.error, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Accept',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
