import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_test/core/constants/routes_contents.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  bool _canActOnUser(String targetRole) {
    if (widget.isSuperAdmin) return true;
    return targetRole != 'admin' && targetRole != 'super_admin';
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ navigation بـ go_router — مفيش BlocProvider.value ولا .then()
  void _goToUserDetails(BuildContext context, int userId, String role) {
    context.go(
      '${Routes.admin}/${Routes.adminUser(userId)}',
      extra: {'role': role, 'isSuperAdmin': widget.isSuperAdmin},
    );
  }

  @override
  Widget build(BuildContext context) {
    final byRole = _selectedRole == 'All'
        ? widget.state.users
        : widget.state.users.where((u) => u.role == _selectedRole).toList();

    final filtered = _searchQuery.isEmpty
        ? byRole
        : byRole.where((u) => u.name.toLowerCase().contains(_searchQuery)).toList();

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text('Users Management', style: AdminHelper.pageTitle),
          const SizedBox(height: 16),

          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name...',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Role Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                'All', 'admin', 'super_admin', 'teacher', 'student', 'parent',
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '${filtered.length} result${filtered.length == 1 ? '' : 's'} for "$_searchQuery"',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),

          // Users List
          filtered.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Text(
                          'No users found',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: AdminHelper.cardDecoration(),
                  child: Column(
                    children: List.generate(filtered.length, (i) {
                      final u = filtered[i];
                      return Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              // ✅ go_router — مفيش .then() ولا loadDashboard() زيادة
                              onTap: () => _goToUserDetails(context, u.id, u.role),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AdminHelper.roleColor(u.role).withOpacity(0.15),
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

                                    // Name + Email
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildHighlightedName(u.name, _searchQuery),
                                          const SizedBox(height: 2),
                                          Text(
                                            u.email,
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Role badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AdminHelper.roleColor(u.role).withOpacity(0.1),
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

                                    // Edit button
                                    if (_canActOnUser(u.role))
                                      IconButton(
                                        // ✅ go_router
                                        onPressed: () => _goToUserDetails(context, u.id, u.role),
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      )
                                    else
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Icon(Icons.lock_outline, size: 18, color: Colors.grey),
                                      ),

                                    // Delete button
                                    if (_canActOnUser(u.role))
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

  Widget _buildHighlightedName(String name, String query) {
    if (query.isEmpty) {
      return Text(
        name,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF374151),
        ),
      );
    }

    final lowerName = name.toLowerCase();
    final index = lowerName.indexOf(query);

    if (index == -1) {
      return Text(
        name,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF374151),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF374151),
        ),
        children: [
          TextSpan(text: name.substring(0, index)),
          TextSpan(
            text: name.substring(index, index + query.length),
            style: const TextStyle(
              backgroundColor: Color(0xFFFEF08A),
              color: Color(0xFF374151),
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: name.substring(index + query.length)),
        ],
      ),
    );
  }
}