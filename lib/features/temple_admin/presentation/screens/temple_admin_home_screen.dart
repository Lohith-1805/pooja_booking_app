import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
class TempleAdminHomeScreen extends StatelessWidget {
  const TempleAdminHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Temple Dashboard'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: AppColors.sacredGradient, borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              const Text('🛕', style: TextStyle(fontSize: 40)),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sri Venkateswara Temple', style: AppTextStyles.headingSmall.copyWith(color: Colors.white)),
                Text('Hyderabad, Telangana', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            _StatCard("Today", "12", "Bookings", AppColors.primary),
            const SizedBox(width: 10),
            _StatCard("Revenue", "₹28,500", "Today", AppColors.success),
            const SizedBox(width: 10),
            _StatCard("Slots", "8/15", "Filled", AppColors.warning),
          ]),
          const SizedBox(height: 24),
          Text("Recent Bookings", style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          _BookingRow("Priya Sharma", "Satyanarayana Puja", "9:00 AM", 2500),
          const SizedBox(height: 8),
          _BookingRow("Ravi Kumar", "Rudrabhishek", "11:00 AM", 4000),
          const SizedBox(height: 8),
          _BookingRow("Lakshmi Devi", "Lakshmi Puja", "2:00 PM", 1500),
        ]),
      ),
    );
  }
  Widget _StatCard(String period, String value, String label, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(children: [
        Text(period, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
        Text(value, style: AppTextStyles.headingSmall.copyWith(color: color, fontSize: 15), textAlign: TextAlign.center),
        Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
      ])));
  Widget _BookingRow(String name, String pooja, String time, int amount) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.borderLight)),
    child: Row(children: [
      Container(width: 38, height: 38,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary)),
        Text("$pooja · $time", style: AppTextStyles.bodySmall),
      ])),
      Text("₹$amount", style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
    ]));
}
