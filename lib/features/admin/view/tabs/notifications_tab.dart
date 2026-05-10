import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../veiw_model/cubit/admin_cubit.dart';
import '../../data/models/notification_model.dart';
import '../utils/admin_helper.dart';

class NotificationsTab extends StatelessWidget {
  final AdminLoaded state;
  final bool isSuperAdmin;

  const NotificationsTab({super.key, required this.state, required this.isSuperAdmin});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    final hasUnread = state.unreadCount > 0;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notifications (${state.unreadCount} unread)',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              if (hasUnread)
                TextButton(
                  onPressed: () => cubit.markAllRead(),
                  child: const Text('Mark all read'),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // قائمة الإشعارات
          if (state.notifications.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No notifications yet', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...state.notifications.map((notification) => _buildNotificationTile(context, notification, cubit)),

          const SizedBox(height: 100),
        ]),
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, AdminNotificationModel notification, AdminCubit cubit) {
    final isUnread = !notification.isRead;
    final color = _getTypeColor(notification.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isUnread) cubit.markOneRead(notification.id);
            // يمكنك أيضًا فتح الرابط إذا كان موجوداً
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_getIcon(notification.type), color: color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                          color: const Color(0xFF374151),
                        ),
                      ),
                    ),
                    Text(
                      _formatDate(notification.createdAt),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notification.message,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isUnread)
                      TextButton(
                        onPressed: () => cubit.markOneRead(notification.id),
                        child: const Text('Mark read', style: TextStyle(fontSize: 12)),
                      ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () => cubit.deleteNotification(notification.id),
                      child: const Text('Delete', style: TextStyle(fontSize: 12, color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'alert': return Colors.red;
      case 'warning': return Colors.orange;
      case 'success': return Colors.green;
      default: return Colors.blue;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'alert': return Icons.warning;
      case 'success': return Icons.check_circle;
      case 'info': return Icons.info;
      default: return Icons.notifications;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}';
    } catch (_) {
      return dateStr;
    }
  }
}