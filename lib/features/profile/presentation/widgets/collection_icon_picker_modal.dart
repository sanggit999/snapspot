import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/constants/collection_icons.dart';
import 'package:snapspot/core/localization/app_localizations.dart';

/// Modal kho biểu tượng phong phú (Categorized Icon Catalog) cho phép Người dùng lựa chọn Icon cá nhân hóa.
class CollectionIconPickerModal extends StatefulWidget {
  final String selectedIconName;
  final Color themeColor;

  const CollectionIconPickerModal({
    super.key,
    required this.selectedIconName,
    required this.themeColor,
  });

  static Future<String?> show(
    BuildContext context, {
    required String currentIconName,
    required Color themeColor,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true, // Hiển thị đè đè trên Bottom Navigation Bar
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CollectionIconPickerModal(
        selectedIconName: currentIconName,
        themeColor: themeColor,
      ),
    );
  }

  @override
  State<CollectionIconPickerModal> createState() => _CollectionIconPickerModalState();
}

class _CollectionIconPickerModalState extends State<CollectionIconPickerModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _currentSelected;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.selectedIconName;

    // Tự động tìm Tab danh mục chứa biểu tượng đang được chọn
    int initialCategoryIndex = 0;
    for (int i = 0; i < AppCollectionIcons.iconCategories.length; i++) {
      final icons = AppCollectionIcons.iconCategories[i]['icons'] as List<Map<String, dynamic>>;
      if (icons.any((item) => item['name'] == _currentSelected)) {
        initialCategoryIndex = i;
        break;
      }
    }

    _tabController = TabController(
      length: AppCollectionIcons.iconCategories.length,
      initialIndex: initialCategoryIndex,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final maxHeight = MediaQuery.of(context).size.height * 0.70;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : AppColors.surfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isLight ? Colors.grey[300] : Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Modal Title ngắn gọn: Kho biểu tượng
            Row(
              children: [
                const Icon(Icons.grid_view_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  context.tr('explore_icons'),
                  style: TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Category Clean Material TabBar (Hiển thị CHỮ ĐẦY ĐỦ 100%, không kèm Icon)
            TabBar(
              controller: _tabController,
              isScrollable: false, // 4 Tab phân bổ ĐỀU NHAU 100%
              labelColor: widget.themeColor,
              unselectedLabelColor: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
              labelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
              indicatorColor: widget.themeColor,
              indicatorWeight: 3.0,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: isLight ? Colors.grey[200] : Colors.grey[800],
              tabs: AppCollectionIcons.iconCategories.map((cat) {
                final name = cat['categoryName'] as String;
                return Tab(
                  height: 40,
                  text: name,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Icon Grid Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: AppCollectionIcons.iconCategories.map((cat) {
                  final icons = cat['icons'] as List<Map<String, dynamic>>;

                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: icons.length,
                    itemBuilder: (context, index) {
                      final item = icons[index];
                      final name = item['name'] as String;
                      final iconData = item['icon'] as IconData;
                      final label = item['label'] as String;
                      final isSelected = _currentSelected == name;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            HapticFeedback.selectionClick();
                            final nav = Navigator.of(context);
                            setState(() => _currentSelected = name);
                            // Micro-delay 120ms để người dùng cảm nhận hiệu ứng chọn trước khi đóng modal
                            await Future.delayed(const Duration(milliseconds: 120));
                            if (mounted) {
                              nav.pop(name);
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? widget.themeColor.withValues(alpha: 0.15)
                                  : (isLight ? Colors.grey[100] : Colors.grey[850]),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? widget.themeColor
                                    : (isLight ? Colors.grey[300]! : Colors.grey[700]!),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      iconData,
                                      size: 26,
                                      color: isSelected
                                          ? widget.themeColor
                                          : (isLight ? Colors.grey[800] : Colors.grey[200]),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected
                                            ? widget.themeColor
                                            : (isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      size: 14,
                                      color: widget.themeColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
