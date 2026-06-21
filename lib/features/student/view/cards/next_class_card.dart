import 'package:flutter/material.dart';
import '../../../../features/student/data/models/student_schedule_model.dart';

class NextClassCard extends StatelessWidget {
  final StudentScheduleModel? schedule;
  const NextClassCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    if (schedule == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.purpleAccent],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'No upcoming classes',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.purpleAccent],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Next Class',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                schedule!.endTime ,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            schedule!.subjectName.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                schedule!.teacherName ?? '',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.location_on, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                schedule!.roomNumber ?? '',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                schedule!.startTime ,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}