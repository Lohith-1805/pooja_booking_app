import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/temple_model.dart';

class TempleDetailScreen extends StatelessWidget {
  final String id;
  const TempleDetailScreen({super.key, required this.id});

  TempleModel? get _temple =>
      demoTemples.where((t) => t.id == id).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final temple = _temple;
    if (temple == null) {
      return Scaffold(
          appBar: AppBar(title: const Text('Temple')),
          body: const Center(child: Text('Temple not found')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.sacred,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(temple.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              background: Container(
                decoration: const BoxDecoration(
                    gradient: AppColors.sacredGradient),
                child: const Center(
                  child: Text('🛕', style: TextStyle(fontSize: 80)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info row
                  Row(children: [
                    const Icon(Icons.location_on_rounded,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(temple.address,
                            style: AppTextStyles.bodyMedium)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.schedule_rounded,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                        '${temple.openingTime} - ${temple.closingTime}',
                        style: AppTextStyles.bodyMedium),
                    const SizedBox(width: 16),
                    const Icon(Icons.star_rounded,
                        color: AppColors.golden, size: 18),
                    const SizedBox(width: 4),
                    Text(temple.rating.toStringAsFixed(1),
                        style: AppTextStyles.rating),
                    Text(' (${temple.totalReviews})',
                        style: AppTextStyles.bodySmall),
                  ]),
                  const SizedBox(height: 16),
                  if (temple.description != null) ...[
                    Text('About', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 8),
                    Text(temple.description!,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.6)),
                    const SizedBox(height: 20),
                  ],
                  Text('Available Poojas',
                      style: AppTextStyles.headingSmall),
                  const SizedBox(height: 12),
                  ...demoPoojas
                      .where((p) =>
                          p.category == 'temple' || p.category == 'both')
                      .map((pooja) => _PoojaRow(
                            pooja: pooja,
                            templeId: temple.id,
                          )),
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

class _PoojaRow extends StatelessWidget {
  final PoojaModel pooja;
  final String templeId;
  const _PoojaRow({required this.pooja, required this.templeId});

  @override
  Widget build(BuildContext context) {
    final emojis = {'Satyanarayana': '🌸', 'Griha': '🏠', 'Lakshmi': '🪷',
        'Navagraha': '🔥', 'Ganesh': '🐘', 'Rudra': '🕉️'};
    final emoji = emojis.entries
            .firstWhere((e) => pooja.nameEn.contains(e.key),
                orElse: () => const MapEntry('', '🙏'))
            .value;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryExtraLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pooja.nameEn, style: AppTextStyles.labelLarge),
                if (pooja.nameTe != null)
                  Text(pooja.nameTe!,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primary)),
                const SizedBox(height: 3),
                Text('${pooja.durationMins} mins',
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${pooja.basePrice}',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.primary)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => context.push(
                    '/temples/$templeId/slot',
                    extra: {'poojaId': pooja.id, 'poojaName': pooja.nameEn}),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Book',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
