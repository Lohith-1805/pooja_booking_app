import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../temples/data/models/temple_model.dart';
class ManagePoojasScreen extends StatelessWidget {
  const ManagePoojasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Manage Poojas'),
        actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () {})]),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: demoPoojas.length,
        itemBuilder: (context, i) {
          final p = demoPoojas[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight)),
            child: Row(children: [
              Text(["🌸","🏠","🪷","🔥","🐘","🕉️"][i % 6], style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.nameEn, style: AppTextStyles.labelLarge),
                Text("${p.durationMins} mins · ₹${p.basePrice}", style: AppTextStyles.bodySmall),
              ])),
              IconButton(icon: const Icon(Icons.edit_rounded, color: AppColors.primary), onPressed: () {}),
              Switch(value: true, onChanged: (v) {}, activeColor: AppColors.success),
            ]));
        }),
    );
  }
}
