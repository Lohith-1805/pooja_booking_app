import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class PanditShellScreen extends StatelessWidget {
  final Widget child;
  const PanditShellScreen({super.key, required this.child});

  int _index(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/pandit/bookings')) return 1;
    if (loc.startsWith('/pandit/availability')) return 2;
    if (loc.startsWith('/pandit/earnings')) return 3;
    if (loc.startsWith('/pandit/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _index(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.sacred.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard',
                  isSelected: idx == 0,
                  onTap: () => context.go(AppRoutes.panditHome)),
              _NavItem(icon: Icons.calendar_month_rounded, label: 'Bookings',
                  isSelected: idx == 1,
                  onTap: () => context.go(AppRoutes.panditBookings)),
              _NavItem(icon: Icons.event_available_rounded, label: 'Availability',
                  isSelected: idx == 2,
                  onTap: () => context.go(AppRoutes.panditAvailability)),
              _NavItem(icon: Icons.account_balance_wallet_rounded, label: 'Earnings',
                  isSelected: idx == 3,
                  onTap: () => context.go(AppRoutes.panditEarnings)),
              _NavItem(icon: Icons.person_rounded, label: 'Profile',
                  isSelected: idx == 4,
                  onTap: () => context.go(AppRoutes.panditProfile)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label,
      required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sacred.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? AppColors.sacred : AppColors.textHint, size: 22),
            const SizedBox(height: 3),
            Text(label,
                style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected ? AppColors.sacred : AppColors.textHint,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
