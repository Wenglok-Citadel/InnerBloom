import 'package:flutter/material.dart';
import 'package:inner_bloom_app/core/utils/time_slots.dart';
import 'package:inner_bloom_app/features/therapist/presentation/widgets/time_bottom_sheet.dart';

class BookSessionPage extends StatefulWidget {
  final String therapistName;

  const BookSessionPage({super.key, required this.therapistName});

  @override
  State<BookSessionPage> createState() => _BookSessionPageState();
}

class _BookSessionPageState extends State<BookSessionPage> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;

  late final List<String> _timeSlots;

  @override
  void initState() {
    super.initState();

    _timeSlots = generateTimeSlots(
      start: const TimeOfDay(hour: 10, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
      intervalMinutes: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Session'),
        foregroundColor: const Color(0xFF2F5C52),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7FBF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),

              _buildDatePicker(context),
              const SizedBox(height: 20),

              _buildTimePicker(context),
              const Spacer(),

              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Session with ${widget.therapistName}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2F5C52),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );

        if (date != null) {
          setState(() {
            _selectedDate = date;
            _selectedTime = null;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(width: 10),
            Text(
              formatDate(_selectedDate),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final selected = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              builder: (_) => TimeBottomSheet(
                timeSlots: _timeSlots,
                selectedTime: _selectedTime,
              ),
            );

            if (selected != null) {
              setState(() => _selectedTime = selected);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Text(
                  _selectedTime ?? 'Select a time',
                  style: TextStyle(
                    color: _selectedTime == null ? Colors.grey : Colors.black87,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _selectedTime == null ? null : _onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F5C52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Confirm Booking',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _onConfirm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Session Booked 🎉'),
        content: Text(
          'Your session is scheduled on\n'
          '${formatDate(_selectedDate)} at $_selectedTime',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
