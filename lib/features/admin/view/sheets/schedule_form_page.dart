// schedule_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/data/models/classroom_model.dart';
import 'package:school_test/features/admin/data/models/schedule_model.dart';
import 'package:school_test/features/admin/data/models/subject_model.dart';
import 'package:school_test/features/admin/data/models/admin_teacher_model.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/utils/admin_helper.dart';

class ScheduleFormPage extends StatefulWidget {
  final ScheduleModel? schedule;
  const ScheduleFormPage({super.key, this.schedule});

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();
  int? _classroomId, _subjectId, _teacherId;
  String _dayOfWeek = 'monday';
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  String _semester = 'first';
  final _academicYearCtrl = TextEditingController(text: '2024-2025');
  bool _isActive = true;
  bool _isLoading = false;

  List<ClassroomModel> _classrooms = [];
  List<SubjectModel> _subjects = [];
  List<AdminTeacherModel> _teachers = [];

  // Helper: check if string matches HH:MM (24h)
  bool _isValidTime(String time) {
    final regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    return regex.hasMatch(time);
  }

  String? _validateStartTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Start time is required';
    }
    final trimmed = value.trim();
    if (!_isValidTime(trimmed)) {
      return 'Use format HH:MM (e.g., 08:30, 14:00)';
    }
    return null;
  }

  String? _validateEndTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'End time is required';
    }
    final trimmed = value.trim();
    if (!_isValidTime(trimmed)) {
      return 'Use format HH:MM (e.g., 09:45, 16:00)';
    }
    // Optional: check that end time > start time
    if (_startCtrl.text.trim().isNotEmpty && _isValidTime(_startCtrl.text.trim())) {
      final startMinutes = _timeToMinutes(_startCtrl.text.trim());
      final endMinutes = _timeToMinutes(trimmed);
      if (endMinutes <= startMinutes) {
        return 'End time must be after start time';
      }
    }
    return null;
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  // Show time picker and update controller
  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTimeFromController(controller),
      builder: (context, child) => child!,
    );
    if (picked != null) {
      final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      controller.text = formatted;
      // Trigger validation again
      _formKey.currentState?.validate();
    }
  }

  TimeOfDay _parseTimeFromController(TextEditingController controller) {
    final text = controller.text.trim();
    if (_isValidTime(text)) {
      final parts = text.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return TimeOfDay.now();
  }

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    if (s != null) {
      _classroomId = s.classroomId;
      _subjectId = s.subjectId;
      _teacherId = s.teacherId;
      _dayOfWeek = s.dayOfWeek;
      _startCtrl.text = s.startTime;
      _endCtrl.text = s.endTime;
      _roomCtrl.text = s.roomNumber;
      _semester = s.semester;
      _academicYearCtrl.text = s.academicYear;
      _isActive = s.isActive;
    }
    final cubit = context.read<AdminCubit>();
    final state = cubit.state;
    if (state is AdminLoaded) {
      _classrooms = state.classrooms;
      _subjects = state.subjects;
      _teachers = state.teachers;
    } else {
      cubit.loadDashboard();
    }
  }

  @override
  void dispose() {
    _startCtrl.dispose();
    _endCtrl.dispose();
    _roomCtrl.dispose();
    _academicYearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true);
        } else if (state is AdminOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
          setState(() => _isLoading = false);
        }
      },
      child: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoaded) {
            _classrooms = state.classrooms;
            _subjects = state.subjects;
            _teachers = state.teachers;
          }
          final isLoadingData = state is AdminLoading && _classrooms.isEmpty;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.schedule == null ? 'Create Schedule' : 'Edit Schedule'),
              backgroundColor: AdminHelper.roleColor('schedule'),
              foregroundColor: Colors.white,
              actions: [
                if (!_isLoading)
                  TextButton(
                    onPressed: _submit,
                    child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  )
              ],
            ),
            body: isLoadingData
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          DropdownButtonFormField<int>(
                            decoration: const InputDecoration(labelText: 'Classroom *'),
                            value: _classroomId,
                            items: _classrooms.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                            onChanged: (v) => setState(() => _classroomId = v),
                            validator: (v) => v == null ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            decoration: const InputDecoration(labelText: 'Subject *'),
                            value: _subjectId,
                            items: _subjects.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                            onChanged: (v) => setState(() => _subjectId = v),
                            validator: (v) => v == null ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            decoration: const InputDecoration(labelText: 'Teacher *'),
                            value: _teacherId,
                            items: _teachers.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))).toList(),
                            onChanged: (v) => setState(() => _teacherId = v),
                            validator: (v) => v == null ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'Day of Week'),
                            value: _dayOfWeek,
                            items: const [
                              DropdownMenuItem(value: 'monday', child: Text('Monday')),
                              DropdownMenuItem(value: 'tuesday', child: Text('Tuesday')),
                              DropdownMenuItem(value: 'wednesday', child: Text('Wednesday')),
                              DropdownMenuItem(value: 'thursday', child: Text('Thursday')),
                              DropdownMenuItem(value: 'friday', child: Text('Friday')),
                              DropdownMenuItem(value: 'saturday', child: Text('Saturday')),
                              DropdownMenuItem(value: 'sunday', child: Text('Sunday')),
                            ],
                            onChanged: (v) => setState(() => _dayOfWeek = v!),
                          ),
                          const SizedBox(height: 16),
                          // Start Time field with picker & validation
                          TextFormField(
                            controller: _startCtrl,
                            decoration: InputDecoration(
                              labelText: 'Start Time (HH:MM) *',
                              border: const OutlineInputBorder(),
                              hintText: 'e.g., 08:30',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () => _selectTime(_startCtrl),
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                            validator: _validateStartTime,
                          ),
                          const SizedBox(height: 16),
                          // End Time field with picker & validation
                          TextFormField(
                            controller: _endCtrl,
                            decoration: InputDecoration(
                              labelText: 'End Time (HH:MM) *',
                              border: const OutlineInputBorder(),
                              hintText: 'e.g., 10:45',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () => _selectTime(_endCtrl),
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                            validator: _validateEndTime,
                          ),
                          const SizedBox(height: 16),
                          AdminHelper.buildTextField('Room Number', _roomCtrl),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'Semester'),
                            value: _semester,
                            items: const [
                              DropdownMenuItem(value: 'first', child: Text('First')),
                              DropdownMenuItem(value: 'second', child: Text('Second')),
                            ],
                            onChanged: (v) => setState(() => _semester = v!),
                          ),
                          const SizedBox(height: 16),
                          AdminHelper.buildTextField('Academic Year', _academicYearCtrl, isRequired: true),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Active'),
                            value: _isActive,
                            onChanged: (v) => setState(() => _isActive = v),
                            activeColor: AdminHelper.roleColor('schedule'),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AdminHelper.roleColor('schedule'),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(widget.schedule == null ? 'Create' : 'Update'),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_classroomId == null || _subjectId == null || _teacherId == null) return;
    setState(() => _isLoading = true);
    final data = {
      'classroom_id': _classroomId,
      'subject_id': _subjectId,
      'teacher_id': _teacherId,
      'day_of_week': _dayOfWeek,
      'start_time': _startCtrl.text,
      'end_time': _endCtrl.text,
      'room_number': _roomCtrl.text,
      'semester': _semester,
      'academic_year': _academicYearCtrl.text,
      'is_active': _isActive,
    };
    final cubit = context.read<AdminCubit>();
    if (widget.schedule == null) {
      await cubit.createSchedule(data);
    } else {
      await cubit.updateSchedule(widget.schedule!.id, data);
    }
  }
}