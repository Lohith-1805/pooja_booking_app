import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
class ManageSlotsScreen extends StatelessWidget {
  const ManageSlotsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final slots = [
      {"pooja": "Satyanarayana Puja", "time": "9:00 AM - 11:00 AM", "booked": 3, "capacity": 5, "date": "Today"},
      {"pooja": "Satyanarayana Puja", "time": "2:00 PM - 4:00 PM", "booked": 1, "capacity": 5, "date": "Today"},
      {"pooja": "Rudrabhishek", "time": "6:00 AM - 8:00 AM", "booked": 2, "capacity": 3, "date": "Tomorrow"},
      {"pooja": "Lakshmi Puja", "time": "5:00 PM - 7:00 PM", "booked": 0, "capacity": 4, "date": "Tomorrow"},
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Manage Slots'),
        actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () {})]),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: slots.length,
        itemBuilder: (context, i) {
          final s = slots[i];
          final pct = (s["booked"] as int) / (s["capacity"] as int);
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(s["pooja"] as String, style: AppTextStyles.labelLarge),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.primaryExtraLight, borderRadius: BorderRadius.circular(8)),
                  child: Text(s["date"] as String, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 6),
              Text(s["time"] as String, style: AppTextStyles.bodySmall),
              const SizedBox(height: 10),
              Row(children: [
                Text("${s["booked"]}/${s["capacity"]} booked", style: AppTextStyles.bodySmall),
                const Spacer(),
                IconButton(icon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 18), onPressed: () {}),
                IconButton(icon: const Icon(Icons.delete_rounded, color: AppColors.error, size: 18), onPressed: () {}),
              ]),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: pct, minHeight: 6,
                  backgroundColor: AppColors.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(pct > 0.8 ? AppColors.error : AppColors.success))),
            ]));
        }),
    );
  }
}
