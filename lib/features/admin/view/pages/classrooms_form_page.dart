// classrooms_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/data/models/classroom_model.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/utils/admin_helper.dart';

class ClassroomFormPage extends StatefulWidget {
  final ClassroomModel? classroom; // null => create mode
  const ClassroomFormPage({super.key, this.classroom});

  @override
  State<ClassroomFormPage> createState() => _ClassroomFormPageState();
}

class _ClassroomFormPageState extends State<ClassroomFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _gradeCtrl;
  late final TextEditingController _capacityCtrl;
  late final TextEditingController _academicYearCtrl;
  late final TextEditingController _descCtrl;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final c = widget.classroom;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _gradeCtrl = TextEditingController(text: c?.gradeLevel ?? '');
    _capacityCtrl = TextEditingController(text: c?.capacity.toString() ?? '');
    _academicYearCtrl = TextEditingController(text: c?.academicYear ?? '2024-2025');
    _descCtrl = TextEditingController(text: c?.description ?? '');
    _isActive = c?.isActive ?? true;
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

  // Custom validator for capacity: must be integer between 1 and 100
  String? _validateCapacity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Capacity is required';
    }
    final int? cap = int.tryParse(value.trim());
    if (cap == null) {
      return 'Must be a valid number';
    }
    if (cap < 1) {
      return 'Capacity must be at least 1';
    }
    if (cap > 100) {
      return 'Capacity cannot exceed 100';
    }
    return null;
  }

  // Custom validator for grade level: must match "Grade X" pattern
  String? _validateGradeLevel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Grade level is required';
    }
    final trimmed = value.trim();
    final regExp = RegExp(r'^Grade\s+\d+$', caseSensitive: false);
    if (!regExp.hasMatch(trimmed)) {
      return 'Must follow the format: Grade [number] (e.g., Grade 1, Grade 10)';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final data = {
      'name': _nameCtrl.text.trim(),
      'grade_level': _gradeCtrl.text.trim(),
      'capacity': int.parse(_capacityCtrl.text.trim()), // already validated
      'academic_year': _academicYearCtrl.text.trim(),
      'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      'is_active': _isActive,
    };

    final cubit = context.read<AdminCubit>();
    if (widget.classroom == null) {
      await cubit.createClassroom(data);
    } else {
      await cubit.updateClassroom(widget.classroom!.id, data);
    }

    if (mounted) {
      Navigator.pop(context, true); // return true means success
    }
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.classroom == null ? 'Create Classroom' : 'Edit Classroom'),
          backgroundColor: AdminHelper.roleColor('classroom'),
          foregroundColor: Colors.white,
          actions: [
            if (!_isLoading)
              TextButton(
                onPressed: _submit,
                child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              )
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AdminHelper.buildTextField('Classroom Name', _nameCtrl, isRequired: true),
                      const SizedBox(height: 16),

                      // Grade Level field with format validation
                      TextFormField(
                        controller: _gradeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Grade Level (e.g. Grade 1)',
                          border: OutlineInputBorder(),
                          hintText: 'Grade 1',
                        ),
                        validator: _validateGradeLevel,
                      ),
                      const SizedBox(height: 16),

                      // Capacity field with range validation (1-100)
                      TextFormField(
                        controller: _capacityCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Capacity (1-100)',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., 30',
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateCapacity,
                      ),
                      const SizedBox(height: 16),

                      AdminHelper.buildTextField('Academic Year (e.g. 2024-2025)', _academicYearCtrl, isRequired: true),
                      const SizedBox(height: 16),
                      AdminHelper.buildTextField('Description (optional)', _descCtrl),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Active'),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        activeColor: AdminHelper.roleColor('classroom'),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminHelper.roleColor('classroom'),
                          minimumSize: const Size(double.infinity, 50),
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                        child: Text(widget.classroom == null ? 'Create' : 'Update'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}