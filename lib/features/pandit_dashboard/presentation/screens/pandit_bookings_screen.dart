import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
class PanditBookingsScreen extends StatelessWidget {
  const PanditBookingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Bookings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card('Priya Sharma', 'Satyanarayana Puja', '18 Feb', '9:00 AM', 'confirmed'),
          const SizedBox(height: 12),
          _card('Ravi Kumar', 'Lakshmi Puja', '20 Feb', '2:00 PM', 'pending'),
          const SizedBox(height: 12),
          _card('Sita Devi', 'Griha Pravesh', '14 Feb', '6:00 AM', 'completed'),
        ],
      ),
    );
  }
  Widget _card(String name, String pooja, String date, String time, String status) {
    final colors = {'confirmed': Colors.green, 'pending': Colors.orange, 'completed': Colors.blue};
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight)),
      child: Row(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(name[0],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTextStyles.labelLarge),
          Text(pooja, style: AppTextStyles.bodySmall),
          Text('$date at $time', style: AppTextStyles.bodySmall),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colors[status]!.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(status, style: TextStyle(color: colors[status], fontSize: 11,
            fontWeight: FontWeight.w600))),
      ]),
    );
  }
}
