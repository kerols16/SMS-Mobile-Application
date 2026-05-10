// subject_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/data/models/subject_model.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/utils/admin_helper.dart';

class SubjectDetailsPage extends StatefulWidget {
  final int subjectId;
  const SubjectDetailsPage({super.key, required this.subjectId});

  @override
  State<SubjectDetailsPage> createState() => _SubjectDetailsPageState();
}

class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
  late final AdminCubit _cubit;
  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _creditsCtrl;
  late String _type;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AdminCubit>();
    _cubit.getSubjectById(widget.subjectId);
    _nameCtrl = TextEditingController();
    _codeCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _creditsCtrl = TextEditingController();
    _type = 'core';
    _isActive = true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _creditsCtrl.dispose();
    super.dispose();
  }

  void _populateControllers(SubjectModel s) {
    _nameCtrl.text = s.name;
    _codeCtrl.text = s.code;
    _descCtrl.text = s.description ?? '';
    _creditsCtrl.text = s.credits.toString();
    _type = s.type;
    _isActive = s.isActive;
  }

  void _saveChanges(SubjectModel s) {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'name': _nameCtrl.text.trim(),
      'code': _codeCtrl.text.trim().toUpperCase(),
      'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      'credits': int.tryParse(_creditsCtrl.text.trim()) ?? 0,
      'type': _type,
      'is_active': _isActive,
    };
    _cubit.updateSubject(s.id, data);
    setState(() => _isEditMode = false);
  }

  void _deleteSubject(SubjectModel s) {
    AdminHelper.confirmDelete(context, s.name, () {
      _cubit.deleteSubject(s.id).then((_) {
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
          _cubit.getSubjectById(widget.subjectId);
        } else if (state is AdminOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const Text('Subject Details'),
          backgroundColor: AdminHelper.roleColor('subject'),
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
                  if (state is SubjectLoaded) _deleteSubject(state.subject);
                },
              ),
            if (_isEditMode)
              TextButton(
                onPressed: () {
                  final state = _cubit.state;
                  if (state is SubjectLoaded) _saveChanges(state.subject);
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
            if (state is AdminLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SubjectLoaded) {
              final s = state.subject;
              if (_isEditMode && _nameCtrl.text.isEmpty) _populateControllers(s);
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

  Widget _buildViewMode(SubjectModel s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Subject Info', [
          _infoRow('Name', s.name),
          _infoRow('Code', s.code),
          _infoRow('Credits', s.credits.toString()),
          _infoRow('Type', s.type == 'core' ? 'Core' : 'Elective'),
          _infoRow('Status', s.isActive ? 'Active' : 'Inactive'),
          if (s.description != null && s.description!.isNotEmpty)
            _infoRow('Description', s.description!),
        ]),
        const SizedBox(height: 20),
        _buildInfoCard('Classrooms (${s.classrooms.length})', 
          s.classrooms.isEmpty 
            ? [const Text('No classrooms assigned', style: TextStyle(color: Colors.grey))]
            : s.classrooms.map<Widget>((c) => _infoRow('', c['name'] ?? 'Classroom')).toList(),
        ),
        const SizedBox(height: 20),
        _buildInfoCard('Teachers (${s.teachers.length})', 
          s.teachers.isEmpty 
            ? [const Text('No teachers assigned', style: TextStyle(color: Colors.grey))]
            : s.teachers.map<Widget>((t) => _infoRow('', t['name'] ?? 'Teacher')).toList(),
        ),
      ],
    );
  }

  Widget _buildEditForm(SubjectModel s) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AdminHelper.buildTextField('Name', _nameCtrl, isRequired: true),
          const SizedBox(height: 16),
          AdminHelper.buildTextField('Code', _codeCtrl, isRequired: true),
          const SizedBox(height: 16),
          AdminHelper.buildTextField('Description', _descCtrl, ),
          const SizedBox(height: 16),
          AdminHelper.buildTextField('Credits', _creditsCtrl, isRequired: true, type: TextInputType.number),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Type'),
            value: _type,
            items: const [
              DropdownMenuItem(value: 'core', child: Text('Core')),
              DropdownMenuItem(value: 'elective', child: Text('Elective')),
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