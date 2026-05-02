import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class TempleAdminShellScreen extends StatelessWidget {
  final Widget child;
  const TempleAdminShellScreen({super.key, required this.child});

  int _index(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/temple-admin/poojas')) return 1;
    if (loc.startsWith('/temple-admin/slots')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _index(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        onTap: (i) {
          if (i == 0) context.go(AppRoutes.templeAdminHome);
          if (i == 1) context.go(AppRoutes.managePoojas);
          if (i == 2) context.go(AppRoutes.manageSlots);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.temple_hindu_rounded), label: 'Poojas'),
          BottomNavigationBarItem(icon: Icon(Icons.event_available_rounded), label: 'Slots'),
        ],
      ),
    );
  }
}
