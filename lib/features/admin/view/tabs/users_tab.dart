import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/view/pages/user_details_page.dart';
import '../../veiw_model/cubit/admin_cubit.dart';
import '../utils/admin_helper.dart';

class UsersTab extends StatefulWidget {
  final AdminLoaded state;
  final bool isSuperAdmin;

  const UsersTab({super.key, required this.state, required this.isSuperAdmin});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  String _selectedRole = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedRole == 'All'
        ? widget.state.users
        : widget.state.users.where((u) => u.role == _selectedRole).toList();

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text('Users Management', style: AdminHelper.pageTitle),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                    'All',
                    'admin',
                    'super_admin',
                    'teacher',
                    'student',
                    'parent',
                  ].map((role) {
                    final isSelected = _selectedRole == role;
                    final color = role == 'All'
                        ? const Color(0xFF2563EB)
                        : AdminHelper.roleColor(role);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedRole = role),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? color : color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            role,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : color,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: AdminHelper.cardDecoration(),
            child: Column(
              children: List.generate(filtered.length, (i) {
                final u = filtered[i];
                return Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<AdminCubit>(),
                                child: UserDetailsPage(
                                  userId: u.id,
                                  role: u.role,
                                ),
                              ),
                            ),
                          ).then((_) {
                            context.read<AdminCubit>().loadDashboard();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AdminHelper.roleColor(
                                    u.role,
                                  ).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    u.name[0].toUpperCase(),
                                    style: TextStyle(
                                      color: AdminHelper.roleColor(u.role),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      u.email,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AdminHelper.roleColor(
                                    u.role,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  u.role.replaceAll('_', ' '),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AdminHelper.roleColor(u.role),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<AdminCubit>(),
                                        child: UserDetailsPage(
                                          userId: u.id,
                                          role: u.role,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              if (widget.isSuperAdmin || u.role != 'admin')
                                IconButton(
                                  onPressed: () => AdminHelper.confirmDelete(
                                    context,
                                    'user',
                                    () {
                                      final cubit = context.read<AdminCubit>();
                                      cubit.deleteUser(u.id);
                                      cubit.loadDashboard();
                                    },
                                  ),
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.red.shade300,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (i != filtered.length - 1)
                      Divider(height: 1, color: Colors.grey.shade100),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}
