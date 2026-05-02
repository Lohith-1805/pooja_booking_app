import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
class PanditEarningsScreen extends StatelessWidget {
  const PanditEarningsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Earnings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              Text('Total Earnings', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
              Text('₹45,800', style: AppTextStyles.priceLarge.copyWith(color: Colors.white, fontSize: 36)),
              Text('This Month', style: AppTextStyles.bodySmall.copyWith(color: Colors.white60)),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            _EarningCard('This Week', '₹8,200', AppColors.primary),
            const SizedBox(width: 12),
            _EarningCard('Pending', '₹3,500', AppColors.warning),
          ]),
          const SizedBox(height: 24),
          Text('Recent Transactions', style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          _TxnRow('Satyanarayana Puja', '18 Feb', 2500, true),
          _TxnRow('Griha Pravesh', '14 Feb', 5000, true),
          _TxnRow('Lakshmi Puja', '10 Feb', 1500, false),
          _TxnRow('Navagraha Homam', '5 Feb', 7500, true),
        ]),
      ),
    );
  }
  Widget _EarningCard(String label, String amount, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(children: [
        Text(amount, style: AppTextStyles.headingMedium.copyWith(color: color)),
        Text(label, style: AppTextStyles.bodySmall),
      ]),
    ),
  );
  Widget _TxnRow(String name, String date, int amount, bool received) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.borderLight)),
    child: Row(children: [
      Icon(received ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
          color: received ? AppColors.success : AppColors.warning, size: 20),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary)),
        Text(date, style: AppTextStyles.bodySmall),
      ])),
      Text('${received ? '+' : '-'}₹$amount',
          style: AppTextStyles.labelLarge.copyWith(
            color: received ? AppColors.success : AppColors.warning)),
    ]),
  );
}
