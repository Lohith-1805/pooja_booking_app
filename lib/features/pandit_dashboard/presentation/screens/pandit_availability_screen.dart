import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
class PanditAvailabilityScreen extends StatefulWidget {
  const PanditAvailabilityScreen({super.key});
  @override State<PanditAvailabilityScreen> createState() => _State();
}
class _State extends State<PanditAvailabilityScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  final _slots = ['Morning (6 AM - 12 PM)', 'Afternoon (12 PM - 5 PM)', 'Evening (5 PM - 9 PM)'];
  final Set<String> _activeSlots = {'Morning (6 AM - 12 PM)'};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Manage Availability')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(color: AppColors.surface,
              borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.borderLight)),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 90)),
              focusedDay: _focused,
              selectedDayPredicate: (d) => _selected != null && d == _selected,
              onDaySelected: (s, f) => setState(() { _selected = s; _focused = f; }),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(color: AppColors.sacred, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), shape: BoxShape.circle)),
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            ),
          ),
          const SizedBox(height: 20),
          Text('Time Slots', style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          ..._slots.map((slot) => CheckboxListTile(
            value: _activeSlots.contains(slot),
            onChanged: (v) => setState(() => v! ? _activeSlots.add(slot) : _activeSlots.remove(slot)),
            title: Text(slot, style: AppTextStyles.bodyLarge),
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tileColor: AppColors.surface,
          )),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () {},
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: Text('Save Availability', style: AppTextStyles.buttonText)),
        ]),
      ),
    );
  }
}
