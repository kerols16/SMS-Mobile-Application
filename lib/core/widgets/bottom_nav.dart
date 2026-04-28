import 'package:flutter/material.dart';

class NavItem {
  final String id;
  final String label;
  final IconData icon;

  NavItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class BottomNav extends StatelessWidget {
  final List<NavItem> items;
  final String activeTab;
  final Function(String) onTabChange;

  const BottomNav({
    super.key,
    required this.items,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            final isActive = activeTab == item.id;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabChange(item.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF2563EB)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.icon,
                          size: 20,
                          color: isActive
                              ? Colors.white
                              : Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive
                              ? const Color(0xFF2563EB)
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}