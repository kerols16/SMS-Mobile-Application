import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../veiw_model/cubit/admin_cubit.dart';
import '../utils/admin_helper.dart';

void showCreateParentSheet(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final idCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  final occuCtrl = TextEditingController();

  bool obscurePass = true;

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
                  const Text('Add Parent', style: AdminHelper.pageTitle),
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

                  AdminHelper.buildTextField('Parent ID', idCtrl, isRequired: true),
                  const SizedBox(height: 12),

                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: const Text('Optional Information', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      children: [
                        AdminHelper.buildTextField('Phone', phoneCtrl, type: TextInputType.phone),
                        const SizedBox(height: 12),
                        AdminHelper.buildTextField('Address', addrCtrl),
                        const SizedBox(height: 12),
                        AdminHelper.buildTextField('Occupation', occuCtrl),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  AdminHelper.buildSubmitButton('Add Parent', () {
                    if (formKey.currentState!.validate()) {
                      context.read<AdminCubit>().createParent(
                        name: nameCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        password: passCtrl.text.trim(),
                        parentId: idCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        address: addrCtrl.text.trim(),
                        occupation: occuCtrl.text.trim(),
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