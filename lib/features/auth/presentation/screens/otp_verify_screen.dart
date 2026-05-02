import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phone;
  const OtpVerifyScreen({super.key, required this.phone});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  String _otp = '';
  bool _isLoading = false;
  int _resendSeconds = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendSeconds > 0) _resendSeconds--;
      });
      return _resendSeconds > 0;
    });
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) return;
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulated
      // TODO: Verify with Supabase
      if (mounted) context.go(AppRoutes.roleSelect);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maskedPhone = widget.phone.length > 5
        ? '${widget.phone.substring(0, widget.phone.length - 5)}*****'
        : widget.phone;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryExtraLight,
                  borderRadius: BorderRadius.circular(22),
                ),
                child:
                    const Center(child: Text('📲', style: TextStyle(fontSize: 40))),
              ),
            ),
            const SizedBox(height: 28),
            Text('Enter OTP', style: AppTextStyles.headingLarge),
            const SizedBox(height: 8),
            Text(
              'We sent a 6-digit OTP to\n$maskedPhone',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
            ),
            const SizedBox(height: 36),

            // OTP field
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (val) => setState(() => _otp = val),
              onCompleted: (val) {
                setState(() => _otp = val);
                _verifyOtp();
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 56,
                fieldWidth: 48,
                activeFillColor: AppColors.surface,
                inactiveFillColor: AppColors.surface,
                selectedFillColor: AppColors.primaryExtraLight,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.borderLight,
                selectedColor: AppColors.primary,
              ),
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              textStyle: AppTextStyles.headingMedium,
              cursorColor: AppColors.primary,
              animationType: AnimationType.fade,
            ),
            const SizedBox(height: 24),

            // Resend
            Center(
              child: _resendSeconds > 0
                  ? Text(
                      'Resend OTP in ${_resendSeconds}s',
                      style: AppTextStyles.labelMedium,
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() => _resendSeconds = 30);
                        _startResendTimer();
                      },
                      child: Text('Resend OTP',
                          style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ),
            ),
            const SizedBox(height: 32),

            // Verify button
            ElevatedButton(
              onPressed: (_otp.length == 6 && !_isLoading) ? _verifyOtp : null,
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
                  : Text('Verify & Continue', style: AppTextStyles.buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
