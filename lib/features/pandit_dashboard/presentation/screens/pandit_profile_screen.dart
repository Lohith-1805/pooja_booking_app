import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
class PanditProfileScreen extends StatelessWidget {
  const PanditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(gradient: AppColors.sacredGradient, shape: BoxShape.circle),
            child: const Center(child: Text('S', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white)))),
          const SizedBox(height: 12),
          Text('Pandit Suresh Sharma', style: AppTextStyles.headingMedium),
          Text('20+ Years Experience', style: AppTextStyles.bodySmall),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.star_rounded, color: AppColors.golden, size: 16),
            Text('4.8 (312 reviews)', style: AppTextStyles.bodySmall),
          ]),
          const SizedBox(height: 24),
          ListTile(leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.chevron_right_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tileColor: AppColors.surface, onTap: () {}),
          const SizedBox(height: 8),
          ListTile(leading: const Icon(Icons.description_rounded, color: AppColors.primary),
            title: const Text('Documents & Verification'),
            trailing: const Icon(Icons.chevron_right_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tileColor: AppColors.surface, onTap: () {}),
          const SizedBox(height: 8),
          ListTile(leading: const Icon(Icons.account_balance_rounded, color: AppColors.primary),
            title: const Text('Bank Account Details'),
            trailing: const Icon(Icons.chevron_right_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tileColor: AppColors.surface, onTap: () {}),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.phoneLogin),
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              foregroundColor: AppColors.error,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
        ]),
      ),
    );
  }
}
