import 'package:flutter/material.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';


class CreateGradeSheet extends StatefulWidget {
  final AdminLoaded state;
  final AdminCubit cubit;
  final bool isSuperAdmin;

  const CreateGradeSheet({
    super.key,
    required this.state,
    required this.cubit,
    required this.isSuperAdmin,
  });

  @override
  State<CreateGradeSheet> createState() => _CreateGradeSheetState();
}

class _CreateGradeSheetState extends State<CreateGradeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _scoreCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  int? _selectedStudentId;
  int? _selectedExamId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _scoreCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final data = {
      'student_id': _selectedStudentId!,
      'exam_id': _selectedExamId!,
      'marks_obtained': int.parse(_scoreCtrl.text),
      if (_remarksCtrl.text.trim().isNotEmpty)
        'remarks': _remarksCtrl.text.trim(),
    };

    try {
      await widget.cubit.createGrade(data);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
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
                    'Add Grade',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Student dropdown
              DropdownButtonFormField<int>(
                value: _selectedStudentId,
                hint: const Text('Select Student'),
                decoration: const InputDecoration(
                  labelText: 'Student',
                  border: OutlineInputBorder(),
                ),
                items: widget.state.students.map((s) {
                  return DropdownMenuItem(
                    value: s.id,
                    child: Text(s.name),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedStudentId = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Exam dropdown (required)
              DropdownButtonFormField<int>(
                value: _selectedExamId,
                hint: const Text('Select Exam'),
                decoration: const InputDecoration(
                  labelText: 'Exam',
                  border: OutlineInputBorder(),
                ),
                items: widget.state.exams.map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedExamId = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Marks obtained
              TextFormField(
                controller: _scoreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Marks Obtained',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Remarks (optional)
              TextFormField(
                controller: _remarksCtrl,
                decoration: const InputDecoration(
                  labelText: 'Remarks (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
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
                    : const Text('Add Grade'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}