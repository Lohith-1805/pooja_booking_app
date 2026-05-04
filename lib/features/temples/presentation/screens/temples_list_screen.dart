import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/temple_model.dart';

class TemplesListScreen extends StatefulWidget {
  const TemplesListScreen({super.key});
  @override
  State<TemplesListScreen> createState() => _TemplesListScreenState();
}

class _TemplesListScreenState extends State<TemplesListScreen> {
  final List<TempleModel> _temples = demoTemples;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nearby Temples')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: _temples.length,
        itemBuilder: (context, index) => _TempleListCard(temple: _temples[index], index: index),
      ),
    );
  }
}

class _TempleListCard extends StatefulWidget {
  final TempleModel temple;
  final int index;
  const _TempleListCard({required this.temple, required this.index});

  @override
  State<_TempleListCard> createState() => _TempleListCardState();
}

class _TempleListCardState extends State<_TempleListCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final emojis = ['🛕', '🏛️', '⛩️'];
    final index = demoTemples.indexOf(widget.temple);
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        context.push('/temples/${widget.temple.id}');
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isPressed ? 3 : 0, 0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFFFF8F0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              // Ambient
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
              // Key
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
              // Glow
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    height: 140,
                    decoration: const BoxDecoration(
                      gradient: AppColors.sacredGradient,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(emojis[index % emojis.length],
                              style: const TextStyle(fontSize: 70)),
                        ),
                        if (widget.temple.isVerified)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.successLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified_rounded,
                                      color: AppColors.success, size: 14),
                                  const SizedBox(width: 4),
                                  Text('Verified',
                                      style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.success, fontSize: 11)),
                                ],
                              ),
                            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                             .shimmer(duration: const Duration(milliseconds: 2000), color: Colors.white60),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.temple.name, style: AppTextStyles.headingSmall),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.primary, size: 15),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(widget.temple.address,
                                  style: AppTextStyles.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.golden, size: 16),
                            const SizedBox(width: 4),
                            Text(widget.temple.rating.toStringAsFixed(1),
                                style: AppTextStyles.rating),
                            Text(' (${widget.temple.totalReviews} reviews)',
                                style: AppTextStyles.bodySmall),
                            const Spacer(),
                            const Icon(Icons.schedule_rounded,
                                size: 14, color: AppColors.textHint),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.temple.openingTime} - ${widget.temple.closingTime}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.push('/temples/${widget.temple.id}'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('View & Book Poojas'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Inner highlight
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 60 * widget.index)).slideY(begin: 0.15),
    );
  }
}
