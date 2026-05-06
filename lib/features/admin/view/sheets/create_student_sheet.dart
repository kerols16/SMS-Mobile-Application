import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../veiw_model/cubit/admin_cubit.dart';
import '../utils/admin_helper.dart';

void showCreateStudentSheet(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final idCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final enrollCtrl = TextEditingController();
  String gender = 'male';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => StatefulBuilder(
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
              const Text('Add Student', style: AdminHelper.pageTitle),
              const SizedBox(height: 16),
              AdminHelper.buildTextField('Full Name', nameCtrl, isRequired: true),
              const SizedBox(height: 12),
              AdminHelper.buildTextField('Email', emailCtrl, isRequired: true, type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              AdminHelper.buildTextField('Password', passCtrl, isRequired: true, obscure: true, hint: 'Min 8 characters'),
              const SizedBox(height: 12),
              AdminHelper.buildTextField('Student ID', idCtrl, isRequired: true),
              const SizedBox(height: 12),
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text('Optional Information', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  children: [
                    AdminHelper.buildTextField('Date of Birth', dobCtrl, hint: 'YYYY-MM-DD'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration: AdminHelper.inputDecoration('Gender'),
                      items: ['male', 'female', 'other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) => setModalState(() => gender = v!),
                    ),
                    const SizedBox(height: 12),
                    AdminHelper.buildTextField('Address', addrCtrl),
                    const SizedBox(height: 12),
                    AdminHelper.buildTextField('Phone', phoneCtrl, type: TextInputType.phone),
                    const SizedBox(height: 12),
                    AdminHelper.buildTextField('Enrollment Date', enrollCtrl, hint: 'YYYY-MM-DD'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AdminHelper.buildSubmitButton('Add Student', () {
                if (formKey.currentState!.validate()) {
                  context.read<AdminCubit>().createStudent(
                    name: nameCtrl.text,
                    email: emailCtrl.text,
                    password: passCtrl.text,
                    studentId: idCtrl.text,
                    dateOfBirth: dobCtrl.text,
                    gender: gender,
                    address: addrCtrl.text,
                    phone: phoneCtrl.text,
                    enrollmentDate: enrollCtrl.text,
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
