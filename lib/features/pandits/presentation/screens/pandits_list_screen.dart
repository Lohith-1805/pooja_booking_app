import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/pandit_model.dart';

class PanditsListScreen extends StatefulWidget {
  const PanditsListScreen({super.key});

  @override
  State<PanditsListScreen> createState() => _PanditsListScreenState();
}

class _PanditsListScreenState extends State<PanditsListScreen> {
  String _selectedLanguage = 'All';
  String _selectedSpecialization = 'All';
  String _sortBy = 'rating';
  List<PanditModel> _pandits = [];

  @override
  void initState() {
    super.initState();
    _pandits = demoPandits;
  }

  List<PanditModel> get _filteredPandits {
    var result = List<PanditModel>.from(_pandits);
    if (_selectedLanguage != 'All') {
      result = result
          .where((p) => p.languages.contains(_selectedLanguage))
          .toList();
    }
    // Specialization filter is not applied locally because the specializations
    // field was removed from PanditModel (it is stored in pandit_poojas table).
    // When connected to Supabase, filter via a join query instead.
    if (_sortBy == 'rating') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'price_low') {
      result.sort((a, b) => a.basePrice.compareTo(b.basePrice));
    } else if (_sortBy == 'price_high') {
      result.sort((a, b) => b.basePrice.compareTo(a.basePrice));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select a Pandit'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _buildFilterDropdowns(),
        ),
      ),
      body: Column(
        children: [
          // Sort chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text('Sort: ', style: AppTextStyles.labelSmall),
                  const SizedBox(width: 8),
                  ...[
                    ('rating', '⭐ Top Rated'),
                    ('price_low', '₹ Price: Low'),
                    ('price_high', '₹ Price: High'),
                  ].map((opt) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(opt.$2),
                          selected: _sortBy == opt.$1,
                          onSelected: (_) {
                            HapticFeedback.selectionClick();
                            setState(() => _sortBy = opt.$1);
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: _sortBy == opt.$1
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),

          // Pandit count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredPandits.length} Pandits found',
                  style: AppTextStyles.labelMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: _filteredPandits.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: _filteredPandits.length,
                    itemBuilder: (context, index) =>
                        _PanditCard(pandit: _filteredPandits[index], index: index),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdowns() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSpecialization,
                  isExpanded: true,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textPrimary),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18, color: AppColors.textHint),
                  items: AppConstants.poojaCategories.take(9).toList()
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedSpecialization = val!);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  isExpanded: true,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textPrimary),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18, color: AppColors.textHint),
                  items: ['All', ...AppConstants.languages]
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (val) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedLanguage = val!);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😔', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text('No pandits found', style: AppTextStyles.headingSmall),
          const SizedBox(height: 8),
          Text('Try adjusting your filters',
              style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _PanditCard extends StatefulWidget {
  final PanditModel pandit;
  final int index;
  const _PanditCard({required this.pandit, required this.index});

  @override
  State<_PanditCard> createState() => _PanditCardState();
}

class _PanditCardState extends State<_PanditCard> with SingleTickerProviderStateMixin {
  late AnimationController _tiltController;
  Offset _tapPosition = Offset.zero;

  Color _getLanguageColor(String language) {
    switch (language.toLowerCase()) {
      case 'telugu': return AppColors.primary;
      case 'hindi': return AppColors.golden;
      case 'tamil': return AppColors.sacred;
      case 'kannada': return AppColors.success;
      case 'english': return AppColors.info;
      default: return AppColors.primary;
    }
  }

  @override
  void initState() {
    super.initState();
    final disableAnim = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _tiltController = AnimationController(
      vsync: this,
      duration: disableAnim ? Duration.zero : const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _tiltController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
      _tiltController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!mounted) return;
    _tiltController.reverse();
    context.push('/pandits/${widget.pandit.id}');
  }

  void _onTapCancel() {
    if (!mounted) return;
    _tiltController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final primaryLang = widget.pandit.languages.isNotEmpty ? widget.pandit.languages.first : 'English';
    final accentColor = _getLanguageColor(primaryLang);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _tiltController,
        builder: (context, child) {
          final x = (_tapPosition.dy / 100) - 0.5;
          final y = -((_tapPosition.dx / 100) - 0.5);
          final matrix = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(x * 0.15 * _tiltController.value)
            ..rotateY(y * 0.15 * _tiltController.value);

          return Transform(
            transform: matrix,
            alignment: Alignment.center,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFFFF8F0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
            boxShadow: [
              // Glow
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 15,
                spreadRadius: 2,
              ),
              // Key Shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              // Ambient
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          widget.pandit.name.isNotEmpty ? widget.pandit.name.split(' ').last[0] : 'P',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(widget.pandit.name,
                                    style: AppTextStyles.headingSmall),
                              ),
                              if (widget.pandit.isVerified)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.successLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.verified_rounded,
                                          color: AppColors.success, size: 12),
                                      const SizedBox(width: 3),
                                      Text('Verified',
                                          style: AppTextStyles.labelSmall.copyWith(
                                              color: AppColors.success, fontSize: 10)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${widget.pandit.experienceYears}+ Years Experience',
                            style: AppTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: AppColors.golden, size: 16),
                              const SizedBox(width: 3),
                              Text(
                                widget.pandit.rating.toStringAsFixed(1),
                                style: AppTextStyles.rating,
                              ),
                              Text(
                                ' (${widget.pandit.totalReviews})',
                                style: AppTextStyles.bodySmall,
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.location_on_rounded,
                                  color: AppColors.primary, size: 14),
                              Text(widget.pandit.city ?? '',
                                  style: AppTextStyles.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Language chips
                          Wrap(
                            spacing: 6,
                            children: widget.pandit.languages.take(3).map((lang) =>
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                  color: AppColors.primaryExtraLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(lang,
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11)),
                              )).toList(),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${widget.pandit.basePrice} onwards',
                                style: AppTextStyles.labelLarge
                                    .copyWith(color: AppColors.primary),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    context.push('/pandits/${widget.pandit.id}'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  textStyle: const TextStyle(fontSize: 13),
                                ),
                                child: const Text('View Profile'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Inner highlight
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 60 * widget.index)).slideY(begin: 0.2),
    );
  }
}
