import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_test/features/admin/data/models/student_model.dart';
import 'package:school_test/features/admin/data/models/teacher_model.dart';
import 'package:school_test/features/admin/data/models/parent_model.dart';
import 'package:school_test/features/admin/veiw_model/cubit/admin_cubit.dart';
import 'package:school_test/features/admin/view/utils/admin_helper.dart';

class UserDetailsPage extends StatefulWidget {
  final int userId;
  final String role;

  const UserDetailsPage({super.key, required this.userId, required this.role});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  bool _isEditMode = false;

  // Edit controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _occuCtrl = TextEditingController();
  final _qualCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadUserDetails(widget.userId, widget.role);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _occuCtrl.dispose();
    _qualCtrl.dispose();
    _subjectCtrl.dispose();
    super.dispose();
  }

  void _populateControllers(AdminUserDetailsLoaded state) {
    _nameCtrl.text = state.user.name;
    _emailCtrl.text = state.user.email;
    _phoneCtrl.text =
        state.student?.phone ??
        state.teacher?.phone ??
        state.parent?.phone ??
        '';
    _addressCtrl.text =
        state.student?.address ??
        state.teacher?.address ??
        state.parent?.address ??
        '';
    _occuCtrl.text = state.parent?.occupation ?? '';
    _qualCtrl.text = state.teacher?.qualification ?? '';
    _subjectCtrl.text = state.teacher?.subjectSpecialization ?? '';
  }

  void _saveChanges(BuildContext context, AdminUserDetailsLoaded state) {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<AdminCubit>();
    final role = widget.role;

    if (role == 'student' && state.student != null) {
      cubit.updateStudent(state.student!.id, {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
      });
    } else if (role == 'teacher' && state.teacher != null) {
      cubit.updateTeacher(state.teacher!.id, {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'qualification': _qualCtrl.text.trim(),
        'subject_specialization': _subjectCtrl.text.trim(),
      });
    } else if (role == 'parent' && state.parent != null) {
      cubit.updateParent(state.parent!.id, {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'occupation': _occuCtrl.text.trim(),
      });
    } else {
      cubit.updateUser(
        state.user.id,
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
      );
    }
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
          if (!mounted) return;
          setState(() => _isEditMode = false);
          context.read<AdminCubit>().loadUserDetails(
            widget.userId,
            widget.role,
          );
        }
        if (state is AdminOperationError) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        resizeToAvoidBottomInset: true,
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminUserDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminUserDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<AdminCubit>()
                          .loadUserDetails(widget.userId, widget.role),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is AdminUserDetailsLoaded) {
              // populate controllers when entering edit mode
              if (_isEditMode && _nameCtrl.text.isEmpty) {
                _populateControllers(state);
              }

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  _buildAppBar(context, state, innerBoxIsScrolled),
                ],
                body: _isEditMode
                    ? _buildEditModeBody(context, state)
                    : _buildViewModeBody(state),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // APP BAR 
  // ═══════════════════════════════════════
  SliverAppBar _buildAppBar(
    BuildContext context,
    AdminUserDetailsLoaded state,
    bool innerBoxIsScrolled,
  ) {
    return SliverAppBar(
      expandedHeight: 230,
      pinned: true,
      backgroundColor: AdminHelper.roleColor(widget.role),
      leading: IconButton(
        onPressed: () {
          context.read<AdminCubit>().loadDashboard();
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        if (!_isEditMode) ...[
          IconButton(
            onPressed: () {
              _populateControllers(state);
              setState(() => _isEditMode = true);
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: () =>
                AdminHelper.confirmDelete(context, state.user.name, () {
                  context.read<AdminCubit>().deleteUser(state.user.id);
                  context.read<AdminCubit>().loadDashboard();
                  Navigator.pop(context);

                }),
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: 'Delete',
          ),
        ] else ...[
          TextButton(
            onPressed: () => _saveChanges(context, state),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _isEditMode = false),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AdminHelper.roleColor(widget.role),
                AdminHelper.roleColor(widget.role).withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                // Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      state.user.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32, 
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.user.name,
                  style: const TextStyle(
                    fontSize: 18, 
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  state.user.email,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 6),
                // Role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: Text(
                    widget.role.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12), 
              ],
            ),
          ),
        ),
      ),
    );
  } // ═══════════════════════════════════════

  // VIEW MODE BODY
  // ═══════════════════════════════════════
  Widget _buildViewModeBody(AdminUserDetailsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        24,
      ).copyWith(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role-specific info
          if (state.student != null) _buildStudentInfo(state.student!),
          if (state.teacher != null) _buildTeacherInfo(state.teacher!),
          if (state.parent != null) _buildParentInfo(state.parent!),

          const SizedBox(height: 16),

          // Account Info
          _buildSection('Account Info', [
            _buildInfoRow(
              Icons.verified_outlined,
              state.user.emailVerifiedAt != null
                  ? 'Email Verified'
                  : 'Email Not Verified',
              state.user.emailVerifiedAt != null ? Colors.green : Colors.red,
            ),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              'Joined: ${_formatDate(state.user.createdAt)}',
              Colors.grey,
            ),
          ]),

          const SizedBox(height: 32),

          // Delete button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () =>
                  AdminHelper.confirmDelete(context, state.user.name, () {
                    context.read<AdminCubit>().deleteUser(state.user.id);
                    context.read<AdminCubit>().loadDashboard();
                    Navigator.pop(context);
                  }),
              icon: const Icon(Icons.delete_outline, size: 20),
              label: const Text('Delete Account'),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  // EDIT MODE BODY 
  // ═══════════════════════════════════════
  Widget _buildEditModeBody(
    BuildContext context,
    AdminUserDetailsLoaded state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24).copyWith(bottom: 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 20),

            // Common fields
            AdminHelper.buildTextField(
              'Full Name',
              _nameCtrl,
              isRequired: true,
            ),
            const SizedBox(height: 12),
            AdminHelper.buildTextField(
              'Email',
              _emailCtrl,
              isRequired: true,
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            // Role-specific fields
            if (widget.role == 'student' ||
                widget.role == 'teacher' ||
                widget.role == 'parent') ...[
              AdminHelper.buildTextField(
                'Phone',
                _phoneCtrl,
                type: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              AdminHelper.buildTextField('Address', _addressCtrl),
              const SizedBox(height: 12),
            ],

            if (widget.role == 'teacher') ...[
              AdminHelper.buildTextField('Qualification', _qualCtrl),
              const SizedBox(height: 12),
              AdminHelper.buildTextField(
                'Subject Specialization',
                _subjectCtrl,
              ),
              const SizedBox(height: 12),
            ],

            if (widget.role == 'parent') ...[
              AdminHelper.buildTextField('Occupation', _occuCtrl),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 12),

            // Save + Cancel
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _saveChanges(context, state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminHelper.roleColor(widget.role),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _isEditMode = false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // WIDGETS 
  // ═══════════════════════════════════════
  Widget _buildStudentInfo(AdminStudentModel s) {
    return _buildSection('Student Info', [
      _buildInfoRow(Icons.badge_outlined, s.studentId, Colors.blue),
      _buildInfoRow(
        Icons.calendar_today_outlined,
        'Born: ${_formatDate(s.dateOfBirth)}',
        Colors.purple,
      ),
      _buildInfoRow(Icons.person_outline, s.gender.capitalize(), Colors.teal),
      if (s.phone.isNotEmpty)
        _buildInfoRow(Icons.phone_outlined, s.phone, Colors.green),
      if (s.address.isNotEmpty)
        _buildInfoRow(Icons.location_on_outlined, s.address, Colors.orange),
      _buildInfoRow(
        Icons.school_outlined,
        'Enrolled: ${_formatDate(s.enrollmentDate)}',
        Colors.indigo,
      ),
    ]);
  }

  Widget _buildTeacherInfo(AdminTeacherModel t) {
    return _buildSection('Teacher Info', [
      _buildInfoRow(Icons.badge_outlined, t.teacherId, Colors.teal),
      _buildInfoRow(
        Icons.menu_book_outlined,
        t.subjectSpecialization,
        Colors.blue,
      ),
      _buildInfoRow(Icons.school_outlined, t.qualification, Colors.purple),
      _buildInfoRow(
        Icons.calendar_today_outlined,
        'Hired: ${_formatDate(t.hireDate)}',
        Colors.green,
      ),
      _buildInfoRow(Icons.person_outline, t.gender.capitalize(), Colors.indigo),
      if (t.phone.isNotEmpty)
        _buildInfoRow(Icons.phone_outlined, t.phone, Colors.orange),
      if (t.address.isNotEmpty)
        _buildInfoRow(Icons.location_on_outlined, t.address, Colors.red),
    ]);
  }

  Widget _buildParentInfo(AdminParentModel p) {
    return _buildSection('Parent Info', [
      _buildInfoRow(Icons.badge_outlined, p.parentId, Colors.orange),
      _buildInfoRow(Icons.work_outline, p.occupation, Colors.blue),
      if (p.phone.isNotEmpty)
        _buildInfoRow(Icons.phone_outlined, p.phone, Colors.green),
      if (p.address.isNotEmpty)
        _buildInfoRow(Icons.location_on_outlined, p.address, Colors.purple),
    ]);
  }

  Widget _buildSection(String title, List<Widget> rows) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AdminHelper.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value, Color color) {
    if (value.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}

extension StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
