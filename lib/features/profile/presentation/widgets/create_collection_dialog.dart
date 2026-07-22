import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/constants/collection_icons.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/profile/domain/entities/collection_entity.dart';
import 'package:snapspot/features/profile/presentation/blocs/collections_cubit.dart';
import 'package:snapspot/features/profile/presentation/widgets/collection_icon_picker_modal.dart';
import 'package:snapspot/features/profile/presentation/widgets/collection_color_picker_modal.dart';

/// Modal Dialog / BottomSheet cho phép người dùng Tạo mới hoặc Chỉnh sửa & Xóa Bộ sưu tập bài viết.
/// Hỗ trợ nhập Tên, chọn Icon đại diện, chọn Màu sắc, Quyền riêng tư và Xóa bộ sưu tập.
/// 100% Đa ngôn ngữ (Việt - Anh) không cứng chữ.
class CreateCollectionDialog extends StatefulWidget {
  final CollectionEntity? collection; // null = Tạo mới, non-null = Chỉnh sửa/Xóa

  const CreateCollectionDialog({super.key, this.collection});

  static Future<CollectionEntity?> show(
    BuildContext context, {
    CollectionEntity? collection,
  }) {
    return showModalBottomSheet<CollectionEntity>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Dùng AnimatedPadding để tạo hiệu ứng đẩy mượt mà (smooth animation) khi bàn phím xuất hiện
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: bottomInset),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          child: CreateCollectionDialog(collection: collection),
        );
      },
    );
  }

  @override
  State<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  late String _selectedIcon;
  late String _selectedColor;
  late bool _isPrivate;

  bool get _isEditMode => widget.collection != null;

  final List<Map<String, dynamic>> _iconOptions = [
    {'name': 'bookmark', 'icon': Icons.bookmark_rounded},
    {'name': 'heart', 'icon': Icons.favorite_rounded},
    {'name': 'map', 'icon': Icons.map_rounded},
    {'name': 'cafe', 'icon': Icons.local_cafe_rounded},
    {'name': 'camera', 'icon': Icons.photo_camera_rounded},
    {'name': 'explore', 'icon': Icons.explore_rounded},
    {'name': 'star', 'icon': Icons.star_rounded},
  ];

  final List<String> _colorOptions = [
    '#FF6F61', // Coral Red
    '#007AFF', // Electric Blue
    '#FF9500', // Warm Orange
    '#AF52DE', // Deep Purple
    '#34C759', // Emerald Green
    '#FF2D55', // Hot Pink
    '#FFCC00', // Sunflower Yellow
    '#30B0C7', // Cyan Teal
    '#8B5CF6', // Lavender
    '#EC4899', // Rose Pink
    '#F43F5E', // Salmon
    '#10B981', // Mint Green
    '#6366F1', // Indigo
    '#D97706', // Amber
    '#EAB308', // Gold
    '#374151', // Charcoal
  ];

  @override
  void initState() {
    super.initState();
    final col = widget.collection;
    _nameController = TextEditingController(text: col?.name ?? '');
    _selectedIcon = col?.iconName ?? 'bookmark';
    _selectedColor = col?.colorHex ?? '#FF6F61';
    _isPrivate = col?.isPrivate ?? false;
  }

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  String _getIconLabel(String iconName) {
    for (final cat in AppCollectionIcons.iconCategories) {
      final icons = cat['icons'] as List<Map<String, dynamic>>;
      for (final item in icons) {
        if (item['name'] == iconName) {
          return item['label'] as String;
        }
      }
    }
    return '';
  }

  /// Danh sách Icon hiển thị: Đưa Icon ĐANG ĐƯỢC CHỌN LÊN VỊ TRÍ ĐẦU TIÊN (Index 0)
  List<String> get _displayIcons {
    final list = <String>[_selectedIcon];
    for (final opt in _iconOptions) {
      final name = opt['name'] as String;
      if (name != _selectedIcon && !list.contains(name)) {
        list.add(name);
      }
    }
    return list;
  }

  /// Danh sách Màu hiển thị: Đưa Màu ĐANG ĐƯỢC CHỌN LÊN VỊ TRÍ ĐẦU TIÊN (Index 0)
  List<String> get _displayColors {
    final list = <String>[_selectedColor];
    for (final hex in _colorOptions) {
      if (hex != _selectedColor && !list.contains(hex)) {
        list.add(hex);
      }
    }
    return list;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.mediumImpact();
      final cubit = context.read<CollectionsCubit>();

      CollectionEntity? result;
      if (_isEditMode) {
        result = await cubit.updateCollection(
          id: widget.collection!.id,
          name: _nameController.text.trim(),
          iconName: _selectedIcon,
          colorHex: _selectedColor,
          isPrivate: _isPrivate,
        );
      } else {
        result = await cubit.createCollection(
          name: _nameController.text.trim(),
          iconName: _selectedIcon,
          colorHex: _selectedColor,
          isPrivate: _isPrivate,
        );
      }

      if (mounted && result != null) {
        Navigator.pop(context, result);
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr('delete_collection_title'), style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          context.tr('delete_collection_confirm', args: {'name': widget.collection?.name ?? ''}),
          style: const TextStyle(fontSize: 14.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(context.tr('cancel'), style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              HapticFeedback.mediumImpact();
              final cubit = context.read<CollectionsCubit>();
              await cubit.deleteCollection(widget.collection!.id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.tr('deleted_collection_msg', args: {'name': widget.collection?.name ?? ''})),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(context.tr('delete_action'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _openCustomColorPicker() async {
    HapticFeedback.mediumImpact();
    final newColor = await CollectionColorPickerModal.show(
      context,
      currentColorHex: _selectedColor,
    );
    if (newColor != null && mounted) {
      setState(() => _selectedColor = newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: isLight ? Colors.white : AppColors.surfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              // 1. Header: Drag Handle & Title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  children: [
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
                    Text(
                      _isEditMode ? context.tr('edit_collection_title') : context.tr('create_collection_title'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Scrollable Body: Form Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Ô nhập tên bộ sưu tập (100% Đa ngôn ngữ)
                        Text(
                          context.tr('collection_name'),
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: context.tr('collection_name_hint'),
                            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                            filled: true,
                            fillColor: isLight ? Colors.grey[100] : Colors.grey[900],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return context.tr('collection_name_required');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Gợi ý tạo chủ đề nhanh (Quick Presets - Đa ngôn ngữ)
                        Text(
                          context.tr('quick_presets_title'),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildQuickPresetChip(
                                label: context.tr('preset_cafe_label'),
                                name: context.tr('preset_cafe_name'),
                                icon: 'cafe',
                                color: '#FF9500',
                              ),
                              _buildQuickPresetChip(
                                label: context.tr('preset_travel_label'),
                                name: context.tr('preset_travel_name'),
                                icon: 'explore',
                                color: '#34C759',
                              ),
                              _buildQuickPresetChip(
                                label: context.tr('preset_photo_label'),
                                name: context.tr('preset_photo_name'),
                                icon: 'camera',
                                color: '#AF52DE',
                              ),
                              _buildQuickPresetChip(
                                label: context.tr('preset_places_label'),
                                name: context.tr('preset_places_name'),
                                icon: 'map',
                                color: '#007AFF',
                              ),
                              _buildQuickPresetChip(
                                label: context.tr('preset_favorites_label'),
                                name: context.tr('preset_favorites_name'),
                                icon: 'heart',
                                color: '#FF3B30',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 2. Chọn Icon đại diện (100% Đa ngôn ngữ & Kho Icon mở rộng)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  context.tr('collection_icon'),
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                                  ),
                                ),
                                if (_getIconLabel(_selectedIcon).isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _parseColor(_selectedColor).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _getIconLabel(_selectedIcon),
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: _parseColor(_selectedColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                HapticFeedback.mediumImpact();
                                final iconName = await CollectionIconPickerModal.show(
                                  context,
                                  currentIconName: _selectedIcon,
                                  themeColor: _parseColor(_selectedColor),
                                );
                                if (iconName != null && mounted) {
                                  setState(() => _selectedIcon = iconName);
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Row(
                                  children: [
                                    const Icon(Icons.grid_view_rounded, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      context.tr('explore_icons'),
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _displayIcons.map((name) {
                              final icon = AppCollectionIcons.getIcon(name);
                              final isSelected = _selectedIcon == name;
                              final color = _parseColor(_selectedColor);

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    setState(() => _selectedIcon = name);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? color : (isLight ? Colors.grey[300]! : Colors.grey[700]!),
                                        width: isSelected ? 2.0 : 1.0,
                                      ),
                                    ),
                                    child: Icon(
                                      icon,
                                      size: 20,
                                      color: isSelected ? color : (isLight ? Colors.grey[600] : Colors.grey[400]),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 3. Chọn Bảng màu sắc (100% Đa ngôn ngữ & 16 Màu mở rộng + Tự chọn Hex)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.tr('collection_color'),
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                              ),
                            ),
                            InkWell(
                              onTap: _openCustomColorPicker,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Row(
                                  children: [
                                    const Icon(Icons.palette_rounded, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      context.tr('custom_color_btn'),
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _displayColors.map((hex) {
                              final isSelected = _selectedColor == hex;
                              final color = _parseColor(hex);

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    setState(() => _selectedColor = hex);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: isSelected
                                          ? Border.all(color: isLight ? Colors.black : Colors.white, width: 2.5)
                                          : null,
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 4. Quyền riêng tư (Bộ sưu tập riêng tư - Premium Theme Card & 100% Đa ngôn ngữ)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: _isPrivate
                                ? _parseColor(_selectedColor).withValues(alpha: 0.08)
                                : (isLight ? Colors.grey[50] : Colors.grey[900]),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isPrivate
                                  ? _parseColor(_selectedColor).withValues(alpha: 0.35)
                                  : (isLight ? Colors.grey[200]! : Colors.grey[800]!),
                              width: _isPrivate ? 1.5 : 1.0,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _isPrivate = !_isPrivate);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                child: Row(
                                  children: [
                                    // Animated Dynamic Icon Badge
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      padding: const EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: _isPrivate
                                            ? _parseColor(_selectedColor).withValues(alpha: 0.16)
                                            : (isLight ? Colors.grey[200] : Colors.grey[800]),
                                        shape: BoxShape.circle,
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 200),
                                        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                                        child: Icon(
                                          _isPrivate ? Icons.lock_rounded : Icons.public_rounded,
                                          key: ValueKey<bool>(_isPrivate),
                                          size: 19,
                                          color: _isPrivate
                                              ? _parseColor(_selectedColor)
                                              : (isLight ? Colors.grey[600] : Colors.grey[400]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Title + Subtitle + Status Tag Badge
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  context.tr('private_collection'),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: isLight
                                                        ? AppColors.textLightPrimary
                                                        : AppColors.textDarkPrimary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              AnimatedContainer(
                                                duration: const Duration(milliseconds: 250),
                                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: _isPrivate
                                                      ? _parseColor(_selectedColor).withValues(alpha: 0.15)
                                                      : (isLight ? Colors.grey[200] : Colors.grey[800]),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  _isPrivate ? context.tr('only_you') : context.tr('public'),
                                                  style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: _isPrivate
                                                        ? _parseColor(_selectedColor)
                                                        : (isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            context.tr('private_collection_desc'),
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: isLight
                                                  ? AppColors.textLightSecondary
                                                  : AppColors.textDarkSecondary,
                                              height: 1.25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Switch Control
                                    Switch.adaptive(
                                      value: _isPrivate,
                                      activeColor: _parseColor(_selectedColor),
                                      onChanged: (val) {
                                        HapticFeedback.selectionClick();
                                        setState(() => _isPrivate = val);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Footer Action Bar: Pinned Submit & Delete buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _parseColor(_selectedColor),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _isEditMode ? context.tr('save_changes') : context.tr('create_collection_btn'),
                        style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (_isEditMode) ...[
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _confirmDelete,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error, width: 1),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: Text(
                          context.tr('delete_collection_title'),
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

  Widget _buildQuickPresetChip({
    required String label,
    required String name,
    required String icon,
    required String color,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
        ),
        backgroundColor: isLight ? Colors.grey[100] : Colors.grey[800],
        side: BorderSide(
          color: isLight ? Colors.grey[300]! : Colors.grey[700]!,
        ),
        onPressed: () {
          HapticFeedback.selectionClick();
          setState(() {
            _nameController.text = name;
            _selectedIcon = icon;
            _selectedColor = color;
          });
        },
      ),
    );
  }
}
