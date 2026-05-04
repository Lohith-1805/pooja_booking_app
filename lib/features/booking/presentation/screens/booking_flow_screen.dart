import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';

class BookingFlowScreen extends StatefulWidget {
  final Map<String, dynamic> bookingArgs;
  const BookingFlowScreen({super.key, required this.bookingArgs});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _step = 0;
  String? _selectedGotram;
  String? _selectedNakshatram;
  final _addressController = TextEditingController();
  final _specialController = TextEditingController();

  String get _poojaName =>
      widget.bookingArgs['poojaName'] as String? ?? 'Pooja';
  String get _panditName =>
      widget.bookingArgs['panditName'] as String? ?? 'Pandit';
  int get _basePrice =>
      widget.bookingArgs['basePrice'] as int? ?? 2500;

  @override
  void dispose() {
    _addressController.dispose();
    _specialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Book $_poojaName'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              context.pop();
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: _buildProgressBar(),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final isStep2 = child.key == const ValueKey('step2');
          final slideAnim = Tween<Offset>(
            begin: Offset(0, isStep2 ? 0.05 : -0.05),
            end: Offset.zero,
          ).animate(animation);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slideAnim,
              child: child,
            ),
          );
        },
        child: _step == 0 ? _buildStep1() : _buildStep2(),
      ),
    );
  }

  Widget _buildProgressBar() {
    final disableAnim = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    final targetValue = (_step + 1) / 2;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.5, end: targetValue),
      duration: disableAnim ? Duration.zero : const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: AppColors.borderLight,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          minHeight: 4,
        );
      },
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      key: const ValueKey('step1'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Text('🪔', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_poojaName,
                        style: AppTextStyles.headingSmall
                            .copyWith(color: Colors.white)),
                    Text('with $_panditName',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('Devotee Details', style: AppTextStyles.headingSmall),
          const SizedBox(height: 16),

          // Gotram
          Text('Gotram', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGotram,
                isExpanded: true,
                dropdownColor: AppColors.surface,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint),
                hint: Text('Select Gotram',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textHint)),
                items: AppConstants.gotrams
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedGotram = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Nakshatram
          Text('Nakshatram (Birth Star)', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedNakshatram,
                isExpanded: true,
                dropdownColor: AppColors.surface,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint),
                hint: Text('Select Nakshatram',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textHint)),
                items: AppConstants.nakshatrams
                    .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                    .toList(),
                onChanged: (val) {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedNakshatram = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Address
          Text('Address', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter full address with landmark...',
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textHint),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, top: 12),
                child: Icon(Icons.location_on_rounded,
                    color: AppColors.primary, size: 20),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Special instructions
          Text('Special Instructions (Optional)',
              style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _specialController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Any special requirements...',
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textHint),
            ),
          ),
          const SizedBox(height: 32),

          _AnimatedActionButton(
            label: 'Continue',
            onTap: () => setState(() => _step = 1),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      key: const ValueKey('step2'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Summary', style: AppTextStyles.headingMedium),
          const SizedBox(height: 20),

          // Summary card with 3D tilt
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-0.02),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFFFF8F0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.04),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with lotus
                  Row(
                    children: [
                      const Text('🪔', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_poojaName,
                              style: AppTextStyles.headingSmall),
                          Text('with $_panditName',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(color: AppColors.divider),
                  ),

                  // Details
                  _SummaryRow(
                      icon: Icons.calendar_month_rounded,
                      label: 'Date',
                      value: '18 Feb 2025'),
                  const SizedBox(height: 10),
                  _SummaryRow(
                      icon: Icons.schedule_rounded,
                      label: 'Time',
                      value: '9:00 AM - 11:00 AM'),
                  const SizedBox(height: 10),
                  _SummaryRow(
                      icon: Icons.auto_awesome_rounded,
                      label: 'Gotram',
                      value: _selectedGotram ?? 'Not specified'),
                  const SizedBox(height: 10),
                  _SummaryRow(
                      icon: Icons.location_on_rounded,
                      label: 'Address',
                      value: _addressController.text.isNotEmpty
                          ? _addressController.text
                          : '123, Jubilee Hills, Hyderabad'),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(color: AppColors.divider),
                  ),

                  // Price breakdown
                  _PriceRow(
                      label: 'Pooja Charges',
                      amount: _basePrice),
                  const SizedBox(height: 8),
                  _PriceRow(
                      label: 'Platform Fee', amount: (_basePrice * 0.05).toInt()),
                  const SizedBox(height: 8),
                  _PriceRow(label: 'Taxes', amount: (_basePrice * 0.05).toInt()),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: AppColors.divider),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount',
                          style: AppTextStyles.headingSmall),
                      Text(
                        '₹${(_basePrice * 1.1).toInt()}',
                        style: AppTextStyles.priceLarge
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Proceed to pay
          _AnimatedActionButton(
            label: 'Proceed to Pay',
            icon: Icons.lock_rounded,
            onTap: () {
              context.push(AppRoutes.payment, extra: {
                'amount': (_basePrice * 1.1).toInt(),
                'panditName': _panditName,
                'poojaName': _poojaName,
              });
            },
          ),
          const SizedBox(height: 12),

          // Help row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.help_outline_rounded, size: 16),
                label: const Text('Need Help?'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone_rounded, size: 16),
                label: Text('Call $_panditName'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _AnimatedActionButton({
    required this.label,
    this.icon,
    required this.onTap,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
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
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) => Transform.scale(
          scale: 1.0 - _scaleController.value,
          child: child,
        ),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(widget.label, style: AppTextStyles.buttonText),
            ],
          ),
        ),
      ),
    );
  }
}


class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text('$label: ', style: AppTextStyles.bodySmall),
        Expanded(
          child: Text(value,
              style: AppTextStyles.bodySmall
                  .copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
              textAlign: TextAlign.right),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final int amount;

  const _PriceRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text('₹$amount', style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }
}
