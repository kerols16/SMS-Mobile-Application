import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';

class CreateExamSheet extends StatefulWidget {
  final AdminLoaded state;
  final AdminCubit cubit;
  final bool isSuperAdmin;

  const CreateExamSheet({
    super.key,
    required this.state,
    required this.cubit,
    required this.isSuperAdmin,
  });

  @override
  State<CreateExamSheet> createState() => _CreateExamSheetState();
}

class _CreateExamSheetState extends State<CreateExamSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _totalMarksCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();

  int? _selectedSubjectId;
  int? _selectedClassroomId;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _totalMarksCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final minDate = now.add(const Duration(days: 7));
    final picked = await showDatePicker(
      context: context,
      initialDate: minDate,
      firstDate: minDate,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // ✅ Correct payload keys
    final data = {
      'name': _nameCtrl.text.trim(),
      'subject_id': _selectedSubjectId!,
      'classroom_id': _selectedClassroomId!,
      'total_marks': int.parse(_totalMarksCtrl.text),
      'duration_minutes': int.parse(_durationCtrl.text),
      'date': _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : null,
    };

    try {
      await widget.cubit.createExam(data);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Exam',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Exam Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Subject dropdown
              DropdownButtonFormField<int>(
                value: _selectedSubjectId,
                hint: const Text('Select Subject'),
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                items: widget.state.subjects.map((s) {
                  return DropdownMenuItem(value: s.id, child: Text(s.name));
                }).toList(),
                onChanged: (v) => setState(() => _selectedSubjectId = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Classroom dropdown
              DropdownButtonFormField<int>(
                value: _selectedClassroomId,
                hint: const Text('Select Classroom'),
                decoration: const InputDecoration(
                  labelText: 'Classroom',
                  border: OutlineInputBorder(),
                ),
                items: widget.state.classrooms.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.name));
                }).toList(),
                onChanged: (v) => setState(() => _selectedClassroomId = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Total Marks & Duration (side by side)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _totalMarksCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Total Marks',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (int.tryParse(v) == null) return 'Must be a number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _durationCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Duration (min)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (int.tryParse(v) == null) return 'Must be a number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Date picker
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : 'Select date',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Create Exam'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
