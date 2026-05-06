import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../veiw_model/cubit/admin_cubit.dart';
import '../utils/admin_helper.dart';

void showCreateUserSheet(BuildContext context, bool isSuperAdmin) {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String selectedRole = 'student';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) => Padding(
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
              const Text('Create User', style: AdminHelper.pageTitle),
              const SizedBox(height: 16),
              AdminHelper.buildTextField('Name', nameCtrl, isRequired: true),
              const SizedBox(height: 12),
              AdminHelper.buildTextField('Email', emailCtrl, isRequired: true, type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              AdminHelper.buildTextField('Password', passCtrl, isRequired: true, obscure: true, hint: 'Min 8 characters'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: AdminHelper.inputDecoration('Role', isRequired: true),
                items: (isSuperAdmin 
                    ? ['admin', 'super_admin', 'teacher', 'student', 'parent'] 
                    : ['teacher', 'student', 'parent'])
                    .map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setModalState(() => selectedRole = v!),
              ),
              const SizedBox(height: 24),
              AdminHelper.buildSubmitButton('Create', () {
                if (formKey.currentState!.validate()) {
                  context.read<AdminCubit>().createUser(
                    name: nameCtrl.text, 
                    email: emailCtrl.text, 
                    password: passCtrl.text, 
                    role: selectedRole,
                  );
                  Navigator.pop(ctx);
                }
              }),
            ],
          ),
        ),
      ),
    ),
  );
}
