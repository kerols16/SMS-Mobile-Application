// classroom_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/data/models/classroom_model.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/utils/admin_helper.dart';

class ClassroomDetailsPage extends StatefulWidget {
  final int classroomId;
  final AdminLoaded allData;
  const ClassroomDetailsPage({
    super.key,
    required this.classroomId,
    required this.allData,
  });

  @override
  State<ClassroomDetailsPage> createState() => _ClassroomDetailsPageState();
}

class _ClassroomDetailsPageState extends State<ClassroomDetailsPage> {
  late final AdminCubit _cubit;
  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _gradeCtrl;
  late final TextEditingController _capacityCtrl;
  late final TextEditingController _academicYearCtrl;
  late final TextEditingController _descCtrl;
  bool _isActive = true;

  String _getStudentName(Map<String, dynamic> student) {
    debugPrint('🔍 student keys: ${student.keys.toList()}');
    debugPrint('🔍 student user: ${student['user']}');

    final user = student['user'];
    if (user is Map<String, dynamic> && user.containsKey('name')) {
      return user['name'];
    }
    return student['name'] ?? student['student_id'] ?? 'Unknown';
  }

  String _getTeacherName(Map<String, dynamic> teacher) {
    final user = teacher['user'];
    if (user is Map<String, dynamic> && user.containsKey('name')) {
      return user['name'];
    }
    return teacher['name'] ?? teacher['teacher_id'] ?? 'Unknown';
  }

  String _getSubjectName(Map<String, dynamic> subject) {
    return subject['name'] ?? 'Subject';
  }

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AdminCubit>();
    _cubit.getClassroomById(widget.classroomId);
    _nameCtrl = TextEditingController();
    _gradeCtrl = TextEditingController();
    _capacityCtrl = TextEditingController();
    _academicYearCtrl = TextEditingController();
    _descCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _gradeCtrl.dispose();
    _capacityCtrl.dispose();
    _academicYearCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _populateControllers(ClassroomModel c) {
    _nameCtrl.text = c.name;
    _gradeCtrl.text = c.gradeLevel;
    _capacityCtrl.text = c.capacity.toString();
    _academicYearCtrl.text = c.academicYear;
    _descCtrl.text = c.description ?? '';
    _isActive = c.isActive;
  }

  void _saveChanges(ClassroomModel c) {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'name': _nameCtrl.text.trim(),
      'grade_level': _gradeCtrl.text.trim(),
      'capacity': int.tryParse(_capacityCtrl.text.trim()) ?? 0,
      'academic_year': _academicYearCtrl.text.trim(),
      'description': _descCtrl.text.trim().isEmpty
          ? null
          : _descCtrl.text.trim(),
      'is_active': _isActive,
    };
    _cubit.updateClassroom(c.id, data);
    setState(() => _isEditMode = false);
  }

  void _deleteClassroom(ClassroomModel c) {
    AdminHelper.confirmDelete(context, c.name, () {
      _cubit.deleteClassroom(c.id).then((_) {
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
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          _cubit.getClassroomById(widget.classroomId);
        } else if (state is AdminOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const Text('Classroom Details'),
          backgroundColor: AdminHelper.roleColor('classroom'),
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
                  if (state is ClassroomLoaded) {
                    _deleteClassroom(state.classroom);
                  }
                },
              ),
            if (_isEditMode)
              TextButton(
                onPressed: () {
                  final state = _cubit.state;
                  if (state is ClassroomLoaded) _saveChanges(state.classroom);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
            if (state is AdminLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ClassroomLoaded) {
              final c = state.classroom;
              if (_isEditMode && _nameCtrl.text.isEmpty)
                _populateControllers(c);
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _isEditMode ? _buildEditForm(c) : _buildViewMode(c),
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

  // ------------------ الوضع العادي (العرض والإدارة) ------------------
  Widget _buildViewMode(ClassroomModel c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('General Info', [
          _infoRow('Name', c.name),
          _infoRow('Grade Level', c.gradeLevel),
          _infoRow('Capacity', c.capacity.toString()),
          _infoRow('Academic Year', c.academicYear),
          _infoRow('Status', c.isActive ? 'Active' : 'Inactive'),
          if (c.description != null && c.description!.isNotEmpty)
            _infoRow('Description', c.description!),
        ]),
        const SizedBox(height: 20),
        // Students section
        _buildManageableSection(
          title: 'Students (${c.students.length})',
          items: c.students.cast<Map<String, dynamic>>(),
          itemLabel: (s) => _getStudentName(s),
          onRemove: (s) => _cubit.removeStudent(c.id, s['id'] as int),
          onAdd: () => _showEnrollStudentDialog(c),
          addButtonLabel: 'Enroll Student',
        ),
        const SizedBox(height: 20),
        // Teachers section with role dropdown (FIXED)
        _buildTeachersSection(c),
        const SizedBox(height: 20),
        // Subjects section with teacher dropdown and hours (FIXED)
        _buildSubjectsSectionEnhanced(c),
      ],
    );
  }

  // Generic manageable section (used for students)
  Widget _buildManageableSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required String Function(Map<String, dynamic>) itemLabel,
    required void Function(Map<String, dynamic>) onRemove,
    required VoidCallback onAdd,
    required String addButtonLabel,
  }) {
    return _buildInfoCard(title, [
      if (items.isEmpty)
        const Text('No items', style: TextStyle(color: Colors.grey)),
      ...items.map(
        (item) => Row(
          children: [
            Expanded(
              child: Text(
                itemLabel(item),
                style: const TextStyle(color: Color(0xFF374151)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => onRemove(item),
              tooltip: 'Remove',
            ),
          ],
        ),
      ),
      const Divider(height: 20),
      Center(
        child: ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
          ),
          child: Text(addButtonLabel),
        ),
      ),
    ]);
  }

  // Modified teachers section with role dropdown (FIXED)
  Widget _buildTeachersSection(ClassroomModel c) {
    return _buildInfoCard('Teachers (${c.teachers.length})', [
      if (c.teachers.isEmpty)
        const Text('No teachers assigned', style: TextStyle(color: Colors.grey)),
      ...c.teachers.map((teacher) {
        final teacherId = teacher['id'] as int;
        final currentRole = teacher['pivot']?['role'] ?? teacher['role'] ?? 'subject_teacher';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _getTeacherName(teacher),
                  style: const TextStyle(color: Color(0xFF374151)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2, // gives dropdown more room relative to the name field
                child: DropdownButtonFormField<String>(
                  value: currentRole,
                  isExpanded: true, // ✅ fills the available width
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'homeroom', child: Text('Homeroom')),
                    DropdownMenuItem(value: 'subject_teacher', child: Text('Subject Teacher')),
                    DropdownMenuItem(value: 'assistant', child: Text('Assistant')),
                  ],
                  onChanged: (newRole) {
                    if (newRole != null && newRole != currentRole) {
                      _cubit.changeTeacherRole(c.id, teacherId, newRole);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () => _cubit.removeTeacher(c.id, teacherId),
                tooltip: 'Remove',
              ),
            ],
          ),
        );
      }),
      const Divider(height: 20),
      Center(
        child: ElevatedButton(
          onPressed: () => _showAssignTeacherDialog(c),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
          ),
          child: const Text('Assign Teacher'),
        ),
      ),
    ]);
  }

  // Enhanced subjects section with teacher dropdown and hours field (FIXED)
  Widget _buildSubjectsSectionEnhanced(ClassroomModel c) {
    // Build a map of teacher names by id for quick lookup
    final teacherMap = {for (var t in widget.allData.teachers) t.id: t.name};

    return _buildInfoCard('Subjects (${c.subjects.length})', [
      if (c.subjects.isEmpty)
        const Text('No subjects assigned', style: TextStyle(color: Colors.grey)),
      ...c.subjects.map((subject) {
        final subjectId = subject['id'] as int;
        final pivot = subject['pivot'] as Map<String, dynamic>?;
        final currentTeacherId = pivot?['teacher_id'] as int?;
        final currentHours = pivot?['weekly_hours'] ?? 0;

        // Find available teachers (all teachers from allData)
        final availableTeachers = widget.allData.teachers;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Subject name + Remove button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _getSubjectName(subject),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => _cubit.removeSubject(c.id, subjectId),
                    tooltip: 'Remove',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row 2: Teacher dropdown + Hours field
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<int>(
                      value: currentTeacherId,
                      isExpanded: true, // ✅ prevents internal overflow
                      decoration: const InputDecoration(
                        labelText: 'Teacher',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      items: availableTeachers.map((teacher) {
                        return DropdownMenuItem(
                          value: teacher.id,
                          child: Text(teacher.name),
                        );
                      }).toList(),
                      onChanged: (newTeacherId) {
                        if (newTeacherId != null && newTeacherId != currentTeacherId) {
                          _cubit.changeSubjectTeacher(c.id, subjectId, newTeacherId);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      initialValue: currentHours.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Hours',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      onFieldSubmitted: (value) {
                        final hours = int.tryParse(value);
                        if (hours != null && hours != currentHours) {
                          _cubit.updateSubjectHours(c.id, subjectId, hours);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
            ],
          ),
        );
      }),
      Center(
        child: ElevatedButton(
          onPressed: () => _showAssignSubjectDialog(c),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
          ),
          child: const Text('Assign Subject'),
        ),
      ),
    ]);
  }

  // ------------------ دوال الإضافة (الحوارات) ------------------
  void _showEnrollStudentDialog(ClassroomModel c) {
    final enrolledIds = c.students.map<int>((s) => s['id'] as int).toSet();
    final availableStudents = widget.allData.students
        .where((s) => !enrolledIds.contains(s.id))
        .toList();

    if (availableStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No students available to enroll'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    int? selectedStudentId;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Enroll Student'),
          content: DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Select Student'),
            items: availableStudents.map((s) {
              return DropdownMenuItem(
                value: s.id,
                child: Text('${s.name} (${s.studentId})'),
              );
            }).toList(),
            onChanged: (value) =>
                setStateDialog(() => selectedStudentId = value),
            validator: (v) => v == null ? 'Please select a student' : null,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedStudentId != null) {
                  _cubit.enrollStudent(c.id, selectedStudentId!);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Enroll'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignTeacherDialog(ClassroomModel c) {
    final assignedIds = c.teachers.map<int>((t) => t['id'] as int).toSet();
    final availableTeachers = widget.allData.teachers
        .where((t) => !assignedIds.contains(t.id))
        .toList();

    if (availableTeachers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No teachers available to assign'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    int? selectedTeacherId;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Assign Teacher'),
          content: DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'Select Teacher'),
            items: availableTeachers.map((t) {
              return DropdownMenuItem(
                value: t.id,
                child: Text('${t.name} (${t.teacherId})'),
              );
            }).toList(),
            onChanged: (value) =>
                setStateDialog(() => selectedTeacherId = value),
            validator: (v) => v == null ? 'Please select a teacher' : null,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedTeacherId != null) {
                  _cubit.assignTeacher(c.id, selectedTeacherId!);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignSubjectDialog(ClassroomModel c) {
    final assignedSubjectIds = c.subjects
        .map<int>((s) => s['id'] as int)
        .toSet();
    final availableSubjects = widget.allData.subjects
        .where((sub) => !assignedSubjectIds.contains(sub.id))
        .toList();

    if (availableSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No subjects available to assign'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final teachers = widget.allData.teachers;

    int? selectedSubjectId;
    int? selectedTeacherId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Assign Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Select Subject'),
                items: availableSubjects.map((sub) {
                  return DropdownMenuItem(
                    value: sub.id,
                    child: Text('${sub.name} (${sub.code})'),
                  );
                }).toList(),
                onChanged: (value) =>
                    setStateDialog(() => selectedSubjectId = value),
                validator: (v) => v == null ? 'Select subject' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Select Teacher'),
                items: teachers.map((t) {
                  return DropdownMenuItem(
                    value: t.id,
                    child: Text('${t.name} (${t.teacherId})'),
                  );
                }).toList(),
                onChanged: (value) =>
                    setStateDialog(() => selectedTeacherId = value),
                validator: (v) => v == null ? 'Select teacher' : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedSubjectId != null && selectedTeacherId != null) {
                  _cubit.assignSubject(
                    c.id,
                    selectedSubjectId!,
                    selectedTeacherId!,
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Assign'),
            ),
          ],
        ),
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
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(height: 1),
          ...children.map(
            (child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: child,
            ),
          ),
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
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(color: Color(0xFF374151))),
        ),
      ],
    );
  }

  Widget _buildEditForm(ClassroomModel c) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AdminHelper.buildTextField('Name', _nameCtrl, isRequired: true),
          const SizedBox(height: 16),
          AdminHelper.buildTextField(
            'Grade Level',
            _gradeCtrl,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          AdminHelper.buildTextField(
            'Capacity',
            _capacityCtrl,
            isRequired: true,
            type: TextInputType.number,
          ),
          const SizedBox(height: 16),
          AdminHelper.buildTextField(
            'Academic Year',
            _academicYearCtrl,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          AdminHelper.buildTextField('Description', _descCtrl),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Active'),
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
          ),
        ],
      ),
    );
  }
}