import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';

/// Modal Hộp thoại Kho Màu Sắc Trực Quan (Categorized Color Palette Modal).
/// Cho phép Người dùng lựa chọn màu sắc trực quan qua các bảng màu sinh động mà không cần ghi nhớ mã màu.
class CollectionColorPickerModal extends StatefulWidget {
  final String selectedColorHex;

  const CollectionColorPickerModal({
    super.key,
    required this.selectedColorHex,
  });

  static Future<String?> show(
    BuildContext context, {
    required String currentColorHex,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true, // Phủ đè trên Bottom Navigation Bar
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CollectionColorPickerModal(
        selectedColorHex: currentColorHex,
      ),
    );
  }

  @override
  State<CollectionColorPickerModal> createState() => _CollectionColorPickerModalState();
}

class _CollectionColorPickerModalState extends State<CollectionColorPickerModal>
    with SingleTickerProviderStateMixin {
  late String _currentSelected;
  late TabController _tabController;

  static final List<Map<String, dynamic>> _colorCategories = [
    {
      'categoryKey': 'cat_warm',
      'categoryName': 'Rực rỡ',
      'colors': [
        '#FF6F61', '#FF5722', '#F43F5E', '#E11D48',
        '#FF3B30', '#FF9500', '#D97706', '#B45309',
        '#EC4899', '#DB2777', '#BE185D', '#9F1239',
      ],
    },
    {
      'categoryKey': 'cat_ocean',
      'categoryName': 'Đại dương',
      'colors': [
        '#007AFF', '#0284C7', '#38BDF8', '#30B0C7',
        '#0EA5E9', '#2563EB', '#1D4ED8', '#1E40AF',
        '#6366F1', '#4F46E5', '#4338CA', '#3730A3',
      ],
    },
    {
      'categoryKey': 'cat_nature',
      'categoryName': 'Tự nhiên',
      'colors': [
        '#34C759', '#10B981', '#059669', '#047857',
        '#84CC16', '#65A30D', '#16A34A', '#15803D',
        '#14B8A6', '#0D9488', '#0F766E', '#115E59',
      ],
    },
    {
      'categoryKey': 'cat_mono',
      'categoryName': 'Tối giản',
      'colors': [
        '#AF52DE', '#8B5CF6', '#7C3AED', '#6D28D9',
        '#FFCC00', '#EAB308', '#F59E0B', '#D97706',
        '#374151', '#4B5563', '#1E293B', '#000000',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.selectedColorHex;

    // Tự động tìm Tab chứa màu đang chọn
    int initialCategoryIndex = 0;
    for (int i = 0; i < _colorCategories.length; i++) {
      final colors = _colorCategories[i]['colors'] as List<String>;
      if (colors.contains(_currentSelected)) {
        initialCategoryIndex = i;
        break;
      }
    }

    _tabController = TabController(
      length: _colorCategories.length,
      initialIndex: initialCategoryIndex,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final activeColor = _parseColor(_currentSelected);
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

            // Modal Header với Live Color Preview Badge
            Row(
              children: [
                const Icon(Icons.palette_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  context.tr('color_palette'),
                  style: TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                // Live Hex Code display badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: activeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _currentSelected.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: activeColor,
                    ),
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

            // Category Clean Material TabBar (Hiển thị CHỮ ĐẦY ĐỦ 100%, 4 Tab phân bổ ĐỀU NHAU 100%)
            TabBar(
              controller: _tabController,
              isScrollable: false, // 4 Tab phân bổ ĐỀU NHAU 100% chuẩn Kho biểu tượng
              labelColor: activeColor,
              unselectedLabelColor: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
              labelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
              indicatorColor: activeColor,
              indicatorWeight: 3.0,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: isLight ? Colors.grey[200] : Colors.grey[800],
              tabs: _colorCategories.map((cat) {
                final name = cat['categoryName'] as String;
                return Tab(
                  height: 40,
                  text: name,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // GridView hiển thị bảng ô màu sắc trực quan
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: _colorCategories.map((cat) {
                  final colors = cat['colors'] as List<String>;

                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      final hex = colors[index];
                      final isSelected = _currentSelected == hex;
                      final color = _parseColor(hex);

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            HapticFeedback.selectionClick();
                            final nav = Navigator.of(context);
                            setState(() => _currentSelected = hex);
                            await Future.delayed(const Duration(milliseconds: 120));
                            if (mounted) {
                              nav.pop(hex);
                            }
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.45),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                              ],
                              border: isSelected
                                  ? Border.all(color: isLight ? Colors.black : Colors.white, width: 3.0)
                                  : Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.0),
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  )
                                : null,
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
