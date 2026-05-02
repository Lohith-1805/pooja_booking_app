import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class SuperAdminShellScreen extends StatelessWidget {
  final Widget child;
  const SuperAdminShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin'),
        actions: [
          TextButton(
            onPressed: () => context.go(AppRoutes.phoneLogin),
            child: Text('Logout',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.error)),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('PoojaConnect', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                Text('Super Admin Panel', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.dashboard_rounded),
            label: const Text('Dashboard'),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.people_rounded),
            label: const Text('Users'),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.person_search_rounded),
            label: const Text('Pandits Approval'),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.temple_hindu_rounded),
            label: const Text('Temples Approval'),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.analytics_rounded),
            label: const Text('Analytics'),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.settings_rounded),
            label: const Text('Settings'),
          ),
        ],
      ),
      body: child,
    );
  }
}
