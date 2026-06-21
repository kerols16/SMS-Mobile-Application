import 'package:flutter/material.dart';
import '../utils/admin_helper.dart';

class ProfileTab extends StatelessWidget {
  final bool isSuperAdmin;
  final VoidCallback onLogout;

  const ProfileTab({
    super.key,
    required this.isSuperAdmin,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const Text('Profile', style: AdminHelper.pageTitle),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: AdminHelper.cardDecoration(),
            child: Column(children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSuperAdmin
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
                  color: isSuperAdmin
                      ? Colors.red.shade50
                      : Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isSuperAdmin ? 'Super Admin' : 'Admin',
                  style: TextStyle(
                    fontSize: 13,
                    color: isSuperAdmin
                        ? Colors.red.shade700
                        : Colors.purple.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity, height: 56,
            child: ElevatedButton.icon(
              onPressed: onLogout,
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
}
