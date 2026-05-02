import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotifData(
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
        title: 'Booking Confirmed',
        body: 'Your Satyanarayana Puja has been confirmed for 18 Feb 2025.',
        time: '2h ago',
      ),
      _NotifData(
        icon: Icons.payment_rounded,
        color: AppColors.primary,
        title: 'Payment Successful',
        body: 'Payment of ₹2,750 received for Griha Pravesh.',
        time: '1d ago',
      ),
      _NotifData(
        icon: Icons.star_rounded,
        color: AppColors.golden,
        title: 'Rate Your Experience',
        body: 'How was your Ganesh Puja with Pandit Ravi Shastri?',
        time: '3d ago',
      ),
      _NotifData(
        icon: Icons.local_offer_rounded,
        color: AppColors.sacred,
        title: 'Festival Special Offer',
        body: 'Get 15% off on all poojas this Ugadi!',
        time: '5d ago',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Mark all read',
                style: AppTextStyles.labelSmall
                    .copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: notifications.length,
        itemBuilder: (context, index) =>
            _NotifCard(data: notifications[index], isRead: index > 1),
      ),
    );
  }
}

class _NotifData {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  const _NotifData({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
  });
}

class _NotifCard extends StatelessWidget {
  final _NotifData data;
  final bool isRead;
  const _NotifCard({required this.data, required this.isRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead ? AppColors.surface : AppColors.primaryExtraLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRead ? AppColors.borderLight : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.title,
                        style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600)),
                    Text(data.time, style: AppTextStyles.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                Text(data.body,
                    style: AppTextStyles.bodySmall.copyWith(height: 1.4)),
              ],
            ),
          ),
          if (!isRead) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
            ),
          ],
        ],
      ),
    );
  }
}
