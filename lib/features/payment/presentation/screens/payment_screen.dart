import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  bool _isProcessing = false;

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
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _openRazorpay() async {
    setState(() => _isProcessing = true);

    try {
      // Step 1: Create Razorpay order on the server (keeps secret key off device)
      final response = await Supabase.instance.client.functions.invoke(
        'create-razorpay-order',
        body: {
          'amount': _amount * 100, // Razorpay takes paise, not rupees
          'currency': AppConstants.razorpayCurrency,
          'receipt': 'rcpt_${DateTime.now().millisecondsSinceEpoch}',
          'notes': {'pooja': _poojaName, 'pandit': _panditName},
        },
      );

      final orderId = response.data['order_id'] as String?;
      if (orderId == null) throw Exception('Failed to create order');

      // Step 2: Open Razorpay checkout with the server-created order_id
      final options = {
        'key': AppConstants.razorpayKeyId,     // Public key only — safe in app
        'order_id': orderId,                   // From server
        'amount': _amount * 100,
        'currency': AppConstants.razorpayCurrency,
        'name': AppConstants.appName,
        'description': '$_poojaName with $_panditName',
        'prefill': {
          'contact': _userPhone,
          'email': _userEmail,
        },
        'theme': {'color': '#D4600A'},
      };
      _razorpay.open(options);
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not initiate payment: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    setState(() => _isProcessing = false);
    // TODO: Save response.orderId, response.paymentId, response.signature to Supabase payments table
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Amount display
            Container(
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
            const SizedBox(height: 28),

            // Payment methods
            Text('Choose Payment Method',
                style: AppTextStyles.headingSmall),
            const SizedBox(height: 16),

            _PaymentOption(
              title: 'UPI / Google Pay / PhonePe',
              subtitle: 'Instant payment via UPI apps',
              icon: '📱',
              onTap: _openRazorpay,
            ),
            const SizedBox(height: 12),
            _PaymentOption(
              title: 'Credit / Debit Card',
              subtitle: 'Visa, Mastercard, Rupay',
              icon: '💳',
              onTap: _openRazorpay,
            ),
            const SizedBox(height: 12),
            _PaymentOption(
              title: 'Net Banking',
              subtitle: 'All major banks supported',
              icon: '🏦',
              onTap: _openRazorpay,
            ),
            const SizedBox(height: 28),

            // Pay button
            ElevatedButton(
              onPressed: _isProcessing ? null : _openRazorpay,
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
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLarge),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
