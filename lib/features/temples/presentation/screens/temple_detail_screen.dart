import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

    final availablePoojas = demoPoojas
        .where((p) => p.category == 'temple' || p.category == 'both')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.sacred,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                    gradient: AppColors.sacredGradient),
                child: Stack(
                  children: [
                    const Center(
                      child: Text('🛕', style: TextStyle(fontSize: 80)),
                    ),
                    // Glassmorphic overlay at the bottom
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0x33FFFFFF),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      temple.name,
                                      style: AppTextStyles.headingSmall.copyWith(color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(width: 1, height: 16, color: Colors.white.withOpacity(0.4)),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.star_rounded, color: AppColors.goldenLight, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    temple.rating.toStringAsFixed(1),
                                    style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  ...List.generate(availablePoojas.length, (index) {
                    return _PoojaRow(
                      pooja: availablePoojas[index],
                      templeId: temple.id,
                      index: index,
                    );
                  }),
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
  final int index;
  const _PoojaRow({required this.pooja, required this.templeId, required this.index});

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
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF8F0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          // Ambient
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          // Key
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          // Glow
          BoxShadow(
            color: AppColors.primary.withOpacity(0.03),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
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
              _AnimatedBookButton(
                onTap: () => context.push(
                    '/temples/$templeId/slot',
                    extra: {'poojaId': pooja.id, 'poojaName': pooja.nameEn}),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 60 * index)).slideY(begin: 0.2);
  }
}

class _AnimatedBookButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AnimatedBookButton({required this.onTap});

  @override
  State<_AnimatedBookButton> createState() => _AnimatedBookButtonState();
}

class _AnimatedBookButtonState extends State<_AnimatedBookButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) => Transform.scale(
          scale: 1.0 - _scaleController.value,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text('Book',
              style: AppTextStyles.labelSmall
                  .copyWith(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}
