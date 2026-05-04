import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/pandit_model.dart';

class PanditDetailScreen extends StatefulWidget {
  final String id;
  const PanditDetailScreen({super.key, required this.id});

  @override
  State<PanditDetailScreen> createState() => _PanditDetailScreenState();
}

class _PanditDetailScreenState extends State<PanditDetailScreen> {
  PanditModel? _pandit;
  // Specializations are fetched from pandit_poojas joined with pooja_master,
  // because the `specializations TEXT[]` column was removed from the schema.
  List<String> _specializations = [];
  bool _loadingSpecs = true;

  @override
  void initState() {
    super.initState();
    _pandit = demoPandits.where((p) => p.id == widget.id).firstOrNull;
    _fetchSpecializations();
  }

  Future<void> _fetchSpecializations() async {
    try {
      final rows = await Supabase.instance.client
          .from('pandit_poojas')
          .select('pooja_master(name_en)')
          .eq('pandit_id', widget.id);

      final specs = (rows as List<dynamic>).map((row) {
        final master = row['pooja_master'] as Map<String, dynamic>?;
        return master?['name_en'] as String? ?? '';
      }).where((s) => s.isNotEmpty).toList();

      if (mounted) {
        setState(() {
          _specializations = specs;
          _loadingSpecs = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingSpecs = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pandit = _pandit;
    if (pandit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pandit')),
        body: const Center(child: Text('Pandit not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.sacredGradient,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.4), width: 3),
                          ),
                          child: Center(
                            child: Text(
                              pandit.name.isNotEmpty ? pandit.name[0] : 'P',
                              style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              pandit.name,
                              style: AppTextStyles.headingMedium
                                  .copyWith(color: Colors.white),
                            ),
                            if (pandit.isVerified) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded,
                                  color: Colors.white, size: 18),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pandit.experienceYears}+ Years Experience',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                    // Glassmorphic Info Bar
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0x33FFFFFF),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, color: AppColors.goldenLight, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    pandit.rating.toStringAsFixed(1),
                                    style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(width: 1, height: 12, color: Colors.white.withOpacity(0.4)),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.translate_rounded, color: Colors.white70, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${pandit.languages.length} Languages',
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
                  // Stats row
                  Row(
                    children: [
                      Expanded(
                          child: _StatBox(
                              label: 'Rating',
                              value: pandit.rating.toStringAsFixed(1),
                              icon: Icons.star_rounded,
                              color: AppColors.golden)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _StatBox(
                              label: 'Reviews',
                              value: '${pandit.totalReviews}',
                              icon: Icons.reviews_rounded,
                              color: AppColors.primary)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _StatBox(
                              label: 'Experience',
                              value: '${pandit.experienceYears}y',
                              icon: Icons.workspace_premium_rounded,
                              color: AppColors.sacred)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // About
                  Text('About', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 8),
                  Text(
                    pandit.bio ??
                        'An experienced pandit with deep knowledge of Vedic rituals.',
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 20),

                  // Specializations — fetched from pandit_poojas join pooja_master
                  Text('Specializations', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 10),
                  _loadingSpecs
                      ? const SizedBox(
                          height: 36,
                          child: Center(
                              child: SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )))
                      : _specializations.isEmpty
                          ? Text('No specializations listed.',
                              style: AppTextStyles.bodySmall)
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _specializations.map((spec) {
                                return GestureDetector(
                                  onTap: () {
                                    context.push(AppRoutes.bookingFlow, extra: {
                                      'panditId': pandit.id,
                                      'panditName': pandit.name,
                                      'poojaName': spec,
                                      'basePrice': pandit.basePrice,
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryExtraLight,
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: AppColors.border),
                                    ),
                                    child: Text(
                                      spec,
                                      style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                  const SizedBox(height: 20),

                  // Languages
                  Text('Languages', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pandit.languages.map((lang) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.translate_rounded,
                                  size: 14, color: AppColors.textHint),
                              const SizedBox(width: 5),
                              Text(lang,
                                  style: AppTextStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        )).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Location
                  Text('Location', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${pandit.city}  •  Travels up to ${pandit.travelRadiusKm?.toInt() ?? 20} km',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Reviews section (demo)
                  Text('Recent Reviews', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 12),
                  const _DemoReviewTile(
                    name: 'Priya Sharma',
                    rating: 5.0,
                    comment: 'Excellent pandit! Very knowledgeable and performed the puja with great devotion.',
                  ).animate().fadeIn(delay: const Duration(milliseconds: 100)).slideX(begin: 0.3),
                  const SizedBox(height: 12),
                  const _DemoReviewTile(
                    name: 'Ravi Kumar',
                    rating: 4.5,
                    comment: 'Very punctual and professional. Explained every step of the puja clearly.',
                  ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideX(begin: 0.3),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom booking bar
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹${pandit.basePrice}',
                    style: AppTextStyles.price.copyWith(color: AppColors.primary),
                  ),
                  Text('onwards', style: AppTextStyles.bodySmall),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _AnimatedBookingButton(pandit: pandit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedBookingButton extends StatefulWidget {
  final PanditModel pandit;
  const _AnimatedBookingButton({required this.pandit});

  @override
  State<_AnimatedBookingButton> createState() => _AnimatedBookingButtonState();
}

class _AnimatedBookingButtonState extends State<_AnimatedBookingButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.04,
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
        context.push(AppRoutes.bookingFlow, extra: {
          'panditId': widget.pandit.id,
          'panditName': widget.pandit.name,
          'basePrice': widget.pandit.basePrice,
          'bookingType': 'home',
        });
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) => Transform.scale(
          scale: 1.0 - _scaleController.value,
          child: child,
        ),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text('Book Now', style: AppTextStyles.buttonText),
          ),
        ),
      ),
    );
  }
}


class _StatBox extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<_StatBox> createState() => _StatBoxState();
}

class _StatBoxState extends State<_StatBox> {
  double _targetValue = 0.0;
  String _suffix = '';
  bool _isDecimal = false;

  @override
  void initState() {
    super.initState();
    _parseValue();
  }

  void _parseValue() {
    final match = RegExp(r'^([\d.]+)(.*)$').firstMatch(widget.value);
    if (match != null) {
      _targetValue = double.tryParse(match.group(1) ?? '0') ?? 0.0;
      _suffix = match.group(2) ?? '';
      _isDecimal = widget.value.contains('.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnim = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: widget.color.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(widget.icon, color: widget.color, size: 22),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: _targetValue),
            duration: disableAnim ? Duration.zero : const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, val, child) {
              String formattedVal;
              if (_isDecimal) {
                formattedVal = val.toStringAsFixed(1);
              } else {
                formattedVal = val.toInt().toString();
              }
              return Text(
                '$formattedVal$_suffix',
                style: AppTextStyles.headingSmall.copyWith(color: widget.color, fontSize: 18),
              );
            },
          ),
          const SizedBox(height: 3),
          Text(widget.label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}

class _DemoReviewTile extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;

  const _DemoReviewTile({
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(name[0],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary)),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < rating.floor()
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppColors.golden,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment,
              style: AppTextStyles.bodySmall.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
