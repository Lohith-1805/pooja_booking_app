import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> paymentArgs;
  const PaymentScreen({super.key, required this.paymentArgs});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  late Razorpay _razorpay;
  bool _isProcessing = false;
  bool _paymentComplete = false;

  late AnimationController _breathingController;

  int get _amount => widget.paymentArgs['amount'] as int? ?? 2750;
  String get _poojaName => widget.paymentArgs['poojaName'] as String? ?? 'Pooja';
  String get _panditName => widget.paymentArgs['panditName'] as String? ?? 'Pandit';
  String get _userPhone => widget.paymentArgs['phone'] as String? ?? '';
  String get _userEmail => widget.paymentArgs['email'] as String? ?? '';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleWallet);

    final disableAnim = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _breathingController = AnimationController(
      vsync: this,
      duration: disableAnim ? Duration.zero : const Duration(milliseconds: 3000),
    );
    if (!disableAnim) {
      _breathingController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    _breathingController.dispose();
    super.dispose();
  }

  Future<void> _openRazorpay({String? method}) async {
    setState(() => _isProcessing = true);

    String? orderId;

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'create-razorpay-order',
        body: {
          'amount': _amount * 100,
          'currency': AppConstants.razorpayCurrency,
          'receipt': 'rcpt_${DateTime.now().millisecondsSinceEpoch}',
          'notes': {'pooja': _poojaName, 'pandit': _panditName},
        },
      );
      orderId = response.data?['order_id'] as String?;
    } catch (_) {
      orderId = null;
    }

    final options = <String, dynamic>{
      'key': AppConstants.razorpayKeyId,
      'amount': _amount * 100,       // paise
      'currency': AppConstants.razorpayCurrency,
      'name': AppConstants.appName,
      'description': '$_poojaName with $_panditName',
      'prefill': {
        'contact': _userPhone.isNotEmpty ? _userPhone : '9999999999',
        'email': _userEmail.isNotEmpty ? _userEmail : 'test@poojaconnect.in',
      },
      'theme': {'color': '#D4600A'},
    };

    if (orderId != null) {
      options['order_id'] = orderId;
    }

    if (method != null) {
      options['method'] = method;
    }

    if (!mounted) return;
    _razorpay.open(options);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _paymentComplete = true;
    });
    context.go(AppRoutes.bookingConfirmation,
        extra: 'BK${DateTime.now().millisecondsSinceEpoch}');
  }

  void _handleError(PaymentFailureResponse response) {
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message}'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _handleWallet(ExternalWalletResponse response) {}

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_paymentComplete,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Payment')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Amount display with breathing animation
              AnimatedBuilder(
                animation: _breathingController,
                builder: (context, child) {
                  final scale = 1.0 + (_breathingController.value * 0.025);
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('🪔', style: TextStyle(fontSize: 44)),
                      const SizedBox(height: 14),
                      Text(_poojaName,
                          style: AppTextStyles.headingMedium
                              .copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('with $_panditName',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70)),
                      const SizedBox(height: 20),
                      Text(
                        '₹$_amount',
                        style: AppTextStyles.priceLarge.copyWith(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800),
                      ),
                      Text('Total Amount',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Payment methods
              Text('Choose Payment Method',
                  style: AppTextStyles.headingSmall),
              const SizedBox(height: 16),

              _PaymentOption(
                title: 'UPI / Google Pay / PhonePe',
                subtitle: 'Instant payment via UPI apps',
                icon: '📱',
                index: 0,
                onTap: _isProcessing ? null : () => _openRazorpay(method: 'upi'),
              ),
              const SizedBox(height: 12),
              _PaymentOption(
                title: 'Credit / Debit Card',
                subtitle: 'Visa, Mastercard, Rupay',
                icon: '💳',
                index: 1,
                onTap: _isProcessing ? null : () => _openRazorpay(method: 'card'),
              ),
              const SizedBox(height: 12),
              _PaymentOption(
                title: 'Net Banking',
                subtitle: 'All major banks supported',
                icon: '🏦',
                index: 2,
                onTap: _isProcessing ? null : () => _openRazorpay(method: 'netbanking'),
              ),
              const SizedBox(height: 28),

              // Pay button
              ElevatedButton(
                onPressed: _isProcessing ? null : () => _openRazorpay(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text('Pay ₹$_amount Securely',
                              style: AppTextStyles.buttonText),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.security_rounded,
                      size: 14, color: AppColors.success),
                  const SizedBox(width: 5),
                  Text('256-bit SSL encrypted payment',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.success)),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}


class _PaymentOption extends StatefulWidget {
  final String title;
  final String subtitle;
  final String icon;
  final int index;
  final VoidCallback? onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.index,
    required this.onTap,
  });

  @override
  State<_PaymentOption> createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<_PaymentOption> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onTap != null) _scaleController.forward();
      },
      onTapUp: (_) {
        if (widget.onTap != null) {
          _scaleController.reverse();
          HapticFeedback.lightImpact();
          widget.onTap!();
        }
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) => Transform.scale(
          scale: 1.0 - _scaleController.value,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFFFF8F0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(widget.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: AppTextStyles.labelLarge),
                    Text(widget.subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 80 * widget.index)).slideY(begin: 0.2),
    );
  }
}
