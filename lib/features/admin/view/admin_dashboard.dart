import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/core/storage/local_srotage.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../auth/view/cubit/auth_cubit.dart';
import '../view/cubit/admin_cubit.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _activeTab    = 'dashboard';
  String _selectedRole = 'All';
  String _originalRole = 'admin';

  bool get _isSuperAdmin => _originalRole == 'super_admin';

  @override
  void initState() {
    super.initState();
    _loadOriginalRole();
    context.read<AdminCubit>().loadDashboard(); 
  }

  Future<void> _loadOriginalRole() async {
    final role = await LocalStorage.getOriginalRole();
    if (role != null) setState(() => _originalRole = role);
  }

  final List<NavItem> _navItems = [
    NavItem(id: 'dashboard', label: 'Dashboard', icon: Icons.home),
    NavItem(id: 'users',     label: 'Users',     icon: Icons.manage_accounts),
    NavItem(id: 'profile',   label: 'Profile',   icon: Icons.person),
  ];

  IconData _roleIcon(String role) {
  switch (role) {
    case 'super_admin': return Icons.admin_panel_settings;
    case 'admin':       return Icons.shield;
    case 'teacher':     return Icons.menu_book;
    case 'student':     return Icons.school;
    case 'parent':      return Icons.people;
    default:            return Icons.person;
  }
}

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
        }
        if (state is AdminOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    _buildHeader(state),
                    if (state is AdminLoading)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state is AdminError) 
                       SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                              const SizedBox(height: 12),
                              Text(state.message, style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {context.read<AdminCubit>().loadDashboard();},
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (state is AdminLoaded) ...[
                      if (_activeTab == 'dashboard') _buildDashboardTab(state),
                      if (_activeTab == 'users')     _buildUsersTab(state),
                      if (_activeTab == 'profile')   _buildProfileTab(),
                    ],
                  ],
                ),
                Positioned(
                  left: 0, right: 0, bottom: 0,
                  child: BottomNav(
                    items: _navItems,
                    activeTab: _activeTab,
                    onTabChange: (tab) => setState(() => _activeTab = tab),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════
  SliverToBoxAdapter _buildHeader(AdminState state) {
    final unread = state is AdminLoaded ? state.unreadCount : 0;
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isSuperAdmin
                ? [const Color(0xFFDC2626), const Color(0xFF991B1B)]
                : [const Color(0xFF2563EB), const Color(0xFF1E40AF)],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Good Morning', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  _isSuperAdmin ? 'Super Admin Dashboard' : 'Admin Dashboard',
                  style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 14),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => setState(() => _activeTab = 'users'),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.notifications, color: Colors.white, size: 24),
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 4, right: 4,
                      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // DASHBOARD TAB
  // ═══════════════════════════════════════
  SliverPadding _buildDashboardTab(AdminLoaded state) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16,
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(icon: Icons.school,               color: Colors.blue,   value: state.students.length.toString(), label: 'Total Students'),
              _buildStatCard(icon: Icons.menu_book,            color: Colors.teal,   value: state.teachers.length.toString(), label: 'Total Teachers'),
              _buildStatCard(icon: Icons.manage_accounts,      color: Colors.purple, value: state.users.length.toString(),    label: 'Total Users'),
              _buildStatCard(icon: Icons.notifications_active, color: Colors.orange, value: state.unreadCount.toString(),     label: 'Unread Notifications'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Quick Actions', style: _sectionTitle),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildActionButton(icon: Icons.person_add,    label: 'Add Student', color: Colors.blue,   onTap: () => _showCreateStudentSheet(context)),
              _buildActionButton(icon: Icons.menu_book,     label: 'Add Teacher', color: Colors.teal,   onTap: () => _showCreateTeacherSheet(context)),
              _buildActionButton(icon: Icons.group_add,     label: 'Add User',    color: Colors.purple, onTap: () => _showCreateUserSheet(context)),
              _buildActionButton(icon: Icons.family_restroom, label: 'Add Parent',  color: Colors.orange, onTap: () => _showCreateParentSheet(context)),
            ],
          ),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }

  // ═══════════════════════════════════════
  // USERS TAB
  // ═══════════════════════════════════════
  SliverPadding _buildUsersTab(AdminLoaded state) {
    final filtered = _selectedRole == 'All'
        ? state.users
        : state.users.where((u) => u.role == _selectedRole).toList();

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text('Users Management', style: _pageTitle),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'admin', 'super_admin', 'teacher', 'student', 'parent'].map((role) {
                final isSelected = _selectedRole == role;
                final color = role == 'All' ? const Color(0xFF2563EB) : _roleColor(role);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedRole = role),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: isSelected ? color : color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(role, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : color)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: _cardDecoration(),
            child: Column(
              children: List.generate(filtered.length, (i) {
                final u = filtered[i];
                // FIX 2 — Restore edit/delete buttons in Users Tab
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: _roleColor(u.role).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                u.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: _roleColor(u.role),
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
                                Text(u.name, style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500,
                                  color: Color(0xFF374151),
                                )),
                                const SizedBox(height: 2),
                                Text(u.email, style: const TextStyle(
                                  fontSize: 12, color: Colors.grey,
                                ), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _roleColor(u.role).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              u.role.replaceAll('_', ' '),
                              style: TextStyle(
                                fontSize: 11,
                                color: _roleColor(u.role),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                          ),
                          if (_isSuperAdmin || u.role != 'admin')
                            IconButton(
                              onPressed: () => _confirmDelete(
                                context, 'user',
                                () => context.read<AdminCubit>().deleteUser(u.id),
                              ),
                              icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade300),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }

  // FIX 3 — Restore full Profile Tab UI
  SliverPadding _buildProfileTab() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text('Profile & Settings', style: _pageTitle),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: _cardDecoration(),
            child: Column(children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isSuperAdmin
                        ? [const Color(0xFFDC2626), const Color(0xFF991B1B)]
                        : [const Color(0xFF2563EB), const Color(0xFF1E40AF)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('A', style: TextStyle(
                    fontSize: 32, color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Admin User', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              )),
              const SizedBox(height: 4),
              const Text('admin@sms.com', style: TextStyle(
                fontSize: 14, color: Colors.grey,
              )),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _isSuperAdmin
                      ? Colors.red.shade50
                      : Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isSuperAdmin ? 'Super Admin' : 'Admin',
                  style: TextStyle(
                    fontSize: 13,
                    color: _isSuperAdmin
                        ? Colors.red.shade700
                        : Colors.purple.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          Container(
            decoration: _cardDecoration(),
            child: Column(children: [
              _buildSettingItem('Notification Settings', Icons.notifications_outlined),
              _buildSettingItem('Language & Region',     Icons.language),
              _buildSettingItem('Data Export',           Icons.download_outlined),
              _buildSettingItem('Help & Support',        Icons.help_outline),
            ]),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity, height: 56,
            child: ElevatedButton.icon(
              onPressed: () => context.read<AuthCubit>().logout(),
              icon: const Icon(Icons.logout, size: 20),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEF2F2),
                foregroundColor: const Color(0xFFDC2626),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 70),
        ]),
      ),
    );
  }

  // ═══════════════════════════════════════
  // STRUCTURED FORMS (REQUIRED & OPTIONAL)
  // ═══════════════════════════════════════

  void _showCreateUserSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    String selectedRole = 'student';

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Form(
            key: formKey,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Create User', style: _pageTitle),
              const SizedBox(height: 16),
              _buildTextField('Name', nameCtrl, isRequired: true),
              const SizedBox(height: 12),
              _buildTextField('Email', emailCtrl, isRequired: true, type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildTextField('Password', passCtrl, isRequired: true, obscure: true, hint: 'Min 8 characters'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: _inputDecoration('Role', isRequired: true),
                items: (_isSuperAdmin ? ['admin', 'super_admin', 'teacher', 'student', 'parent'] : ['teacher', 'student', 'parent'])
                    .map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setModalState(() => selectedRole = v!),
              ),
              const SizedBox(height: 24),
              _buildSubmitButton('Create', () {
                if (formKey.currentState!.validate()) {
                  context.read<AdminCubit>().createUser(name: nameCtrl.text, email: emailCtrl.text, password: passCtrl.text, role: selectedRole);
                  Navigator.pop(ctx);
                }
              }),
            ]),
          ),
        ),
      ),
    );
  }

  void _showCreateStudentSheet(BuildContext context) {
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
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SingleChildScrollView(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Form(
            key: formKey,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Add Student', style: _pageTitle),
              const SizedBox(height: 16),
              _buildTextField('Full Name', nameCtrl, isRequired: true),
              const SizedBox(height: 12),
              _buildTextField('Email', emailCtrl, isRequired: true, type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildTextField('Password', passCtrl, isRequired: true, obscure: true, hint: 'Min 8 characters'),
              const SizedBox(height: 12),
              _buildTextField('Student ID', idCtrl, isRequired: true),
              const SizedBox(height: 12),
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text('Optional Information', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  children: [
                    _buildTextField('Date of Birth', dobCtrl, hint: 'YYYY-MM-DD'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: gender, decoration: _inputDecoration('Gender'),
                      items: ['male', 'female', 'other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) => setModalState(() => gender = v!),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Address', addrCtrl),
                    const SizedBox(height: 12),
                    _buildTextField('Phone', phoneCtrl, type: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildTextField('Enrollment Date', enrollCtrl, hint: 'YYYY-MM-DD'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSubmitButton('Add Student', () {
                if (formKey.currentState!.validate()) {
                  context.read<AdminCubit>().createStudent(name: nameCtrl.text, email: emailCtrl.text, password: passCtrl.text, studentId: idCtrl.text, dateOfBirth: dobCtrl.text, gender: gender, address: addrCtrl.text, phone: phoneCtrl.text, enrollmentDate: enrollCtrl.text);
                  Navigator.pop(ctx);
                }
              }),
            ]),
          ),
        ),
      ),
    );
  }

  void _showCreateTeacherSheet(BuildContext context) {
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

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SingleChildScrollView(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Form(
            key: formKey,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Add Teacher', style: _pageTitle),
              const SizedBox(height: 16),
              _buildTextField('Full Name', nameCtrl, isRequired: true),
              const SizedBox(height: 12),
              _buildTextField('Email', emailCtrl, isRequired: true, type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildTextField('Password', passCtrl, isRequired: true, obscure: true, hint: 'Min 8 characters'),
              const SizedBox(height: 12),
              _buildTextField('Teacher ID', idCtrl, isRequired: true),
              const SizedBox(height: 12),
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text('Optional Information', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  children: [
                    _buildTextField('Date of Birth', dobCtrl, hint: 'YYYY-MM-DD'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: gender, decoration: _inputDecoration('Gender'),
                      items: ['male', 'female', 'other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) => setModalState(() => gender = v!),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Address', addrCtrl),
                    const SizedBox(height: 12),
                    _buildTextField('Phone', phoneCtrl, type: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildTextField('Hire Date', hireCtrl, hint: 'YYYY-MM-DD'),
                    const SizedBox(height: 12),
                    _buildTextField('Qualification', qualCtrl),
                    const SizedBox(height: 12),
                    _buildTextField('Subject Specialization', subCtrl),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSubmitButton('Add Teacher', () {
                if (formKey.currentState!.validate()) {
                  context.read<AdminCubit>().createTeacher(name: nameCtrl.text, email: emailCtrl.text, password: passCtrl.text, teacherId: idCtrl.text, dateOfBirth: dobCtrl.text, gender: gender, address: addrCtrl.text, phone: phoneCtrl.text, hireDate: hireCtrl.text, qualification: qualCtrl.text, subjectSpecialization: subCtrl.text);
                  Navigator.pop(ctx);
                }
              }),
            ]),
          ),
        ),
      ),
    );
  }

  void _showCreateParentSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addrCtrl = TextEditingController();
    final occuCtrl = TextEditingController();

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SingleChildScrollView(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Form(
            key: formKey,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Add Parent', style: _pageTitle),
              const SizedBox(height: 16),
              _buildTextField('Full Name', nameCtrl, isRequired: true),
              const SizedBox(height: 12),
              _buildTextField('Email', emailCtrl, isRequired: true, type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildTextField('Password', passCtrl, isRequired: true, obscure: true, hint: 'Min 8 characters'),
              const SizedBox(height: 12),
              _buildTextField('Parent ID', idCtrl, isRequired: true),
              const SizedBox(height: 12),
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text('Optional Information', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  children: [
                    _buildTextField('Phone', phoneCtrl, type: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildTextField('Address', addrCtrl),
                    const SizedBox(height: 12),
                    _buildTextField('Occupation', occuCtrl),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // FIX 1 — Connect createParent
              _buildSubmitButton('Add Parent', () {
                if (formKey.currentState!.validate()) {
                  context.read<AdminCubit>().createParent(
                    name:       nameCtrl.text.trim(),
                    email:      emailCtrl.text.trim(),
                    password:   passCtrl.text.trim(),
                    parentId:   idCtrl.text.trim(),
                    phone:      phoneCtrl.text.trim(),
                    address:    addrCtrl.text.trim(),
                    occupation: occuCtrl.text.trim(),
                  );
                  Navigator.pop(ctx);
                }
              }),
            ]),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // HELPER WIDGETS & LOGIC
  // ═══════════════════════════════════════

  void _confirmDelete(BuildContext context, String type, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete $type'),
        content: Text(
          'Are you sure you want to delete this $type? '
          'This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); onConfirm(); },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {bool isRequired = false, TextInputType type = TextInputType.text, bool obscure = false, String? hint}) {
    return TextFormField(
      controller: ctrl, keyboardType: type, obscureText: obscure,
      decoration: _inputDecoration(label, isRequired: isRequired, hint: hint),
      validator: (v) {
        if (isRequired && (v == null || v.trim().isEmpty)) return 'Field is required';
        if (isRequired && obscure && v!.length < 8) return 'Password must be at least 8 characters';
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String label, {bool isRequired = false, String? hint}) {
    return InputDecoration(
      label: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label), if (isRequired) const Text(' *', style: TextStyle(color: Colors.red)),
      ]),
      hintText: hint,
      filled: true, fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Text(label),
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required Color color, required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.all(16), decoration: _cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ]),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ]),
      ),
    );
  }

  Widget _buildSettingItem(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(
                fontSize: 14, color: Color(0xFF374151),
              ))),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ]),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
    );
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'super_admin': return Colors.red;
      case 'admin':       return Colors.purple;
      case 'teacher':     return Colors.teal;
      case 'student':     return Colors.blue;
      case 'parent':      return Colors.orange;
      default:            return Colors.grey;
    }
  }

  static const _sectionTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151));
  static const _pageTitle    = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF374151));
}
