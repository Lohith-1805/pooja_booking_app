import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../temples/data/models/temple_model.dart';
import '../../../pandits/data/models/pandit_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final String _userName = 'Devotee';
  final String _city = 'Hyderabad';

  late AnimationController _bannerShimmerController;
  late Animation<double> _shimmerProgress;

  @override
  void initState() {
    super.initState();
    final disableAnim =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures
            .disableAnimations;

    _bannerShimmerController = AnimationController(
      vsync: this,
      duration: disableAnim ? Duration.zero : const Duration(seconds: 8),
    );

    _shimmerProgress = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
          parent: _bannerShimmerController, curve: Curves.easeInOut),
    );

    if (!disableAnim) {
      _bannerShimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerShimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildBannerSection()),
            SliverToBoxAdapter(child: _buildQuickActions()),
            SliverToBoxAdapter(child: _buildPopularPoojas()),
            SliverToBoxAdapter(child: _buildNearbyTemplesSection()),
            SliverToBoxAdapter(child: _buildTopPanditsSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Namaste, $_userName 🙏',
                style: AppTextStyles.headingSmall,
              ),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: AppColors.primary, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    '$_city  ▾',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Notification bell
          GestureDetector(
            onTap: () => context.push(AppRoutes.notifications),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.notifications_outlined,
                        color: AppColors.textPrimary, size: 22),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          GestureDetector(
            onTap: () => context.go(AppRoutes.profile),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : 'D',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: () {
          // TODO: Open search screen
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search_rounded,
                  color: AppColors.textHint, size: 22),
              const SizedBox(width: 10),
              Text(
                'Search Poojas or Pandits...',
                style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GestureDetector(
        onTap: () => context.go(AppRoutes.temples),
        child: AnimatedBuilder(
          animation: _bannerShimmerController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: [
                    _shimmerProgress.value - 0.2,
                    _shimmerProgress.value,
                    _shimmerProgress.value + 0.2,
                  ],
                  begin: const Alignment(-1.0, -0.5),
                  end: const Alignment(1.0, 0.5),
                ).createShader(bounds);
              },
              blendMode: BlendMode.screen,
              child: child,
            );
          },
          child: Container(
            height: 165,
            decoration: BoxDecoration(
              gradient: AppColors.bannerGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: -30,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Book Poojas Online',
                        style: AppTextStyles.headingLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Temple Poojas & Home Poojas\nExperienced Pandits Near You',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'Book Now →',
                          style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                // Diya emoji
                const Positioned(
                  right: 20,
                  bottom: 20,
                  child: Text('🪔', style: TextStyle(fontSize: 56)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              emoji: '🛕',
              title: 'Book in Temple',
              subtitle: 'Fixed slots & instant confirmation',
              gradient: const [Color(0xFF8B1A1A), Color(0xFFD4600A)],
              onTap: () => context.go(AppRoutes.temples),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionCard(
              emoji: '🏠',
              title: 'Pandit at Home',
              subtitle: 'Book experienced pandits',
              gradient: const [Color(0xFFD4600A), Color(0xFFF5A623)],
              onTap: () => context.go(AppRoutes.pandits),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularPoojas() {
    final poojas = demoPoojas;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular Poojas', style: AppTextStyles.headingSmall.copyWith(
                shadows: [
                  Shadow(offset: const Offset(0, 1), blurRadius: 3, color: Colors.black.withOpacity(0.08)),
                ],
              )),
              TextButton(
                onPressed: () => context.go(AppRoutes.pandits),
                child: Text('See All',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: poojas.length,
            itemBuilder: (context, index) {
              final pooja = poojas[index];
              final emojis = ['🌸', '🏠', '🪷', '🔥', '🐘', '🕉️'];
              return GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.primaryExtraLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          emojis[index % emojis.length],
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 70,
                      child: Text(
                        pooja.nameEn.split(' ').first,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 60 * index)).slideY(begin: 0.1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyTemplesSection() {
    final temples = demoTemples;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nearby Temples', style: AppTextStyles.headingSmall.copyWith(
                shadows: [
                  Shadow(offset: const Offset(0, 1), blurRadius: 3, color: Colors.black.withOpacity(0.08)),
                ],
              )),
              TextButton(
                onPressed: () => context.go(AppRoutes.temples),
                child: Text('See All',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: temples.length,
            itemBuilder: (context, index) => _TempleCard(temple: temples[index])
                .animate()
                .fadeIn(delay: Duration(milliseconds: 60 * index))
                .slideX(begin: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildTopPanditsSection() {
    final pandits = demoPandits.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Pandits', style: AppTextStyles.headingSmall.copyWith(
                shadows: [
                  Shadow(offset: const Offset(0, 1), blurRadius: 3, color: Colors.black.withOpacity(0.08)),
                ],
              )),
              TextButton(
                onPressed: () => context.go(AppRoutes.pandits),
                child: Text('See All',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: pandits.length,
          itemBuilder: (context, index) => _PanditListTile(pandit: pandits[index], index: index),
        ),
      ],
    );
  }
}

// =====================
// Supporting widgets
// =====================

class _QuickActionCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> with TickerProviderStateMixin {
  late AnimationController _tiltController;
  late AnimationController _rippleController;
  Offset _tapPosition = Offset.zero;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    final disableAnim = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _tiltController = AnimationController(
      vsync: this,
      duration: disableAnim ? Duration.zero : const Duration(milliseconds: 150),
    );
    _rippleController = AnimationController(
      vsync: this,
      duration: disableAnim ? Duration.zero : const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _tiltController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
      _rippleController.forward(from: 0.0);
      _tiltController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!mounted) return;
    _tiltController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    if (!mounted) return;
    _tiltController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
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
              ..rotateX(x * 0.1 * _tiltController.value)
              ..rotateY(y * 0.1 * _tiltController.value);

            return Transform(
              transform: matrix,
              alignment: Alignment.center,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: widget.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      // Glow
                      BoxShadow(
                        color: widget.gradient.last.withOpacity(0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                      // Key shadow
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                      // Ambient
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.emoji, style: const TextStyle(fontSize: 30)),
                      const SizedBox(height: 10),
                      Text(
                        widget.title,
                        style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withOpacity(0.8), height: 1.4),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedBuilder(
                      animation: _rippleController,
                      builder: (context, _) => CustomPaint(
                        painter: _RipplePainter(
                          progress: _rippleController.value,
                          center: _tapPosition,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
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
          ).animate().shimmer(duration: const Duration(milliseconds: 1500), color: Colors.white24),
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Offset center;
  final Color color;

  _RipplePainter({required this.progress, required this.center, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0 || progress == 1.0) return;
    final paint = Paint()
      ..color = color.withOpacity(color.opacity * (1 - progress))
      ..style = PaintingStyle.fill;
    final maxRadius = size.width * 1.5;
    canvas.drawCircle(center, maxRadius * progress, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _TempleCard extends StatefulWidget {
  final TempleModel temple;
  const _TempleCard({required this.temple});

  @override
  State<_TempleCard> createState() => _TempleCardState();
}

class _TempleCardState extends State<_TempleCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final templeEmojis = ['🛕', '🏛️', '⛩️'];
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
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
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
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image area
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppColors.sacredGradient,
                    ),
                    child: Center(
                      child: Text(
                        templeEmojis[index % templeEmojis.length],
                        style: const TextStyle(fontSize: 46),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.temple.name,
                          style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.golden, size: 14),
                            const SizedBox(width: 3),
                            Text(
                              widget.temple.rating.toStringAsFixed(1),
                              style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary),
                            ),
                          ],
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
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanditListTile extends StatefulWidget {
  final PanditModel pandit;
  final int index;
  const _PanditListTile({required this.pandit, required this.index});

  @override
  State<_PanditListTile> createState() => _PanditListTileState();
}

class _PanditListTileState extends State<_PanditListTile> {
  bool _isPressed = false;

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
  Widget build(BuildContext context) {
    final primaryLang = widget.pandit.languages.isNotEmpty ? widget.pandit.languages.first : 'English';
    final accentColor = _getLanguageColor(primaryLang);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        context.push('/pandits/${widget.pandit.id}');
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
            boxShadow: [
              // Ambient
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
              // Key
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              // Glow
              BoxShadow(
                color: accentColor.withOpacity(0.05),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    widget.pandit.name.isNotEmpty ? widget.pandit.name[0] : 'P',
                    style: AppTextStyles.headingMedium
                        .copyWith(color: Colors.white),
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
                        Text(
                          widget.pandit.name,
                          style: AppTextStyles.labelLarge,
                        ),
                        if (widget.pandit.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded,
                              color: AppColors.primary, size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${widget.pandit.experienceYears}+ Years Experience',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: AppColors.golden, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          widget.pandit.rating.toStringAsFixed(1),
                          style: AppTextStyles.rating,
                        ),
                        Text(
                          ' (${widget.pandit.totalReviews} reviews)',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${widget.pandit.basePrice}',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 3),
                  Text('onwards', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'View',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 60 * widget.index)).slideY(begin: 0.15),
    );
  }
}
