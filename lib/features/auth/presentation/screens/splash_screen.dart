import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _orbController;
  late AnimationController _glowController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _letterSpacing;
  late Animation<double> _glowRadius;

  @override
  void initState() {
    super.initState();

    final disableAnim =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures
            .disableAnimations;

    _logoController = AnimationController(
      vsync: this,
      duration: disableAnim
          ? Duration.zero
          : const Duration(milliseconds: 1200),
    );
    _textController = AnimationController(
      vsync: this,
      duration: disableAnim
          ? Duration.zero
          : const Duration(milliseconds: 800),
    );
    _orbController = AnimationController(
      vsync: this,
      duration: disableAnim
          ? Duration.zero
          : const Duration(seconds: 6),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: disableAnim
          ? Duration.zero
          : const Duration(milliseconds: 2000),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _letterSpacing = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _glowRadius = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 20.0, end: 45.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 45.0, end: 20.0), weight: 50),
    ]).animate(_glowController);

    _startAnimation(disableAnim);
  }

  void _startAnimation(bool disableAnim) async {
    if (disableAnim) {
      _logoController.value = 1.0;
      _textController.value = 1.0;
      await Future.delayed(const Duration(milliseconds: 500));
      await _navigate();
      return;
    }

    if (!disableAnim) {
      _orbController.repeat();
      _glowController.repeat();
    }

    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));
    await _navigate();
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      try {
        final data = await Supabase.instance.client
            .from('users')
            .select('role')
            .eq('auth_id', session.user.id)
            .maybeSingle();

        if (!mounted) return;

        final role = data?['role'] as String? ?? 'devotee';
        switch (role) {
          case 'pandit':
            context.go(AppRoutes.panditHome);
            break;
          case 'temple_admin':
            context.go(AppRoutes.templeAdminHome);
            break;
          case 'super_admin':
            context.go(AppRoutes.superAdminHome);
            break;
          default:
            context.go(AppRoutes.home);
        }
      } catch (_) {
        if (!mounted) return;
        context.go(AppRoutes.onboarding);
      }
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _orbController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8B1A1A), Color(0xFFD4600A), Color(0xFFF5A623)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Animated floating orbs
            AnimatedBuilder(
              animation: _orbController,
              builder: (context, _) => CustomPaint(
                painter: _OrbPainter(_orbController.value),
                child: const SizedBox.expand(),
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with pulsing glow
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_logoController, _glowController]),
                    builder: (context, child) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              // Pulsing glow
                              BoxShadow(
                                color: const Color(0xFFF5A623).withOpacity(0.6),
                                blurRadius: _glowRadius.value,
                                spreadRadius: 4,
                              ),
                              // Key shadow
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                              // Ambient
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 60,
                                offset: const Offset(0, 30),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '🪔',
                              style: TextStyle(fontSize: 58),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // App name with letter-spacing animation
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) => FadeTransition(
                      opacity: _textOpacity,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          children: [
                            Text(
                              'PoojaConnect',
                              style: AppTextStyles.displayLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: _letterSpacing.value,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Book Poojas & Pandits',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white.withOpacity(0.85),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _dot(),
                                const SizedBox(width: 6),
                                Text(
                                  'Temple Poojas  •  Home Rituals',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.white.withOpacity(0.7),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _dot(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom loader
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textOpacity,
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot() => Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      );
}

/// Paints 3 animated floating orbs using sinusoidal drift paths.
class _OrbPainter extends CustomPainter {
  final double t;
  _OrbPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final orbs = [
      _OrbConfig(
        baseX: size.width * 0.15,
        baseY: size.height * 0.18,
        radius: 100,
        xAmp: 18,
        yAmp: 22,
        phase: 0.0,
        color: Colors.white.withOpacity(0.06),
      ),
      _OrbConfig(
        baseX: size.width * 0.85,
        baseY: size.height * 0.35,
        radius: 80,
        xAmp: 14,
        yAmp: 18,
        phase: 2.09,
        color: Colors.white.withOpacity(0.05),
      ),
      _OrbConfig(
        baseX: size.width * 0.5,
        baseY: size.height * 0.82,
        radius: 130,
        xAmp: 20,
        yAmp: 14,
        phase: 4.19,
        color: Colors.white.withOpacity(0.04),
      ),
    ];

    for (final orb in orbs) {
      final angle = t * 2 * math.pi;
      final dx = orb.baseX + orb.xAmp * math.sin(angle + orb.phase);
      final dy = orb.baseY + orb.yAmp * math.cos(angle + orb.phase);

      paint.color = orb.color;
      canvas.drawCircle(Offset(dx, dy), orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_OrbPainter old) => old.t != t;
}

class _OrbConfig {
  final double baseX, baseY, radius, xAmp, yAmp, phase;
  final Color color;
  const _OrbConfig({
    required this.baseX,
    required this.baseY,
    required this.radius,
    required this.xAmp,
    required this.yAmp,
    required this.phase,
    required this.color,
  });
}
