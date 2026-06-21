// ═══ FILE: lib/features/teacher/view/tabs/messages_tab.dart ═══
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_test/features/teacher/data/models/teacher_message_model.dart';
import 'package:school_test/features/teacher/view_model/cubit/teacher_cubit.dart';

class MessagesTab extends StatefulWidget {
  final TeacherLoaded state;
  final TeacherCubit cubit;

  const MessagesTab({super.key, required this.state, required this.cubit});

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              Row(
                children: [
                  if (widget.state.unreadMessageCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.state.unreadMessageCount} unread',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF2563EB)),
                      ),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showComposeDialog(context),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Compose'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.state.messages.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: Text('No messages yet', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...widget.state.messages.map((msg) => _buildMessageCard(msg)),
        ]),
      ),
    );
  }

  Widget _buildMessageCard(TeacherMessageModel message) {
    final isUnread = message.status == 'unread';
    final typeColor = _getTypeColor(message.type);

    return GestureDetector(
      onTap: () => _showMessageDetail(message),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnread ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isUnread ? Border.all(color: Colors.blue.shade200) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              radius: 20,
              child: Text(
                message.displayName.isNotEmpty ? message.displayName[0] : '?',
                style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          message.displayName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                            color: isUnread ? const Color(0xFF374151) : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Text(
                        _formatTime(message.createdAt),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.subject,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message.content.length > 80 ? '${message.content.substring(0, 80)}...' : message.content,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message.type.toUpperCase(),
                          style: TextStyle(fontSize: 10, color: typeColor),
                        ),
                      ),
                      if (message.studentName.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.person, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          message.studentName,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageDetail(TeacherMessageModel message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message.subject,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'From: ${message.displayName}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      _formatTime(message.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                if (message.studentName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Student: ${message.studentName}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
                const Divider(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Text(
                      message.content,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.grey.shade700,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showComposeDialog(BuildContext context) {
    String? selectedReceiverId;
    String? selectedStudentId;
    final subjectController = TextEditingController();
    final contentController = TextEditingController();
    String selectedType = 'general';
    List<Map<String, dynamic>> parents = [];
    bool isLoadingParents = true;
    String? loadError;

    final typeOptions = [
      'general',
      'academic',
      'behavioral',
      'attendance',
      'urgent',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateSheet) {
          if (isLoadingParents) {
            isLoadingParents = false;
            widget.cubit.getAvailableParents().then((data) {
              setStateSheet(() {
                parents = data;
                loadError = null;
              });
            }).catchError((error) {
              setStateSheet(() {
                loadError = 'Failed to load parents';
                parents = [];
              });
            });
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'New Message',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),

                // Parent Dropdown
                DropdownButtonFormField<String>(
                  value: selectedReceiverId,
                  decoration: const InputDecoration(
                    labelText: 'Parent *',
                    border: OutlineInputBorder(),
                  ),
                  items: isLoadingParents
                      ? [
                          const DropdownMenuItem<String>(
                            value: null,
                            enabled: false,
                            child: Text('Loading parents...'),
                          ),
                        ]
                      : loadError != null
                          ? [
                              DropdownMenuItem<String>(
                                value: null,
                                enabled: false,
                                child: Text(loadError!, style: const TextStyle(color: Colors.red)),
                              ),
                            ]
                          : parents.isEmpty
                              ? [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    enabled: false,
                                    child: Text('No parents available'),
                                  ),
                                ]
                              : parents.map((p) {
                                  // مرونة في المفاتيح
                                  final id = p['id'] ?? p['parent_id'] ?? p['userId'];
                                  final name = p['name'] ?? p['fullName'] ?? p['parentName'] ?? 'Unknown';
                                  final email = p['email'] ?? p['parentEmail'] ?? '';
                                  return DropdownMenuItem<String>(
                                    value: id?.toString(),
                                    child: Text('$name (${email.isNotEmpty ? email : 'no email'})'),
                                  );
                                }).toList(),
                  onChanged: (val) => setStateSheet(() => selectedReceiverId = val),
                  hint: const Text('Select a parent'),
                ),

                const SizedBox(height: 12),

                // Student Dropdown (optional)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Student (optional)',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(value: '', child: Text('None')),
                    ...widget.state.students.map((s) {
                      return DropdownMenuItem<String>(
                        value: s.id.toString(),
                        child: Text(s.name),
                      );
                    }),
                  ],
                  onChanged: (val) => setStateSheet(() {
                    selectedStudentId = val == '' ? null : val;
                  }),
                  hint: const Text('Select a student'),
                ),

                const SizedBox(height: 12),

                // Subject
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject *',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                // Type
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: typeOptions.map((t) {
                    return DropdownMenuItem(value: t, child: Text(t.toUpperCase()));
                  }).toList(),
                  onChanged: (val) => setStateSheet(() => selectedType = val!),
                ),

                const SizedBox(height: 12),

                // Content
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Message *',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),

                const SizedBox(height: 24),

                // Send Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // التحقق من الحقول الإجبارية
                      if (selectedReceiverId == null ||
                          subjectController.text.isEmpty ||
                          contentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // بناء الـ Payload مع تجاهل الـ null
                      final payload = {
                        'receiver_id': int.parse(selectedReceiverId!),
                        'subject': subjectController.text,
                        'content': contentController.text,
                        'type': selectedType,
                      };
                      if (selectedStudentId != null && selectedStudentId!.isNotEmpty) {
                        payload['student_id'] = int.parse(selectedStudentId!);
                      }
                      // لا نضيف reply_to لأنه غير مستخدم حالياً

                      print('📤 Sending message payload: $payload');

                      widget.cubit.sendMessage(
                        receiverId: int.parse(selectedReceiverId!),
                        studentId: selectedStudentId != null && selectedStudentId!.isNotEmpty
                            ? int.parse(selectedStudentId!)
                            : null,
                        subject: subjectController.text,
                        content: contentController.text,
                        type: selectedType,
                      );

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Send Message'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'academic':
        return Colors.blue;
      case 'urgent':
        return Colors.red;
      case 'behavioral':
        return Colors.orange;
      case 'attendance':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final diff = now.difference(dateTime);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inHours < 1) return '${diff.inMinutes}m ago';
      if (diff.inDays < 1) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return DateFormat('MMM dd').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }
}