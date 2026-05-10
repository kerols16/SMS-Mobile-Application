// schedules_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/pages/schedule_details_page.dart';
import 'package:school_test/features/admin/view/sheets/schedule_form_page.dart';

class SchedulesListPage extends StatelessWidget {
  const SchedulesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleFormPage())).then((_) => cubit.loadDashboard()),
          ),
        ],
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoaded) {
            final schedules = state.schedules;
            if (schedules.isEmpty) {
              return const Center(child: Text('No schedules found'));
            }
            return ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (_, i) {
                final s = schedules[i];
                return ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text('${s.classroom?['name'] ?? 'Class'} - ${s.subject?['name'] ?? 'Subject'}'),
                  subtitle: Text('${s.dayOfWeek.toUpperCase()} ${s.startTime}-${s.endTime}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDelete(context, cubit, s.id, s.dayOfWeek),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ScheduleDetailsPage(scheduleId: s.id),
                  )),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, AdminCubit cubit, int id, String day) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Schedule'),
        content: Text('Delete schedule on $day?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteSchedule(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}