import 'package:flutter/material.dart';
import 'package:school_test/features/teacher/data/models/teacher_exam_model.dart';
import 'package:school_test/features/teacher/view_model/cubit/teacher_cubit.dart';

class ExamsTab extends StatefulWidget {
  final TeacherLoaded state;
  final TeacherCubit cubit;
  const ExamsTab({super.key, required this.state, required this.cubit});

  @override
  State<ExamsTab> createState() => _ExamsTabState();
}

class _ExamsTabState extends State<ExamsTab> {
  String _filter = 'all'; // all | quiz | midterm | final

  @override
  Widget build(BuildContext context) {
    final filtered = widget.state.exams.where((e) {
      if (_filter == 'all') return true;
      return e.type == _filter;
    }).toList();

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Exams', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
              ElevatedButton.icon(
                onPressed: () => _showCreateDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['all', 'quiz', 'midterm', 'final', 'other'].map((f) {
                final isSelected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                      ),
                      child: Text(f.toUpperCase(),
                          style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey.shade600)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          if (filtered.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(48),
              child: Text('No exams', style: TextStyle(color: Colors.grey)),
            ))
          else
            ...filtered.map((e) => _examCard(context, e)),

          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _examCard(BuildContext context, TeacherExamModel e) {
    final typeColor = _typeColor(e.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(e.type.toUpperCase(), style: TextStyle(fontSize: 11, color: typeColor, fontWeight: FontWeight.w600)),
              ),
              if (e.isOnline) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
                  child: Text('Online', style: TextStyle(fontSize: 11, color: Colors.blue.shade700)),
                ),
              ],
              const Spacer(),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                ],
                onSelected: (val) {
                  if (val == 'edit') _showEditDialog(context, e);
                  if (val == 'delete') _confirmDelete(context, e.id, e.name);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(e.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            children: [
              _infoChip(Icons.star, '${e.maxScore} pts', Colors.amber),
              if (e.scheduledAt != null)
                _infoChip(Icons.calendar_today, e.scheduledAt!.substring(0, 10), Colors.blue),
              if (e.durationMinutes != null)
                _infoChip(Icons.timer, '${e.durationMinutes} min', Colors.purple),
              if (e.classroomName != null)
                _infoChip(Icons.school, e.classroomName!, Colors.green),
            ],
          ),
          if (e.instructions != null && e.instructions!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(e.instructions!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'quiz': return Colors.blue;
      case 'midterm': return Colors.orange;
      case 'final': return Colors.red;
      default: return Colors.grey;
    }
  }

  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    final instructionsController = TextEditingController();
    final maxScoreController = TextEditingController(text: '100');
    final durationController = TextEditingController(text: '60');
    String selectedType = 'quiz';
    String? selectedClassroomId;
    bool isOnline = false;
    DateTime? scheduledAt;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSheet) => SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('New Exam', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Classroom *', border: OutlineInputBorder()),
                items: widget.state.classrooms.map((c) =>
                  DropdownMenuItem(value: c.id.toString(), child: Text(c.name))).toList(),
                onChanged: (val) => setStateSheet(() => selectedClassroomId = val),
              ),
              const SizedBox(height: 12),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Exam Name *', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                items: ['quiz', 'midterm', 'final', 'other'].map((t) =>
                  DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
                onChanged: (val) => setStateSheet(() => selectedType = val!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: maxScoreController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Max Score', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: durationController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration (min)', border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setStateSheet(() => scheduledAt = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        scheduledAt != null ? scheduledAt!.toString().substring(0, 10) : 'Scheduled Date (optional)',
                        style: TextStyle(color: scheduledAt != null ? Colors.black : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Online Exam'),
                value: isOnline,
                onChanged: (val) => setStateSheet(() => isOnline = val),
                contentPadding: EdgeInsets.zero,
              ),
              TextField(controller: instructionsController, decoration: const InputDecoration(labelText: 'Instructions (optional)', border: OutlineInputBorder(), alignLabelWithHint: true), maxLines: 3),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedClassroomId != null && nameController.text.isNotEmpty) {
                      widget.cubit.createExam({
                        'classroom_id': int.parse(selectedClassroomId!),
                        'name': nameController.text,
                        'type': selectedType,
                        'max_score': int.tryParse(maxScoreController.text) ?? 100,
                        'duration_minutes': int.tryParse(durationController.text) ?? 60,
                        'is_online': isOnline,
                        if (scheduledAt != null) 'scheduled_at': scheduledAt!.toIso8601String(),
                        if (instructionsController.text.isNotEmpty) 'instructions': instructionsController.text,
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                  child: const Text('Create Exam', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, TeacherExamModel e) {
    final nameController = TextEditingController(text: e.name);
    final maxScoreController = TextEditingController(text: e.maxScore.toString());
    final durationController = TextEditingController(text: e.durationMinutes?.toString() ?? '');
    final instructionsController = TextEditingController(text: e.instructions ?? '');
    bool isOnline = e.isOnline;
    String selectedType = e.type;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSheet) => SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: Text('Edit Exam', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
              const SizedBox(height: 16),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Exam Name', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                items: ['quiz', 'midterm', 'final', 'other'].map((t) =>
                  DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
                onChanged: (val) => setStateSheet(() => selectedType = val!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: maxScoreController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Max Score', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: durationController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration (min)', border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Online Exam'),
                value: isOnline,
                onChanged: (val) => setStateSheet(() => isOnline = val),
                contentPadding: EdgeInsets.zero,
              ),
              TextField(controller: instructionsController, decoration: const InputDecoration(labelText: 'Instructions', border: OutlineInputBorder(), alignLabelWithHint: true), maxLines: 3),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.cubit.updateExam(e.id, {
                      'name': nameController.text,
                      'type': selectedType,
                      'max_score': int.tryParse(maxScoreController.text) ?? e.maxScore,
                      'duration_minutes': int.tryParse(durationController.text),
                      'is_online': isOnline,
                      'instructions': instructionsController.text,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                  child: const Text('Update', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Exam'),
        content: Text('Delete "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { widget.cubit.deleteExam(id); Navigator.pop(context); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}