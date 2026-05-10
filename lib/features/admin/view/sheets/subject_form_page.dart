// subject_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/data/models/subject_model.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/utils/admin_helper.dart';

class SubjectFormPage extends StatefulWidget {
  final SubjectModel? subject;
  const SubjectFormPage({super.key, this.subject});

  @override
  State<SubjectFormPage> createState() => _SubjectFormPageState();
}

class _SubjectFormPageState extends State<SubjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _creditsCtrl;
  late String _type;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final s = widget.subject;
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _codeCtrl = TextEditingController(text: s?.code ?? '');
    _descCtrl = TextEditingController(text: s?.description ?? '');
    _creditsCtrl = TextEditingController(text: s?.credits.toString() ?? '');
    _type = s?.type ?? 'core';
    _isActive = s?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _creditsCtrl.dispose();
    super.dispose();
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
          title: Text(
            widget.subject == null ? 'Create Subject' : 'Edit Subject',
          ),
          backgroundColor: AdminHelper.roleColor('subject'),
          foregroundColor: Colors.white,
          actions: [
            if (!_isLoading)
              TextButton(
                onPressed: _submit,
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
                      AdminHelper.buildTextField(
                        'Subject Name',
                        _nameCtrl,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      AdminHelper.buildTextField(
                        'Code',
                        _codeCtrl,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),
                      AdminHelper.buildTextField('Description', _descCtrl),
                      const SizedBox(height: 16),
                      AdminHelper.buildTextField(
                        'Credits',
                        _creditsCtrl,
                        isRequired: true,
                        type: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Type'),
                        value: _type,
                        items: const [
                          DropdownMenuItem(value: 'core', child: Text('Core')),
                          DropdownMenuItem(
                            value: 'elective',
                            child: Text('Elective'),
                          ),
                        ],
                        onChanged: (v) => setState(() => _type = v!),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Active'),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        activeColor: AdminHelper.roleColor('subject'),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminHelper.roleColor('subject'),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          widget.subject == null ? 'Create' : 'Update',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final data = {
      'name': _nameCtrl.text.trim(),
      'code': _codeCtrl.text.trim().toUpperCase(),
      'description': _descCtrl.text.trim().isEmpty
          ? null
          : _descCtrl.text.trim(),
      'credits': int.tryParse(_creditsCtrl.text.trim()) ?? 0,
      'type': _type,
      'is_active': _isActive,
    };
    final cubit = context.read<AdminCubit>();
    if (widget.subject == null) {
      await cubit.createSubject(data);
    } else {
      await cubit.updateSubject(widget.subject!.id, data);
    }
  }
}
