// subjects_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/pages/subject_details_page.dart';
import 'package:school_test/features/admin/view/sheets/subject_form_page.dart';

class SubjectsListPage extends StatelessWidget {
  const SubjectsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectFormPage())).then((_) => cubit.loadDashboard()),
          ),
        ],
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoaded) {
            final subjects = state.subjects;
            if (subjects.isEmpty) {
              return const Center(child: Text('No subjects found'));
            }
            return ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.book),
                title: Text(subjects[i].name),
                subtitle: Text('${subjects[i].code} | Credits: ${subjects[i].credits}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(context, cubit, subjects[i].id, subjects[i].name),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => SubjectDetailsPage(subjectId: subjects[i].id),
                )),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, AdminCubit cubit, int id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Subject'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteSubject(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}