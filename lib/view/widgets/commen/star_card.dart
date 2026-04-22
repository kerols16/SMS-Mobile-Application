import 'package:flutter/material.dart';
import 'package:school_test/data/constents/app_colors.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final IconData? trend;
  final IconData? alert;
  final String? badge;

  const StatCard({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    this.trend,
    this.alert,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 32),
              if (trend != null)
                Icon(trend, color: AppColors.success, size: 16)
              else if (alert != null)
                Icon(alert, color: AppColors.error, size: 16)
              else if (badge != null)
                  Text(
                    badge!,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}