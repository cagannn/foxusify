import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class RoundedNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const RoundedNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _orange = Color(0xFFE87C43);
  static const _grey = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final _items = [
      _NavItemData(icon: Icons.home_outlined, label: loc.home),
      _NavItemData(icon: Icons.sort_rounded, label: loc.placement),
      _NavItemData(icon: Icons.person_outline, label: loc.profile),
    ];

    return Container(
      height: 80,
      child: SizedBox(
        width: double.infinity, // ekran genişliği kadar
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                offset: const Offset(0, 4),
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final bool isSelected = index == currentIndex;

              final color = isSelected ? _orange : _grey;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, size: 26, color: color),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({required this.icon, required this.label});
}
