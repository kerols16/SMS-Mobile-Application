import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/data/models/admin_student_model.dart';
import 'package:school_test/features/admin/data/models/classroom_model.dart';
import 'package:school_test/features/admin/data/models/attendance_model.dart';

class CreateAttendanceSheet extends StatefulWidget {
  final AdminLoaded state;
  final bool isSuperAdmin;
  final AdminCubit cubit;

  const CreateAttendanceSheet({
    super.key,
    required this.state,
    required this.isSuperAdmin,
    required this.cubit,
  });

  @override
  State<CreateAttendanceSheet> createState() => _CreateAttendanceSheetState();
}

class _CreateAttendanceSheetState extends State<CreateAttendanceSheet> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedStudentId;
  int? _selectedClassroomId;
  DateTime? _selectedDate;
  String _selectedStatus = 'present';
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final data = {
        'student_id': _selectedStudentId,
        'classroom_id': _selectedClassroomId,
        'date': _selectedDate!.toIso8601String().split('T').first,
        'status': _selectedStatus,
        if (_notesController.text.isNotEmpty) 'notes': _notesController.text,
      };
      widget.cubit.createAttendance(data);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = widget.state.students;
    final classrooms = widget.state.classrooms;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Attendance Record',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Student *'),
              value: _selectedStudentId,
              items: students
                  .map(
                    (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedStudentId = v),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Classroom *'),
              value: _selectedClassroomId,
              items: classrooms
                  .map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedClassroomId = v),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: 'Date *',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              controller: TextEditingController(
                text: _selectedDate != null
                    ? _selectedDate!.toIso8601String().split('T').first
                    : '',
              ),
              validator: (v) =>
                  _selectedDate == null ? 'Please select a date' : null,
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Status *'),
              value: _selectedStatus,
              items: ['present', 'absent', 'late', 'excused']
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}