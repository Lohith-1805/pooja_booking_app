import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  String? _selectedRole;
  bool _isLoading = false;

  final List<_RoleOption> _roles = [
    _RoleOption(
      role: AppConstants.roleDevotee,
      title: 'Devotee',
      subtitle: 'Book poojas at temples or pandit at home',
      emoji: '🙏',
      color: AppColors.primary,
    ),
    _RoleOption(
      role: AppConstants.rolePandit,
      title: 'Pandit / Priest',
      subtitle: 'Offer pooja services and manage bookings',
      emoji: '📿',
      color: AppColors.sacred,
    ),
    _RoleOption(
      role: AppConstants.roleTempleAdmin,
      title: 'Temple Admin',
      subtitle: 'Manage your temple\'s poojas and slots',
      emoji: '🛕',
      color: Color(0xFF6A1B9A),
    ),
  ];

  Future<void> _proceed() async {
    if (_selectedRole == null) return;
    setState(() => _isLoading = true);

    try {
      final authUser = Supabase.instance.client.auth.currentUser;
      if (authUser == null) throw Exception('Not authenticated');

      // Save/update user profile in our users table
      await Supabase.instance.client.from('users').upsert({
        'auth_id': authUser.id,
        'phone': authUser.phone ?? '',
        'role': _selectedRole,
        'name': '',           // User can fill in profile later
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'auth_id');

      if (!mounted) return;

      // Navigate to the correct dashboard
      switch (_selectedRole) {
        case AppConstants.roleDevotee:
          context.go(AppRoutes.home);
          break;
        case AppConstants.rolePandit:
          context.go(AppRoutes.panditHome);
          break;
        case AppConstants.roleTempleAdmin:
          context.go(AppRoutes.templeAdminHome);
          break;
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text('Who are you? 🌟', style: AppTextStyles.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Select your role to get the right experience',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 36),
              Expanded(
                child: ListView.separated(
                  itemCount: _roles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    final isSelected = _selectedRole == role.role;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedRole = role.role),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? role.color.withOpacity(0.08)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? role.color : AppColors.borderLight,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: role.color.withOpacity(0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  )
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: role.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(role.emoji,
                                    style: const TextStyle(fontSize: 30)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(role.title,
                                      style: AppTextStyles.headingSmall.copyWith(
                                          color: isSelected
                                              ? role.color
                                              : AppColors.textPrimary)),
                                  const SizedBox(height: 4),
                                  Text(role.subtitle,
                                      style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle_rounded,
                                  color: role.color, size: 26),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: (_selectedRole != null && !_isLoading) ? _proceed : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : Text('Continue', style: AppTextStyles.buttonText),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleOption {
  final String role;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;

  const _RoleOption({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
  });
}
