import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => context.push(AppRoutes.editProfile),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Text('R',
                            style: AppTextStyles.displayLarge
                                .copyWith(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Rohan Kumar',
                        style: AppTextStyles.headingMedium
                            .copyWith(color: Colors.white)),
                    Text('+91 9876543210',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats
                  Row(
                    children: [
                      Expanded(child: _StatCard(label: 'Bookings', value: '12')),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(label: 'Poojas Done', value: '8')),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(label: 'Reviews', value: '6')),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _Section(title: 'Account', children: [
                    _ProfileTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profile',
                      onTap: () => context.push(AppRoutes.editProfile),
                    ),
                    _ProfileTile(
                      icon: Icons.location_on_outlined,
                      title: 'Saved Addresses',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notification Settings',
                      onTap: () => context.push(AppRoutes.notifications),
                    ),
                  ]),
                  const SizedBox(height: 16),

                  _Section(title: 'Support', children: [
                    _ProfileTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & FAQ',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.chat_outlined,
                      title: 'Contact Support',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.star_outline_rounded,
                      title: 'Rate the App',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 16),

                  _Section(title: 'Legal', children: [
                    _ProfileTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.go(AppRoutes.phoneLogin);
                      },
                      icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                      label: Text('Log Out',
                          style: AppTextStyles.buttonText
                              .copyWith(color: AppColors.error)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PoojaConnect v${AppConstants.appVersion}',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Text(value,
              style: AppTextStyles.headingMedium
                  .copyWith(color: AppColors.primary, fontSize: 22)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.headingSmall),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? subtitle;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.primaryExtraLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge),
      subtitle: subtitle != null ? Text(subtitle!, style: AppTextStyles.bodySmall) : null,
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
