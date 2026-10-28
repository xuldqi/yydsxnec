import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../data/brands_data.dart';
import '../models/brand.dart';
import '../models/drink_record.dart';
import '../services/database_service.dart';
import '../services/record_draft_service.dart';
import '../services/record_change_notifier.dart';
import '../services/session_service.dart';
import '../services/achievement_service.dart';
import '../services/database_service.dart';
import '../services/local_outline_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/capwords_sticker_stage.dart';
import '../utils/navigation_helper.dart';
import '../widgets/wheel_time_picker_sheet.dart';

class RecordPage extends StatefulWidget {
  final Map<String, dynamic>? prefill;
  const RecordPage({super.key, this.prefill});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _QuickDrinkType {
  final String label;
  final String recordName;
  final String category;
  final IconData icon;
  final Color color;
  final double sugarPer100ml;
  final double caloriesPer100ml;
  final double caffeinePer100ml;

  const _QuickDrinkType({
    required this.label,
    required this.recordName,
    required this.category,
    required this.icon,
    required this.color,
    this.sugarPer100ml = 0,
    this.caloriesPer100ml = 0,
    this.caffeinePer100ml = 0,
  });
}

class _RecordPageState extends State<RecordPage> {
  final _formKey = GlobalKey<FormState>();
  final RecordDraftService _recordDraftService = RecordDraftService();
  final ImagePicker _imagePicker = ImagePicker();

  // 表单控制器
  final _nameController = TextEditingController();
  final _volumeController = TextEditingController();
  final _sugarController = TextEditingController();
  final _fatController = TextEditingController();
  final _proteinController = TextEditingController();
  final _caffeineController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _brandFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();

  String _selectedCategory = '白开水';
  String _selectedSize = '中杯';
  String _selectedWaterType = '大杯';
  int _selectedWaterVolume = 300;
  DateTime _selectedRecordTime = DateTime.now();
  final _noteController = TextEditingController();
  String? _selectedImagePath;
  bool _hasChangedPhoto = false;
  bool _isProcessingPhoto = false;
  bool _enableCutout = true;
  bool _suppressBrandTextListener = false;
  List<BrandPreset> _brandOptions = brandPresets;

  final List<String> _categories = ['奶茶', '果茶', '咖啡', '白开水', '瓶装饮品', '其他'];
  final List<String> _sizes = ['小杯', '中杯', '大杯', '超大杯'];
  final List<_QuickDrinkType> _quickDrinkTypes = const [
    _QuickDrinkType(
      label: '水',
      recordName: '水',
      category: '白开水',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF45B7D1),
    ),
    _QuickDrinkType(
      label: '茶',
      recordName: '茶',
      category: '其他',
      icon: Icons.emoji_food_beverage_rounded,
      color: Color(0xFF39B77A),
      caffeinePer100ml: 12,
    ),
    _QuickDrinkType(
      label: '绿茶',
      recordName: '绿茶',
      category: '其他',
      icon: Icons.emoji_food_beverage_rounded,
      color: Color(0xFF31A66A),
      caffeinePer100ml: 14,
    ),
    _QuickDrinkType(
      label: '红茶',
      recordName: '红茶',
      category: '其他',
      icon: Icons.emoji_food_beverage_rounded,
      color: Color(0xFFB65B3B),
      caffeinePer100ml: 18,
    ),
    _QuickDrinkType(
      label: '乌龙茶',
      recordName: '乌龙茶',
      category: '其他',
      icon: Icons.emoji_food_beverage_rounded,
      color: Color(0xFF7AA35A),
      caffeinePer100ml: 16,
    ),
    _QuickDrinkType(
      label: '咖啡',
      recordName: '咖啡',
      category: '咖啡',
      icon: Icons.coffee_rounded,
      color: Color(0xFF8B5E3C),
      caffeinePer100ml: 35,
    ),
    _QuickDrinkType(
      label: '可乐',
      recordName: '可乐',
      category: '瓶装饮品',
      icon: Icons.local_bar_rounded,
      color: Color(0xFFD46A54),
      sugarPer100ml: 10.6,
      caloriesPer100ml: 43,
      caffeinePer100ml: 10,
    ),
    _QuickDrinkType(
      label: '苏打水',
      recordName: '苏打水',
      category: '白开水',
      icon: Icons.bubble_chart_rounded,
      color: Color(0xFF58AFCB),
    ),
    _QuickDrinkType(
      label: '果汁',
      recordName: '果汁',
      category: '果茶',
      icon: Icons.local_drink_rounded,
      color: Color(0xFFF28C3C),
      sugarPer100ml: 9,
      caloriesPer100ml: 42,
    ),
    _QuickDrinkType(
      label: '运动饮料',
      recordName: '运动饮料',
      category: '瓶装饮品',
      icon: Icons.sports_bar_rounded,
      color: Color(0xFF47A76A),
      sugarPer100ml: 5,
      caloriesPer100ml: 24,
    ),
    _QuickDrinkType(
      label: '瓶装饮品',
      recordName: '瓶装饮品',
      category: '瓶装饮品',
      icon: Icons.local_drink_rounded,
      color: Color(0xFFF2A33B),
    ),
  ];

  List<String> get _brandSuggestions {
    return _brandOptions.map((brand) => brand.name).toSet().toList();
  }

  BrandPreset? get _selectedBrandOption {
    final brandName = _brandController.text.trim();
    if (brandName.isEmpty) return null;
    for (final brand in _brandOptions) {
      if (brand.name == brandName) return brand;
    }
    return null;
  }

  List<ProductPreset> get _selectedBrandProducts {
    return _selectedBrandOption?.products ?? const [];
  }

  List<String> get _drinkNameSuggestions {
    final suggestions = <String>{};
    final brandProducts = _selectedBrandProducts;
    if (brandProducts.isNotEmpty) {
      suggestions.addAll(brandProducts.map((product) => product.name));
    } else {
      for (final brand in _brandOptions) {
        suggestions.addAll(brand.products.map((product) => product.name));
      }
    }
    suggestions.addAll(_quickDrinkTypes.map((type) => type.recordName));
    return suggestions.toList(growable: false);
  }

  String? get _recordImagePath {
    final imagePath = _selectedImagePath?.trim();
    return imagePath == null || imagePath.isEmpty ? null : imagePath;
  }

  @override
  void initState() {
    super.initState();
    _brandController.addListener(_handleBrandInputChanged);
    _loadBrandOptions();
    if (widget.prefill != null) {
      _nameController.text = widget.prefill!['name']?.toString() ?? '';
      _brandController.text = widget.prefill!['brand']?.toString() ?? '';

      final vol = widget.prefill!['volume'];
      if (vol != null) {
        final volumeValue = vol is num
            ? vol.round()
            : int.tryParse(vol.toString());
        if (volumeValue != null && volumeValue > 0) {
          _volumeController.text = volumeValue.toString();
          _selectedWaterVolume = volumeValue.clamp(100, 2000).toInt();
          _selectedWaterType = '${_selectedWaterVolume}ml';
        } else if (volumeValue == null && vol.toString().trim().isNotEmpty) {
          _volumeController.text = vol.toString();
        }
      }

      final cal = widget.prefill!['calories'];
      if (cal != null) {
        final calorieValue = cal is num
            ? cal.round()
            : int.tryParse(cal.toString());
        if (calorieValue != null && calorieValue > 0) {
          _caloriesController.text = calorieValue.toString();
        }
      }

      final caf = widget.prefill!['caffeine'];
      if (caf != null) {
        final caffeineValue = caf is num
            ? caf.round()
            : int.tryParse(caf.toString());
        if (caffeineValue != null && caffeineValue > 0) {
          _caffeineController.text = caffeineValue.toString();
        }
      }

      final cat = widget.prefill!['category']?.toString();
      if (cat != null && _categories.contains(cat)) {
        _selectedCategory = cat;
      }
      if (cat != null && cat.isNotEmpty) {
        _typeController.text = cat == '白开水' ? '水' : cat;
      }

      // 额外加载配方与价格字段用于编辑
      final priceVal = widget.prefill!['price'];
      if (priceVal != null) {
        _priceController.text = priceVal.toString();
      }

      final sugarVal = widget.prefill!['sugar'];
      if (sugarVal != null) {
        _sugarController.text = sugarVal.toString();
      }

      final fatVal = widget.prefill!['fat'];
      if (fatVal != null) {
        _fatController.text = fatVal.toString();
      }

      final proteinVal = widget.prefill!['protein'];
      if (proteinVal != null) {
        _proteinController.text = proteinVal.toString();
      }

      final sz = widget.prefill!['size']?.toString();
      if (sz != null && _sizes.contains(sz)) {
        _selectedSize = sz;
      }

      final img = widget.prefill!['imagePath']?.toString();
      if (img != null && img.isNotEmpty) {
        _selectedImagePath = img;
      }

      final recordTime = widget.prefill!['recordTime'];
      if (recordTime is DateTime) {
        _selectedRecordTime = recordTime;
      } else if (recordTime is int) {
        _selectedRecordTime = DateTime.fromMillisecondsSinceEpoch(recordTime);
      }
    }
  }

  @override
  void dispose() {
    _brandController.removeListener(_handleBrandInputChanged);
    _nameController.dispose();
    _volumeController.dispose();
    _sugarController.dispose();
    _fatController.dispose();
    _proteinController.dispose();
    _caffeineController.dispose();
    _caloriesController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _typeController.dispose();
    _nameFocusNode.dispose();
    _brandFocusNode.dispose();
    _typeFocusNode.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _handleBrandInputChanged() {
    if (_suppressBrandTextListener) return;
    if (!mounted) return;
    setState(() {});
  }

  void _setBrandText(String value) {
    _suppressBrandTextListener = true;
    _brandController.text = value;
    _suppressBrandTextListener = false;
  }

  Future<void> _loadBrandOptions() async {
    try {
      final userId = await SessionService.getCurrentUserId();
      final customBrands = userId == null
          ? <BrandPreset>[]
          : await DatabaseService().getCustomBrands(userId);
      if (!mounted) return;
      setState(() {
        _brandOptions = _mergeBrands(customBrands, brandPresets);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _brandOptions = brandPresets;
      });
    }
  }

  List<BrandPreset> _mergeBrands(
    List<BrandPreset> customBrands,
    List<BrandPreset> presets,
  ) {
    final customById = {for (final brand in customBrands) brand.id: brand};
    final merged = <BrandPreset>[
      for (final brand in presets) customById.remove(brand.id) ?? brand,
    ];
    merged.insertAll(0, customById.values);
    return merged;
  }

  Future<void> _saveWaterRecord() async {
    try {
      final recordName = _nameController.text.trim();
      final typeText = _typeController.text.trim();
      if (recordName.isEmpty) {
        _showBottomPill('先输入喝了什么');
        return;
      }

      var userId = await SessionService.getCurrentUserId();
      userId ??= (await SessionService.ensureLocalUser()).id;
      final quickDrink = _matchedQuickDrinkType;
      final scale = _selectedWaterVolume / 100;
      final sugar = double.tryParse(_sugarController.text);
      final fat = double.tryParse(_fatController.text);
      final protein = double.tryParse(_proteinController.text);
      final caffeine = double.tryParse(_caffeineController.text);
      final calories = double.tryParse(_caloriesController.text);

      final brandName = _brandController.text.trim();
      final inferredCategory = typeText.isNotEmpty
          ? _inferCategory(typeText, brandName: brandName)
          : _inferCategory(recordName, brandName: brandName);

      final record = DrinkRecord(
        name: recordName,
        category: quickDrink?.category ?? inferredCategory,
        volume: _selectedWaterVolume.toDouble(),
        size: _selectedWaterType,
        sugar: sugar ?? (quickDrink?.sugarPer100ml ?? 0) * scale,
        fat: fat ?? 0,
        protein: protein ?? 0,
        caffeine: caffeine ?? (quickDrink?.caffeinePer100ml ?? 0) * scale,
        calories: calories ?? (quickDrink?.caloriesPer100ml ?? 0) * scale,
        imagePath: _recordImagePath,
        recordTime: _selectedRecordTime,
        notes: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        userId: userId,
        brand: brandName.isEmpty ? null : brandName,
      );

      await DatabaseService().insertDrinkRecord(record);
      RecordChangeNotifier.notifyChanged();

      if (mounted) {
        _showBottomPill('$recordName记录已保存');
      }

      final unlocked = await AchievementService().checkAndUnlockAchievements(
        userId,
      );
      if (unlocked.isNotEmpty && mounted) {
        _showBottomPill('解锁 ${unlocked.length} 枚新勋章');
      }

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        _showBottomPill('保存失败');
      }
    }
  }

  _QuickDrinkType? get _matchedQuickDrinkType {
    final name = _nameController.text.trim();
    final typeText = _typeController.text.trim();
    for (final type in _quickDrinkTypes) {
      if (type.label == name ||
          type.recordName == name ||
          type.label == typeText ||
          type.recordName == typeText) {
        return type;
      }
    }
    return null;
  }

  void _applyBrandSelection(String brandName) {
    BrandPreset? brand;
    for (final item in _brandOptions) {
      if (item.name == brandName) {
        brand = item;
        break;
      }
    }
    if (brand == null) return;
    final selectedBrand = brand;
    if (selectedBrand.products.length == 1) {
      _applyProductPreset(
        selectedBrand.products.first,
        brandName: selectedBrand.name,
      );
      return;
    }
    setState(() {
      _setBrandText(selectedBrand.name);
    });
  }

  void _applyProductSelection(String productName) {
    final brand = _selectedBrandOption;
    if (brand != null) {
      for (final product in brand.products) {
        if (product.name == productName) {
          _applyProductPreset(product, brandName: brand.name);
          return;
        }
      }
    }

    for (final option in _brandOptions) {
      for (final product in option.products) {
        if (product.name == productName) {
          _applyProductPreset(product, brandName: option.name);
          return;
        }
      }
    }

    _QuickDrinkType? quickDrink;
    for (final type in _quickDrinkTypes) {
      if (type.recordName == productName || type.label == productName) {
        quickDrink = type;
        break;
      }
    }
    if (quickDrink != null) {
      _applyQuickDrinkType(quickDrink);
    }
  }

  void _applyProductPreset(ProductPreset product, {required String brandName}) {
    setState(() {
      _setBrandText(brandName);
      _nameController.text = product.name;
      _selectedCategory = _inferCategory(product.name, brandName: brandName);
      _typeController.text = _selectedCategory == '白开水'
          ? '水'
          : _selectedCategory;
      if (product.volume > 0) {
        final volume = product.volume.round();
        _volumeController.text = volume.toString();
        _selectedWaterVolume = volume.clamp(100, 2000).toInt();
        _selectedWaterType = '${_selectedWaterVolume}ml';
      }
      if (product.calories > 0) {
        _caloriesController.text = product.calories.round().toString();
      }
      if (product.caffeine > 0) {
        _caffeineController.text = product.caffeine.round().toString();
      }
    });
  }

  void _applyQuickDrinkType(_QuickDrinkType type) {
    setState(() {
      _nameController.text = type.recordName;
      _typeController.text = type.label;
      _selectedCategory = type.category;
      if (type.label == '瓶装饮品' && _selectedWaterVolume < 500) {
        _selectedWaterType = '随手瓶';
        _selectedWaterVolume = 750;
      }
    });
  }

  String _inferCategory(String name, {String? brandName}) {
    final text = '$name ${brandName ?? ''}';
    if (text.contains('奶茶') ||
        text.contains('厚乳') ||
        text.contains('椰乳') ||
        text.contains('奶盖') ||
        text.contains('波波') ||
        text.contains('珍珠')) {
      return '奶茶';
    }
    if (text.contains('咖啡') ||
        text.contains('拿铁') ||
        text.contains('美式') ||
        text.contains('摩卡') ||
        text.contains('瑞幸') ||
        text.toLowerCase().contains('costa') ||
        text.contains('星巴克')) {
      return '咖啡';
    }
    if (text.contains('果茶') ||
        text.contains('柠檬') ||
        text.contains('葡萄') ||
        text.contains('青提') ||
        text.contains('桃') ||
        text.contains('橙') ||
        text.contains('莓')) {
      return '果茶';
    }
    if (text.contains('水')) return '白开水';
    if (text.contains('可乐') ||
        text.contains('苏打') ||
        text.contains('饮料') ||
        text.contains('瓶')) {
      return '瓶装饮品';
    }
    return '其他';
  }

  void _showBottomPill(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF1F1A17),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        width: 188,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        elevation: 10,
        duration: const Duration(milliseconds: 1400),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Future<void> _showRecordPhotoSheet() async {
    if (_isProcessingPhoto) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFEFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D8CC),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                _buildPhotoSheetAction(
                  icon: Icons.photo_camera_rounded,
                  title: '拍照',
                  subtitle: '拍完后识别信息并保留原图',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/photo-ocr', extra: _currentRecordDraft());
                  },
                ),
                const SizedBox(height: 10),
                _buildPhotoSheetAction(
                  icon: Icons.photo_library_rounded,
                  title: '从相册选择',
                  subtitle: '选择已有照片，保存原图',
                  onTap: () {
                    Navigator.pop(context);
                    _pickRecordPhoto(ImageSource.gallery);
                  },
                ),
                if (_selectedImagePath != null &&
                    _selectedImagePath!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildPhotoSheetAction(
                    icon: Icons.delete_outline_rounded,
                    title: '移除照片',
                    subtitle: '这条记录不保存照片',
                    color: AppColors.error,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedImagePath = null;
                        _hasChangedPhoto = true;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _currentRecordDraft() {
    final brandName = _brandController.text.trim();
    final drinkName = _nameController.text.trim();
    return {
      ...?widget.prefill,
      'name': drinkName,
      'brand': brandName,
      'category': _inferCategory(drinkName, brandName: brandName),
      'size': _selectedSize,
      'volume': double.tryParse(_volumeController.text),
      'sugar': double.tryParse(_sugarController.text),
      'fat': double.tryParse(_fatController.text),
      'protein': double.tryParse(_proteinController.text),
      'caffeine': double.tryParse(_caffeineController.text),
      'calories': double.tryParse(_caloriesController.text),
      'price': double.tryParse(_priceController.text),
      'imagePath': _recordImagePath,
    };
  }

  Widget _buildPhotoSheetAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = AppColors.primary,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickRecordPhoto(ImageSource source) async {
    if (_isProcessingPhoto) return;
    setState(() => _isProcessingPhoto = true);

    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 88,
        maxWidth: 1280,
        maxHeight: 1280,
      );
      if (image == null) return;

      if (!mounted) return;

      String finalImagePath = image.path;

      if (_enableCutout) {
        try {
          final cutoutPath = await LocalOutlineService().createCutoutSticker(File(image.path));
          if (cutoutPath != null) {
            finalImagePath = cutoutPath;
          }
        } catch (e) {
          debugPrint('Cutout failed in manual record: $e');
        }
      }

      setState(() {
        _selectedImagePath = finalImagePath;
        _hasChangedPhoto = true;
      });
      _showBottomPill(_enableCutout ? '已添加并智能抠图' : '已添加原图');
    } catch (_) {
      if (mounted) _showBottomPill('照片添加失败');
    } finally {
      if (mounted) {
        setState(() => _isProcessingPhoto = false);
      }
    }
  }

  Future<void> _pickRecordTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedRecordTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: Colors.white,
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showWheelTimePickerSheet(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedRecordTime),
      title: '选择记录时间',
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedRecordTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _showCustomVolumeSheet() async {
    final controller = TextEditingController(
      text: _selectedWaterVolume.toString(),
    );
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8D8CC),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  '自定义水量',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '请输入水量',
                    suffixText: 'ml',
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final value = int.tryParse(controller.text.trim());
                      if (value == null || value <= 0) return;
                      Navigator.pop(context, value.clamp(100, 2000).toInt());
                    },
                    child: const Text('确定'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();
    if (result == null) return;
    setState(() {
      _selectedWaterType = '瓶装';
      _selectedWaterVolume = result;
    });
  }

  // 保存记录
  Future<void> _saveRecord() async {
    if (_nameController.text.trim().isEmpty) {
      _showBottomPill('先输入饮品名称');
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        var userId = await SessionService.getCurrentUserId();
        userId ??= (await SessionService.ensureLocalUser()).id;

        final brandName = _brandController.text.trim();
        final inferredCategory = _inferCategory(
          _nameController.text,
          brandName: brandName,
        );

        var record = _recordDraftService.buildRecord(
          name: _nameController.text,
          category: inferredCategory,
          volumeText: _volumeController.text,
          size: _selectedSize,
          sugarText: _sugarController.text,
          fatText: _fatController.text,
          proteinText: _proteinController.text,
          caffeineText: _caffeineController.text,
          caloriesText: _caloriesController.text,
          imagePath: _recordImagePath,
          userId: userId,
          brand: brandName.isNotEmpty ? brandName : null,
          price: double.tryParse(_priceController.text),
        );

        final editId = widget.prefill?['edit_id'];
        final isEditMode = editId != null && editId is int;

        if (isEditMode) {
          final originalNotes = widget.prefill?['notes'] as String?;
          final originalImagePath = widget.prefill?['imagePath'] as String?;
          final imagePath = _hasChangedPhoto
              ? _recordImagePath
              : originalImagePath;

          record = record.copyWith(
            id: editId,
            recordTime: _selectedRecordTime,
            notes: originalNotes,
            imagePath: imagePath,
            clearImagePath: _hasChangedPhoto && imagePath == null,
          );
          await DatabaseService().updateDrinkRecord(record);
        } else {
          await DatabaseService().insertDrinkRecord(record);
        }
        RecordChangeNotifier.notifyChanged();

        if (mounted) {
          _showBottomPill(isEditMode ? '记录修改成功' : '记录保存成功');
        }

        // 检测成就
        final unlocked = await AchievementService().checkAndUnlockAchievements(
          userId,
        );
        if (unlocked.isNotEmpty && mounted) {
          _showBottomPill('解锁 ${unlocked.length} 枚新勋章');
        }

        if (isEditMode) {
          if (mounted) {
            context.go('/records/$editId');
          }
        } else {
          if (mounted) {
            context.go('/home');
          }
        }
      } catch (e) {
        if (mounted) {
          _showBottomPill('保存失败');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.prefill?['edit_id'] != null;
    final isProductPrefill = widget.prefill?['from_product_picker'] == true;
    final showQuickRecord = !isEditMode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditMode ? '修改记录' : '记录喝水'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (isEditMode) {
              goBackOr(context, '/records/${widget.prefill!['edit_id']}');
            } else if (isProductPrefill) {
              goBackOr(context, '/record');
            } else {
              goBackOr(context, '/home');
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: showQuickRecord ? _saveWaterRecord : _saveRecord,
            child: const Text(
              '保存',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: showQuickRecord ? _buildWaterRecord() : _buildManualRecord(),
    );
  }

  Widget _buildWaterRecord() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPresetPickerButton(),
          const SizedBox(height: 14),
          _buildRecordPhotoCard(),
          const SizedBox(height: 20),
          _buildQuickDrinkTypeSelector(),
          const SizedBox(height: 20),
          _buildWaterAmountCard(),
          const SizedBox(height: 20),
          const Text(
            '选择容量',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildWaterTypeOption('小杯', 100),
              _buildWaterTypeOption('中杯', 200),
              _buildWaterTypeOption('大杯', 300),
              _buildWaterTypeOption('超大杯', 500),
              _buildWaterTypeOption('随手瓶', 750),
              _buildWaterTypeOption('大瓶', 1000),
              _buildWaterTypeOption('运动壶', 1500),
              _buildWaterTypeOption('2L', 2000),
              _buildCustomVolumeOption(),
            ],
          ),
          const SizedBox(height: 20),
          _buildQuickNutritionFields(),
          const SizedBox(height: 20),
          _buildRecordMetaCard(),
          const SizedBox(height: 14),
          _buildNoteField(),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _saveWaterRecord,
              child: const Text('保存记录'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDrinkTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '喝了什么',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _buildComboInput(
          controller: _brandController,
          focusNode: _brandFocusNode,
          suggestions: _brandSuggestions,
          hintText: '品牌（可选）',
          prefixIcon: Icons.storefront_rounded,
          onSelected: _applyBrandSelection,
        ),
        const SizedBox(height: 12),
        _buildComboInput(
          controller: _nameController,
          focusNode: _nameFocusNode,
          suggestions: _drinkNameSuggestions,
          hintText: _selectedBrandProducts.isEmpty ? '饮品名' : '选择该品牌饮品，或直接输入',
          prefixIcon: Icons.local_drink_rounded,
          onSelected: _applyProductSelection,
        ),
      ],
    );
  }

  Widget _buildComboInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required List<String> suggestions,
    required String hintText,
    required IconData prefixIcon,
    ValueChanged<String>? onSelected,
  }) {
    final menuOptions = suggestions.toSet().toList(growable: false);

    void selectValue(String value) {
      controller.text = value;
      onSelected?.call(value);
    }

    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: focusNode,
      displayStringForOption: (option) => option,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return suggestions;
        }
        return suggestions.where((option) {
          return option.toLowerCase().contains(query);
        });
      },
      onSelected: (value) {
        selectValue(value);
      },
      fieldViewBuilder:
          (context, fieldController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: fieldController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: Icon(prefixIcon, size: 18),
                suffixIcon: PopupMenuButton<String>(
                  tooltip: '展开选项',
                  enabled: menuOptions.isNotEmpty,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 220,
                    maxWidth: 320,
                    maxHeight: 320,
                  ),
                  onSelected: selectValue,
                  itemBuilder: (context) {
                    return menuOptions.map((option) {
                      return PopupMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            );
          },
      optionsViewBuilder: (context, onSelectedOption, options) {
        final optionList = options.toList(growable: false);
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.white,
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 360),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: optionList.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, indent: 14, endIndent: 14),
                itemBuilder: (context, index) {
                  final option = optionList[index];
                  return InkWell(
                    onTap: () => onSelectedOption(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaterAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF4E5D7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F8B5E3C),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_selectedWaterVolume',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(width: 5),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'ml',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              activeTrackColor: const Color(0xFFFFD6DF),
              inactiveTrackColor: const Color(0xFFFFEDDE),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.12),
              tickMarkShape: const RoundSliderTickMarkShape(
                tickMarkRadius: 1.4,
              ),
              activeTickMarkColor: const Color(0xFFFFD6DF),
              inactiveTickMarkColor: const Color(0xFFEED9C4),
            ),
            child: Slider(
              min: 100,
              max: 2000,
              divisions: 38,
              value: _selectedWaterVolume.toDouble().clamp(100, 2000),
              onChanged: (value) {
                setState(() {
                  _selectedWaterVolume = (value / 50).round() * 50;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '100',
                  style: TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
                Text(
                  '500',
                  style: TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
                Text(
                  '1000',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '1500',
                  style: TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
                Text(
                  '2000',
                  style: TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickNutritionFields() {
    final hasNutrition =
        _sugarController.text.trim().isNotEmpty ||
        _caffeineController.text.trim().isNotEmpty ||
        _caloriesController.text.trim().isNotEmpty;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF2E4D8)),
        ),
        child: ExpansionTile(
          initiallyExpanded: hasNutrition,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: const Icon(
            Icons.monitor_heart_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          title: const Text(
            '营养信息（可选）',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: const Text(
            '拍照识别后可在这里确认',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildCompactNutritionField(
                    controller: _caloriesController,
                    label: '热量',
                    unit: 'kcal',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCompactNutritionField(
                    controller: _sugarController,
                    label: '糖分',
                    unit: 'g',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildCompactNutritionField(
              controller: _caffeineController,
              label: '咖啡因',
              unit: 'mg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactNutritionField({
    required TextEditingController controller,
    required String label,
    required String unit,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: label,
        suffixText: unit,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildWaterTypeOption(String label, int volume) {
    final isSelected = _selectedWaterType == label;
    return SizedBox(
      width: 92,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedWaterType = label;
            _selectedWaterVolume = volume;
          });
        },
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.10)
                : const Color(0xFFFFFCF8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : const Color(0xFFF2E4D8),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.local_drink_outlined,
                    size: 16,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${volume}ml',
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomVolumeOption() {
    return SizedBox(
      width: 92,
      child: InkWell(
        onTap: _showCustomVolumeSheet,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCF8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF2E4D8)),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '自定',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                '输入',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordMetaCard() {
    final now = _selectedRecordTime;
    final today = DateTime.now();
    final isToday =
        now.year == today.year &&
        now.month == today.month &&
        now.day == today.day;
    final timeText =
        '${isToday ? '今天' : '${now.year}.${now.month}.${now.day}'} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '记录时间',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _pickRecordTime,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF2E4D8)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  color: Color(0xFFF2A33B),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  timeText,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '备注（可选）',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _noteController,
          minLines: 1,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: '添加备注...',
            suffixIcon: Icon(Icons.edit_rounded, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetPickerButton() {
    final hasPreset =
        _brandController.text.trim().isNotEmpty ||
        _nameController.text.trim().isNotEmpty;

    return InkWell(
      onTap: () =>
          context.push('/brands?from=record', extra: _currentRecordDraft()),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD1DC)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: AppColors.primary,
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasPreset ? '重新选择预置饮品' : '选择品牌或预置饮品',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasPreset ? '已带入的信息仍可手动修改' : '从品牌库带入名称、容量和营养信息',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildManualRecord() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基本信息
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '基本信息',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPresetPickerButton(),
                    const SizedBox(height: 16),
                    _buildRecordPhotoCard(),
                    const SizedBox(height: 16),
                    _buildComboInput(
                      controller: _brandController,
                      focusNode: _brandFocusNode,
                      suggestions: _brandSuggestions,
                      hintText: '品牌（可选）',
                      prefixIcon: Icons.storefront_rounded,
                      onSelected: _applyBrandSelection,
                    ),
                    const SizedBox(height: 16),
                    _buildComboInput(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      suggestions: _drinkNameSuggestions,
                      hintText: '饮品名称',
                      prefixIcon: Icons.local_drink_rounded,
                      onSelected: _applyProductSelection,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _volumeController,
                            decoration: const InputDecoration(
                              labelText: '容量 (ml)',
                              hintText: '500',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入容量';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            key: ValueKey(_selectedSize),
                            initialValue: _selectedSize,
                            decoration: const InputDecoration(labelText: '规格'),
                            items: _sizes.map((size) {
                              return DropdownMenuItem(
                                value: size,
                                child: Text(size),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSize = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: '价格 (元，选填)',
                        hintText: '请输入消费金额',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 营养信息
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '营养信息',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _sugarController,
                            decoration: const InputDecoration(
                              labelText: '糖分 (g)',
                              hintText: '15',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _fatController,
                            decoration: const InputDecoration(
                              labelText: '脂肪 (g)',
                              hintText: '8',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _proteinController,
                            decoration: const InputDecoration(
                              labelText: '蛋白质 (g)',
                              hintText: '3',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _caffeineController,
                            decoration: const InputDecoration(
                              labelText: '咖啡因 (mg)',
                              hintText: '25',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _caloriesController,
                      decoration: const InputDecoration(
                        labelText: '热量 (kcal)',
                        hintText: '180',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 保存按钮
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveRecord,
                child: Text(
                  widget.prefill?['edit_id'] != null ? '保存修改' : '保存记录',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview() {
    final editId = widget.prefill?['edit_id'];
    return Hero(
      tag: editId != null 
          ? 'record_image_$editId'
          : 'record_image_preview',
      child: Material(
        color: Colors.transparent,
        child: CapWordsStickerStage(
          imagePath: _selectedImagePath!,
          title: _nameController.text.isNotEmpty ? _nameController.text : '饮品',
          price: double.tryParse(_priceController.text),
          showCaption: true,
        ),
      ),
    );
  }

  Widget _buildRecordPhotoCard() {
    final hasPhoto =
        _selectedImagePath != null && _selectedImagePath!.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF2E4D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.photo_camera_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '记录照片',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (!hasPhoto)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('智能抠图', style: TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: _enableCutout,
                        onChanged: (val) => setState(() => _enableCutout = val),
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                )
              else
                TextButton.icon(
                  onPressed: _isProcessingPhoto ? null : _showRecordPhotoSheet,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 17,
                  ),
                  label: const Text('重拍/重选'),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (_isProcessingPhoto)
            const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
            )
          else if (hasPhoto)
            _buildPhotoPreview()
          else
            InkWell(
              onTap: _showRecordPhotoSheet,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 118,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF2E4D8)),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '添加照片，保存原图',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
