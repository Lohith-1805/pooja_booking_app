import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/phone_login_screen.dart';
import '../../features/auth/presentation/screens/otp_verify_screen.dart';
import '../../features/auth/presentation/screens/role_select_screen.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/temples/presentation/screens/temples_list_screen.dart';
import '../../features/temples/presentation/screens/temple_detail_screen.dart';
import '../../features/temples/presentation/screens/pooja_slot_screen.dart';
import '../../features/pandits/presentation/screens/pandits_list_screen.dart';
import '../../features/pandits/presentation/screens/pandit_detail_screen.dart';
import '../../features/booking/presentation/screens/booking_flow_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmation_screen.dart';
import '../../features/booking/presentation/screens/my_bookings_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/pandit_dashboard/presentation/screens/pandit_shell_screen.dart';
import '../../features/pandit_dashboard/presentation/screens/pandit_home_screen.dart';
import '../../features/pandit_dashboard/presentation/screens/pandit_bookings_screen.dart';
import '../../features/pandit_dashboard/presentation/screens/pandit_availability_screen.dart';
import '../../features/pandit_dashboard/presentation/screens/pandit_earnings_screen.dart';
import '../../features/pandit_dashboard/presentation/screens/pandit_profile_screen.dart';
import '../../features/temple_admin/presentation/screens/temple_admin_shell_screen.dart';
import '../../features/temple_admin/presentation/screens/temple_admin_home_screen.dart';
import '../../features/temple_admin/presentation/screens/manage_poojas_screen.dart';
import '../../features/temple_admin/presentation/screens/manage_slots_screen.dart';
import '../../features/super_admin/presentation/screens/super_admin_shell_screen.dart';
import '../../features/super_admin/presentation/screens/super_admin_home_screen.dart';

class AppRoutes {
  // Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String phoneLogin = '/login/phone';
  static const String otpVerify = '/login/otp';
  static const String roleSelect = '/login/role';

  // Devotee Shell
  static const String home = '/home';
  static const String temples = '/temples';
  static const String templeDetail = '/temples/:id';
  static const String poojaSlot = '/temples/:id/slot';
  static const String pandits = '/pandits';
  static const String panditDetail = '/pandits/:id';
  static const String bookingFlow = '/booking';
  static const String bookingConfirmation = '/booking/confirmation';
  static const String myBookings = '/my-bookings';
  static const String payment = '/payment';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String notifications = '/notifications';

  // Pandit Shell
  static const String panditHome = '/pandit/home';
  static const String panditBookings = '/pandit/bookings';
  static const String panditAvailability = '/pandit/availability';
  static const String panditEarnings = '/pandit/earnings';
  static const String panditProfile = '/pandit/profile';

  // Temple Admin Shell
  static const String templeAdminHome = '/temple-admin/home';
  static const String managePoojas = '/temple-admin/poojas';
  static const String manageSlots = '/temple-admin/slots';

  // Super Admin Shell
  static const String superAdminHome = '/super-admin/home';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneLogin,
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerify,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpVerifyScreen(phone: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.roleSelect,
        builder: (context, state) => const RoleSelectScreen(),
      ),

      // Devotee Shell
      ShellRoute(
        builder: (context, state, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.temples,
            builder: (context, state) => const TemplesListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    TempleDetailScreen(id: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'slot',
                    builder: (context, state) =>
                        PoojaSlotScreen(templeId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.pandits,
            builder: (context, state) => const PanditsListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    PanditDetailScreen(id: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.myBookings,
            builder: (context, state) => const MyBookingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Booking flow (outside shell)
      GoRoute(
        path: AppRoutes.bookingFlow,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return BookingFlowScreen(bookingArgs: args ?? {});
        },
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return PaymentScreen(paymentArgs: args ?? {});
        },
      ),
      GoRoute(
        path: AppRoutes.bookingConfirmation,
        builder: (context, state) {
          final bookingId = state.extra as String? ?? '';
          return BookingConfirmationScreen(bookingId: bookingId);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Pandit Shell
      ShellRoute(
        builder: (context, state, child) => PanditShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.panditHome,
            builder: (context, state) => const PanditHomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.panditBookings,
            builder: (context, state) => const PanditBookingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.panditAvailability,
            builder: (context, state) => const PanditAvailabilityScreen(),
          ),
          GoRoute(
            path: AppRoutes.panditEarnings,
            builder: (context, state) => const PanditEarningsScreen(),
          ),
          GoRoute(
            path: AppRoutes.panditProfile,
            builder: (context, state) => const PanditProfileScreen(),
          ),
        ],
      ),

      // Temple Admin Shell
      ShellRoute(
        builder: (context, state, child) => TempleAdminShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.templeAdminHome,
            builder: (context, state) => const TempleAdminHomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.managePoojas,
            builder: (context, state) => const ManagePoojasScreen(),
          ),
          GoRoute(
            path: AppRoutes.manageSlots,
            builder: (context, state) => const ManageSlotsScreen(),
          ),
        ],
      ),

      // Super Admin Shell
      ShellRoute(
        builder: (context, state, child) => SuperAdminShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.superAdminHome,
            builder: (context, state) => const SuperAdminHomeScreen(),
          ),
        ],
      ),
    ],
  );
});
