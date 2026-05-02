import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        itemBuilder: (context, index) => _TempleListCard(temple: _temples[index]),
      ),
    );
  }
}

class _TempleListCard extends StatelessWidget {
  final TempleModel temple;
  const _TempleListCard({required this.temple});

  @override
  Widget build(BuildContext context) {
    final emojis = ['🛕', '🏛️', '⛩️'];
    final index = demoTemples.indexOf(temple);
    return GestureDetector(
      onTap: () => context.push('/temples/${temple.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: AppColors.sacredGradient,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(emojis[index % emojis.length],
                        style: const TextStyle(fontSize: 70)),
                  ),
                  if (temple.isVerified)
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
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(temple.name, style: AppTextStyles.headingSmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: AppColors.primary, size: 15),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(temple.address,
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
                      Text(temple.rating.toStringAsFixed(1),
                          style: AppTextStyles.rating),
                      Text(' (${temple.totalReviews} reviews)',
                          style: AppTextStyles.bodySmall),
                      const Spacer(),
                      const Icon(Icons.schedule_rounded,
                          size: 14, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        '${temple.openingTime} - ${temple.closingTime}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.push('/temples/${temple.id}'),
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
      ),
    );
  }
}
