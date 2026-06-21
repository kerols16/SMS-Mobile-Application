import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../veiw_model/cubit/admin_cubit.dart';
import '../utils/admin_helper.dart';

void showCreateTeacherSheet(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final idCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final hireCtrl = TextEditingController();
  final qualCtrl = TextEditingController();
  final subCtrl = TextEditingController();
  String gender = 'male';
  bool obscurePass = true;

  Future<void> pickDate(
    BuildContext ctx,
    TextEditingController ctrl, {
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
    );
    if (picked != null) {
      ctrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => BlocProvider.value(
      value: context.read<AdminCubit>(),
      child: BlocListener<AdminCubit, AdminState>(
        listener: (context, state) {
          if (state is AdminOperationError) {
            final msg = state.message.toLowerCase();
            final friendly = (msg.contains('email') && msg.contains('taken'))
                ? 'This email is already registered. Please use a different email.'
                : state.message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(friendly), backgroundColor: Colors.red),
            );
          }
        },
        child: StatefulBuilder(
          builder: (ctx, setModalState) => SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24, right: 24, top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Teacher', style: AdminHelper.pageTitle),
                  const SizedBox(height: 16),

                  AdminHelper.buildTextField('Full Name', nameCtrl, isRequired: true),
                  const SizedBox(height: 12),

                  AdminHelper.buildTextField('Email', emailCtrl, isRequired: true, type: TextInputType.emailAddress),
                  const SizedBox(height: 12),

                  // Password with eye icon + 8-20 validation
                  TextFormField(
                    controller: passCtrl,
                    obscureText: obscurePass,
                    decoration: AdminHelper.inputDecoration(
                      'Password',
                      isRequired: true,
                      hint: '8 - 20 characters',
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePass ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => setModalState(() => obscurePass = !obscurePass),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 8) return 'Minimum 8 characters';
                      if (v.length > 20) return 'Maximum 20 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  AdminHelper.buildTextField('Teacher ID', idCtrl, isRequired: true),
                  const SizedBox(height: 12),

                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: const Text('Optional Information', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      children: [
                        // Date of Birth - date picker
                        TextFormField(
                          controller: dobCtrl,
                          readOnly: true,
                          decoration: AdminHelper.inputDecoration(
                            'Date of Birth',
                            hint: 'Tap to select',
                          ).copyWith(
                            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
                          ),
                          onTap: () => pickDate(ctx, dobCtrl),
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value: gender,
                          decoration: AdminHelper.inputDecoration('Gender'),
                          items: ['male', 'female', 'other']
                              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (v) => setModalState(() => gender = v!),
                        ),
                        const SizedBox(height: 12),

                        AdminHelper.buildTextField('Address', addrCtrl),
                        const SizedBox(height: 12),

                        AdminHelper.buildTextField('Phone', phoneCtrl, type: TextInputType.phone),
                        const SizedBox(height: 12),

                        // Hire Date - date picker
                        TextFormField(
                          controller: hireCtrl,
                          readOnly: true,
                          decoration: AdminHelper.inputDecoration(
                            'Hire Date',
                            hint: 'Tap to select',
                          ).copyWith(
                            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
                          ),
                          onTap: () => pickDate(ctx, hireCtrl, lastDate: DateTime.now()),
                        ),
                        const SizedBox(height: 12),

                        AdminHelper.buildTextField('Qualification', qualCtrl),
                        const SizedBox(height: 12),

                        AdminHelper.buildTextField('Subject Specialization', subCtrl),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  AdminHelper.buildSubmitButton('Add Teacher', () {
                    if (formKey.currentState!.validate()) {
                      context.read<AdminCubit>().createTeacher(
                        name: nameCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        password: passCtrl.text.trim(),
                        teacherId: idCtrl.text.trim(),
                        dateOfBirth: dobCtrl.text.trim(),
                        gender: gender,
                        address: addrCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        hireDate: hireCtrl.text.trim(),
                        qualification: qualCtrl.text.trim(),
                        subjectSpecialization: subCtrl.text.trim(),
                      );
                      Navigator.pop(ctx);
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}