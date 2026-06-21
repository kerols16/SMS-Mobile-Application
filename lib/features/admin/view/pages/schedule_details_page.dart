// schedule_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/data/models/classroom_model.dart';
import 'package:school_test/features/admin/data/models/schedule_model.dart';
import 'package:school_test/features/admin/data/models/subject_model.dart';
import 'package:school_test/features/admin/data/models/admin_teacher_model.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/utils/admin_helper.dart';

class ScheduleDetailsPage extends StatefulWidget {
  final int scheduleId;
  const ScheduleDetailsPage({super.key, required this.scheduleId});

  @override
  State<ScheduleDetailsPage> createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
  late final AdminCubit _cubit;
  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();

  int? _classroomId, _subjectId, _teacherId;
  String _dayOfWeek = 'monday';
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  String _semester = 'first';
  final _academicYearCtrl = TextEditingController();
  bool _isActive = true;

  List<ClassroomModel> _classrooms = [];
  List<SubjectModel> _subjects = [];
  List<AdminTeacherModel> _teachers = [];

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AdminCubit>();
    _cubit.getScheduleById(widget.scheduleId);
    final state = _cubit.state;
    if (state is AdminLoaded) {
      _classrooms = state.classrooms;
      _subjects = state.subjects;
      _teachers = state.teachers;
    } else {
      _cubit.loadDashboard();
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

  void _populateControllers(ScheduleModel s) {
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

  void _saveChanges(ScheduleModel s) {
    if (!_formKey.currentState!.validate()) return;
    if (_classroomId == null || _subjectId == null || _teacherId == null) return;
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
    _cubit.updateSchedule(s.id, data);
    setState(() => _isEditMode = false);
  }

  void _deleteSchedule(ScheduleModel s) {
    AdminHelper.confirmDelete(context, 'Schedule on ${s.dayOfWeek} at ${s.startTime}', () {
      _cubit.deleteSchedule(s.id).then((_) {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
          _cubit.getScheduleById(widget.scheduleId);
        } else if (state is AdminOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is AdminLoaded) {
          setState(() {
            _classrooms = state.classrooms;
            _subjects = state.subjects;
            _teachers = state.teachers;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const Text('Schedule Details'),
          backgroundColor: AdminHelper.roleColor('schedule'),
          foregroundColor: Colors.white,
          actions: [
            if (!_isEditMode)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => setState(() => _isEditMode = true),
              ),
            if (!_isEditMode)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  final state = _cubit.state;
                  if (state is ScheduleLoaded) _deleteSchedule(state.schedule);
                },
              ),
            if (_isEditMode)
              TextButton(
                onPressed: () {
                  final state = _cubit.state;
                  if (state is ScheduleLoaded) _saveChanges(state.schedule);
                },
                child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            if (_isEditMode)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _isEditMode = false),
              ),
          ],
        ),
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading && state is! AdminLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ScheduleLoaded) {
              final s = state.schedule;
              if (_isEditMode && _startCtrl.text.isEmpty) _populateControllers(s);
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _isEditMode ? _buildEditForm(s) : _buildViewMode(s),
              );
            }
            if (state is AdminOperationError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildViewMode(ScheduleModel s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Schedule Info', [
          _infoRow('Classroom', s.classroom?['name'] ?? 'N/A'),
          _infoRow('Subject', s.subject?['name'] ?? 'N/A'),
          _infoRow('Teacher', s.teacher?['name'] ?? 'N/A'),
          _infoRow('Day', s.dayOfWeek.toUpperCase()),
          _infoRow('Time', '${s.startTime} - ${s.endTime}'),
          _infoRow('Room', s.roomNumber.isEmpty ? 'N/A' : s.roomNumber),
          _infoRow('Semester', s.semester == 'first' ? 'First' : 'Second'),
          _infoRow('Academic Year', s.academicYear),
          _infoRow('Status', s.isActive ? 'Active' : 'Inactive'),
        ]),
      ],
    );
  }

  Widget _buildEditForm(ScheduleModel s) {
    return Form(
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
            items: _subjects.map((sub) => DropdownMenuItem(value: sub.id, child: Text(sub.name))).toList(),
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
          AdminHelper.buildTextField('Start Time (HH:MM)', _startCtrl, isRequired: true),
          const SizedBox(height: 16),
          AdminHelper.buildTextField('End Time (HH:MM)', _endCtrl, isRequired: true),
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
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: AdminHelper.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const Divider(height: 1),
          ...children.map((child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: child,
          )),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
        ),
        Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF374151)))),
      ],
    );
  }
}