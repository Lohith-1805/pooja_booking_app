import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SuperAdminHomeScreen extends StatelessWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform Overview', style: AppTextStyles.headingMedium),
          const SizedBox(height: 16),

          // Stats grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _AdminStatCard('Total Users', '12,450', Icons.people_rounded, AppColors.primary),
              _AdminStatCard('Active Pandits', '284', Icons.person_search_rounded, AppColors.sacred),
              _AdminStatCard('Temples', '48', Icons.temple_hindu_rounded, Color(0xFF6A1B9A)),
              _AdminStatCard('Bookings Today', '142', Icons.calendar_month_rounded, AppColors.success),
              _AdminStatCard('Revenue Today', '₹2.4L', Icons.account_balance_wallet_rounded, AppColors.golden),
              _AdminStatCard('Pending Approvals', '7', Icons.pending_rounded, AppColors.warning),
            ],
          ),
          const SizedBox(height: 24),

          // Pending approvals
          Text('Pending Pandit Approvals', style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          _ApprovalCard(
            name: 'Pandit Mahesh Kumar',
            city: 'Hyderabad',
            experience: '12 years',
            specialization: 'Vedic Poojas',
          ),
          const SizedBox(height: 10),
          _ApprovalCard(
            name: 'Pandit Vijay Sharma',
            city: 'Bangalore',
            experience: '8 years',
            specialization: 'Marriage Ceremonies',
          ),
          const SizedBox(height: 24),

          // Quick actions
          Text('Quick Actions', style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ActionChip(icon: Icons.person_add_rounded, label: 'Add Pandit', color: AppColors.primary),
              _ActionChip(icon: Icons.add_business_rounded, label: 'Add Temple', color: AppColors.sacred),
              _ActionChip(icon: Icons.analytics_rounded, label: 'View Reports', color: AppColors.golden),
              _ActionChip(icon: Icons.campaign_rounded, label: 'Send Notification', color: AppColors.success),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminStatCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: AppTextStyles.headingMedium.copyWith(
                      color: color, fontSize: 20)),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final String name;
  final String city;
  final String experience;
  final String specialization;

  const _ApprovalCard({
    required this.name,
    required this.city,
    required this.experience,
    required this.specialization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warningLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(name[0],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.labelLarge),
                    Text('$city · $experience · $specialization',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Pending',
                    style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.warning, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Reject', style: TextStyle(fontSize: 13)),
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
                  child: const Text('Approve',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(label,
                style: AppTextStyles.labelSmall.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
