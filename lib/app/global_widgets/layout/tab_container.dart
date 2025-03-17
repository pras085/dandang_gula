import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class TabItem {
  final String title;
  final Widget content;
  final IconData? icon;

  TabItem({
    required this.title,
    required this.content,
    this.icon,
  });
}

class TabContainer extends StatefulWidget {
  final List<TabItem> tabs;
  final Color activeTabColor;
  final Color inactiveTabColor;
  final Color backgroundColor;
  final double height;
  final double tabHeight;
  final double borderRadius;
  final bool maintainState;
  final ValueChanged<int>? onTabChanged;
  final int initialIndex;

  const TabContainer({
    super.key,
    required this.tabs,
    this.activeTabColor = AppColors.primary,
    this.inactiveTabColor = AppColors.background,
    this.backgroundColor = const Color(0xFFE6E6E6),
    this.height = 600, // Default height or null for flexible height
    this.tabHeight = 42,
    this.borderRadius = 16,
    this.maintainState = true,
    this.onTabChanged,
    this.initialIndex = 0,
  });

  @override
  State<TabContainer> createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
        if (widget.onTabChanged != null) {
          widget.onTabChanged!(_tabController.index);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom tab bar
        Container(
          width: double.infinity,
          height: widget.tabHeight,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Row(
            children: widget.tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = index == _currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(widget.borderRadius - 4),
                      boxShadow: isSelected
                          ? [
                              const BoxShadow(
                                color: Color.fromRGBO(152, 152, 152, 0.12),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (tab.icon != null) ...[
                          Icon(
                            tab.icon,
                            color: isSelected ? widget.activeTabColor : AppColors.textSecondary,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          tab.title,
                          style: AppTextStyles.contentLabel.copyWith(
                            color: const Color(0xFF0C4123),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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

        // Tab content
        widget.tabs[_currentIndex].content,
      ],
    );
  }
}
