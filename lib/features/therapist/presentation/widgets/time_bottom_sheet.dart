import 'package:flutter/material.dart';

class TimeBottomSheet extends StatelessWidget {
  final List<String> timeSlots;
  final String? selectedTime;

  const TimeBottomSheet({
    super.key,
    required this.timeSlots,
    this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.35,
      maxChildSize: 0.7,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFDFEFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: timeSlots.length,
                  itemBuilder: (_, index) {
                    final time = timeSlots[index];
                    final isSelected = time == selectedTime;

                    return ListTile(
                      title: Text(time),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Color(0xFF91B6A9))
                          : null,
                      onTap: () => Navigator.pop(context, time),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
