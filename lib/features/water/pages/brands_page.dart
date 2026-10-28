import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/brands_data.dart';
import '../models/brand.dart';
import '../services/database_service.dart';
import '../services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';
import '../widgets/product_preset_editor_sheet.dart';

class BrandsPage extends StatefulWidget {
  final bool fromRecord;
  final Map<String, dynamic>? recordDraft;

  const BrandsPage({super.key, this.fromRecord = false, this.recordDraft});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _ProductChoice {
  final BrandPreset brand;
  final ProductPreset product;

  const _ProductChoice({required this.brand, required this.product});
}

class _BrandsPageState extends State<BrandsPage> {
  static const String _fallbackBrandId = 'custom_drinks';
  final DatabaseService _db = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  List<BrandPreset> _allBrands = [];
  bool _isLoading = true;
  String? _selectedBrandId;

  @override
  void initState() {
    super.initState();
    _loadBrands();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadBrands() async {
    try {
      final userId = await SessionService.getCurrentUserId() ?? 'guest';
      final customBrands = await _db.getCustomBrands(userId);
      if (!mounted) return;
      setState(() {
        _allBrands = _mergeBrands(customBrands, brandPresets);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _allBrands = brandPresets;
        _isLoading = false;
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

  String get _query => _searchController.text.trim().toLowerCase();

  List<BrandPreset> get _visibleBrands {
    if (_query.isEmpty) return _allBrands;
    return _allBrands.where((brand) {
      final matchesBrand = brand.name.toLowerCase().contains(_query);
      final matchesProduct = brand.products.any(
        (product) => product.name.toLowerCase().contains(_query),
      );
      return matchesBrand || matchesProduct;
    }).toList();
  }

  List<_ProductChoice> get _visibleProducts {
    final choices = <_ProductChoice>[];
    for (final brand in _allBrands) {
      if (_selectedBrandId != null && brand.id != _selectedBrandId) {
        continue;
      }
      for (final product in brand.products) {
        final matchesQuery =
            _query.isEmpty ||
            brand.name.toLowerCase().contains(_query) ||
            product.name.toLowerCase().contains(_query) ||
            (product.description ?? '').toLowerCase().contains(_query);
        if (matchesQuery) {
          choices.add(_ProductChoice(brand: brand, product: product));
        }
      }
    }
    return choices;
  }

  Future<void> _addCustomBrand() async {
    final nameController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('添加自定义品牌'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: '品牌名称',
              hintText: '输入品牌名，如 阿嬷手作',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(
                    ctx,
                  ).showSnackBar(const SnackBar(content: Text('品牌名称不能为空')));
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('确认添加'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    setState(() => _isLoading = true);
    final userId = await SessionService.getCurrentUserId() ?? 'guest';
    final newBrand = BrandPreset(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: nameController.text.trim(),
      logo: '',
      products: const [],
      isCustom: true,
    );

    await _db.insertCustomBrand(userId, newBrand);
    await _loadBrands();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('品牌 “${newBrand.name}” 添加成功'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _saveBrand(BrandPreset brand) async {
    final userId = await SessionService.getCurrentUserId() ?? 'guest';
    await _db.insertCustomBrand(
      userId,
      BrandPreset(
        id: brand.id,
        name: brand.name,
        logo: brand.logo.isEmpty ? '🥤' : brand.logo,
        products: brand.products,
        isCustom: true,
      ),
    );
    await _loadBrands();
  }

  BrandPreset _customBrandForName(String rawName) {
    final name = rawName.trim().isEmpty ? '自定义饮品' : rawName.trim();
    final existing = _allBrands
        .where((brand) => brand.name == name)
        .firstOrNull;
    if (existing != null) return existing;

    final id = name == '自定义饮品'
        ? _fallbackBrandId
        : 'custom_brand_${DateTime.now().millisecondsSinceEpoch}';
    return BrandPreset(
      id: id,
      name: name,
      logo: '🥤',
      products: const [],
      isCustom: true,
    );
  }

  BrandPreset? _brandById(String? brandId) {
    if (brandId == null || brandId.isEmpty) return null;
    return _allBrands.where((brand) => brand.id == brandId).firstOrNull;
  }

  String _defaultEditorBrandId(_ProductChoice? choice) {
    if (choice != null) return choice.brand.id;
    if (_selectedBrandId != null) return _selectedBrandId!;
    return _allBrands.where((brand) => brand.name == '自定义饮品').firstOrNull?.id ??
        _fallbackBrandId;
  }

  Future<void> _showProductEditor({_ProductChoice? choice}) async {
    final isEditing = choice != null;
    final result = await showModalBottomSheet<ProductPresetEditorResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductPresetEditorSheet(
        product: choice?.product,
        brands: _allBrands,
        showBrandPicker: true,
        initialBrandId: _defaultEditorBrandId(choice),
        fallbackBrandId: _fallbackBrandId,
        fallbackBrandLabel: '自定义饮品',
      ),
    );

    if (result == null || !mounted) return;

    final updatedProduct = result.product;
    final selectedBrandId = result.selectedBrandId ?? _fallbackBrandId;
    final targetBrand = selectedBrandId == '__new_brand__'
        ? _customBrandForName(result.newBrandName)
        : (_brandById(selectedBrandId) ?? _customBrandForName('自定义饮品'));
    final changedBrand = isEditing && choice.brand.id != targetBrand.id;

    if (changedBrand) {
      final oldProducts = [...choice.brand.products]
        ..removeWhere(
          (product) =>
              product.name == choice.product.name &&
              product.volume == choice.product.volume,
        );
      await _saveBrand(
        BrandPreset(
          id: choice.brand.id,
          name: choice.brand.name,
          logo: choice.brand.logo.isEmpty ? '🥤' : choice.brand.logo,
          products: oldProducts,
          isCustom: true,
        ),
      );
    }

    final products = [...targetBrand.products];
    if (isEditing && !changedBrand) {
      final index = products.indexWhere(
        (product) =>
            product.name == choice.product.name &&
            product.volume == choice.product.volume,
      );
      if (index >= 0) {
        products[index] = updatedProduct;
      } else {
        products.add(updatedProduct);
      }
    } else {
      final index = products.indexWhere(
        (product) => product.name == updatedProduct.name,
      );
      if (index >= 0) {
        products[index] = updatedProduct;
      } else {
        products.add(updatedProduct);
      }
    }

    if (!mounted) return;
    setState(() => _isLoading = true);
    await _saveBrand(
      BrandPreset(
        id: targetBrand.id,
        name: targetBrand.name,
        logo: targetBrand.logo.isEmpty ? '🥤' : targetBrand.logo,
        products: products,
        isCustom: true,
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? '饮品已更新' : '饮品已添加'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _openProduct(_ProductChoice choice) {
    if (!widget.fromRecord) {
      _showProductEditor(choice: choice);
      return;
    }

    final product = choice.product;
    context.go(
      '/record',
      extra: {
        ...?widget.recordDraft,
        'brand': choice.brand.name,
        'name': product.name,
        'calories': product.calories,
        'volume': product.volume,
        'caffeine': product.caffeine,
        'category': _categoryFor(choice.brand, product),
        'from_product_picker': true,
      },
    );
  }

  String _categoryFor(BrandPreset brand, ProductPreset product) {
    final text = '${brand.name}${product.name}${product.description ?? ''}';
    if (text.contains('咖啡') || text.contains('拿铁') || text.contains('美式')) {
      return '咖啡';
    }
    if (text.contains('水') || text.contains('瓶装')) {
      return '瓶装饮品';
    }
    if (text.contains('果') || text.contains('柠檬') || text.contains('葡萄')) {
      return '果茶';
    }
    return '奶茶';
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;
    final backPath = widget.fromRecord ? '/record' : '/profile';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.fromRecord ? '选择饮品' : '饮品管理'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => goBackOr(context, backPath),
        ),
        actions: [
          if (!widget.fromRecord)
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _showProductEditor(),
              tooltip: '新增饮品',
            ),
          if (widget.fromRecord)
            IconButton(
              icon: const Icon(Icons.edit_note_rounded),
              onPressed: () => goBackOr(context, '/record'),
              tooltip: '直接填写',
            ),
          IconButton(
            icon: const Icon(Icons.add_business_rounded),
            onPressed: _addCustomBrand,
            tooltip: '添加品牌',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
                  child: _buildSearchField(),
                ),
                _buildBrandRail(),
                const SizedBox(height: 8),
                Expanded(
                  child: products.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                          itemCount: products.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _buildProductTile(products[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: '搜索品牌或饮品',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: _searchController.clear,
              ),
        filled: true,
        fillColor: const Color(0xFFFFFCF8),
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFF0E4D7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFF0E4D7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildBrandRail() {
    final brands = _visibleBrands;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: brands.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildBrandChip(null, '全部');
          }
          final brand = brands[index - 1];
          return _buildBrandChip(brand.id, brand.name);
        },
      ),
    );
  }

  Widget _buildBrandChip(String? id, String label) {
    final selected = id == _selectedBrandId;
    final allSelected = id == null && _selectedBrandId == null;
    final active = selected || allSelected;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedBrandId = id;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : const Color(0xFFFFFCF8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? AppColors.primary : const Color(0xFFF0E4D7),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildProductTile(_ProductChoice choice) {
    final product = choice.product;
    final volumeText = product.volume > 0
        ? '${product.volume.round()}ml'
        : '容量未填';
    final caloriesText = product.calories > 0
        ? '${product.calories.round()}kcal'
        : '热量未填';
    return InkWell(
      onTap: () => _openProduct(choice),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFCF8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF0E4D7)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F8B5E3C),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildBrandMark(choice.brand),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${choice.brand.name} · ${choice.brand.isCustom ? '本地饮品' : '预设饮品'}${product.description == null || product.description!.isEmpty ? '' : ' · ${product.description}'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (widget.fromRecord)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    volumeText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    caloriesText,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              )
            else
              IconButton(
                onPressed: () => _showProductEditor(choice: choice),
                icon: const Icon(Icons.edit_note_rounded),
                tooltip: '编辑饮品',
                color: AppColors.primary,
              ),
            const SizedBox(width: 4),
            if (widget.fromRecord)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandMark(BrandPreset brand) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _brandColor(brand.id).withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _brandColor(brand.id).withValues(alpha: 0.24),
        ),
      ),
      child: Text(
        _brandShortName(brand.name),
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: _brandColor(brand.id),
        ),
      ),
    );
  }

  String _brandShortName(String name) {
    final trimmed = name.trim();
    if (trimmed.length <= 2) return trimmed;
    return trimmed.substring(0, 2);
  }

  Color _brandColor(String id) {
    final colors = const [
      Color(0xFFF15B86),
      Color(0xFF4AA7F7),
      Color(0xFF39B77A),
      Color(0xFFF2A33B),
      Color(0xFF8B6BE8),
      Color(0xFFD46A54),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 42,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 12),
            Text(
              widget.fromRecord ? '没有找到这个饮品' : '饮品库里还没有这一项',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: widget.fromRecord
                  ? () => goBackOr(context, '/record')
                  : () => _showProductEditor(),
              icon: Icon(
                widget.fromRecord ? Icons.edit_note_rounded : Icons.add_rounded,
              ),
              label: Text(widget.fromRecord ? '直接填写' : '新增饮品'),
            ),
          ],
        ),
      ),
    );
  }
}
