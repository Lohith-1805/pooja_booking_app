import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/temple_model.dart';

class PoojaSlotScreen extends StatefulWidget {
  final String templeId;
  const PoojaSlotScreen({super.key, required this.templeId});

  @override
  State<PoojaSlotScreen> createState() => _PoojaSlotScreenState();
}

class _PoojaSlotScreenState extends State<PoojaSlotScreen> {
  DateTime _selectedDay = DateTime.now().add(const Duration(days: 1));
  DateTime _focusedDay = DateTime.now();
  String? _selectedSlot;

  final List<Map<String, String>> _slots = [
    {'label': 'Morning', 'time': '9:00 AM - 11:00 AM'},
    {'label': 'Afternoon', 'time': '1:00 PM - 3:00 PM'},
    {'label': 'Evening', 'time': '6:00 PM - 8:00 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Book Pooja at Home')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Date & Time', style: AppTextStyles.headingSmall),
              const SizedBox(height: 14),

              // Calendar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 60)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) =>
                      isSameDay(_selectedDay, day),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                      _selectedSlot = null;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w600),
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    weekendTextStyle:
                        const TextStyle(color: AppColors.sacred),
                    defaultTextStyle:
                        TextStyle(color: AppColors.textPrimary),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: AppTextStyles.headingSmall,
                    leftChevronIcon: const Icon(Icons.chevron_left_rounded,
                        color: AppColors.primary),
                    rightChevronIcon: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Time slots
              Text('Select Time Slot', style: AppTextStyles.headingSmall),
              const SizedBox(height: 12),
              ..._slots.map((slot) => _SlotTile(
                    label: slot['label']!,
                    time: slot['time']!,
                    isSelected: _selectedSlot == slot['label'],
                    onTap: () =>
                        setState(() => _selectedSlot = slot['label']),
                  )),
              const SizedBox(height: 24),

              // Pooja details fields
              Text('Enter Pooja Details',
                  style: AppTextStyles.headingSmall),
              const SizedBox(height: 14),
              _DropdownField(
                hint: 'Select Gotram',
                icon: Icons.family_restroom_rounded,
              ),
              const SizedBox(height: 12),
              _DropdownField(
                hint: 'Select Nakshatram',
                icon: Icons.star_rounded,
              ),
              const SizedBox(height: 12),
              _DropdownField(
                hint: 'Enter Address',
                icon: Icons.location_on_rounded,
              ),
              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: _selectedSlot == null
                    ? null
                    : () {
                        context.push(AppRoutes.bookingFlow, extra: {
                          'bookingType': 'temple',
                          'templeId': widget.templeId,
                          'date': _selectedDay.toIso8601String(),
                          'slot': _selectedSlot,
                        });
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Continue', style: AppTextStyles.buttonText),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  final String label;
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const _SlotTile({
    required this.label,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryExtraLight : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(label,
                style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary)),
            const SizedBox(width: 8),
            Text(time,
                style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected
                        ? AppColors.primaryDark
                        : AppColors.textHint)),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                color: isSelected ? AppColors.primary : AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String hint;
  final IconData icon;

  const _DropdownField({required this.hint, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(hint, style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint)),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textHint),
        ],
      ),
    );
  }
}
