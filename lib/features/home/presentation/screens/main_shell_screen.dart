import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class MainShellScreen extends StatefulWidget {
  final Widget child;
  const MainShellScreen({super.key, required this.child});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/temples')) return 1;
    if (location.startsWith('/pandits')) return 2;
    if (location.startsWith('/my-bookings')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    return Scaffold(
      extendBody: true, // Required for glassmorphism to show body underneath
      body: widget.child,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xCCFFFFFF),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: currentIndex == 0,
                      onTap: () => context.go(AppRoutes.home),
                    ),
                    _NavItem(
                      icon: Icons.temple_hindu_rounded,
                      label: 'Temples',
                      isSelected: currentIndex == 1,
                      onTap: () => context.go(AppRoutes.temples),
                    ),
                    _NavItem(
                      icon: Icons.person_search_rounded,
                      label: 'Pandits',
                      isSelected: currentIndex == 2,
                      onTap: () => context.go(AppRoutes.pandits),
                    ),
                    _NavItem(
                      icon: Icons.calendar_month_rounded,
                      label: 'Bookings',
                      isSelected: currentIndex == 3,
                      onTap: () => context.go(AppRoutes.myBookings),
                    ),
                    _NavItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      isSelected: currentIndex == 4,
                      onTap: () => context.go(AppRoutes.profile),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: widget.isSelected ? AppColors.primary : AppColors.textHint,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              widget.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: widget.isSelected ? AppColors.primary : AppColors.textHint,
                fontWeight:
                    widget.isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            // Animated indicator pill
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 4,
              width: widget.isSelected ? 20 : 0,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
