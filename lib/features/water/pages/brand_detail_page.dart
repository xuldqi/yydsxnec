import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/brands_data.dart';
import '../models/brand.dart';
import '../services/database_service.dart';
import '../services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';
import '../widgets/product_preset_editor_sheet.dart';

class BrandDetailPage extends StatefulWidget {
  final String brandId;
  final bool fromRecord;
  final Map<String, dynamic>? recordDraft;

  const BrandDetailPage({
    super.key,
    required this.brandId,
    this.fromRecord = false,
    this.recordDraft,
  });

  @override
  State<BrandDetailPage> createState() => _BrandDetailPageState();
}

class _BrandDetailPageState extends State<BrandDetailPage> {
  final DatabaseService _db = DatabaseService();
  BrandPreset? _brand;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBrandDetails();
  }

  // 加载品牌和其产品
  Future<void> _loadBrandDetails() async {
    try {
      final userId = await SessionService.getCurrentUserId() ?? 'guest';
      final customBrands = await _db.getCustomBrands(userId);

      // 先在自定义品牌中查找
      BrandPreset? foundBrand;
      for (var b in customBrands) {
        if (b.id == widget.brandId) {
          foundBrand = b;
          break;
        }
      }

      // 如果未找到，在预设品牌中查找
      if (foundBrand == null) {
        for (var b in brandPresets) {
          if (b.id == widget.brandId) {
            foundBrand = b;
            break;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _brand = foundBrand;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<ProductPreset?> _showProductEditor({ProductPreset? product}) async {
    final result = await showModalBottomSheet<ProductPresetEditorResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductPresetEditorSheet(
        product: product,
        currentBrandName: _brand?.name,
      ),
    );
    return result?.product;
  }

  // 给当前品牌添加自定义产品
  Future<void> _addCustomProduct() async {
    if (_brand == null) return;
    final newProduct = await _showProductEditor();
    if (newProduct == null || !mounted || _brand == null) return;

    setState(() => _isLoading = true);

    final updatedProducts = [..._brand!.products];
    final index = updatedProducts.indexWhere(
      (product) => product.name == newProduct.name,
    );
    if (index >= 0) {
      updatedProducts[index] = newProduct;
    } else {
      updatedProducts.add(newProduct);
    }

    final updatedBrand = BrandPreset(
      id: _brand!.id,
      name: _brand!.name,
      logo: _brand!.logo,
      products: updatedProducts,
      isCustom: true,
    );

    final userId = await SessionService.getCurrentUserId() ?? 'guest';
    await _db.insertCustomBrand(userId, updatedBrand);
    await _loadBrandDetails();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('饮品“${newProduct.name}”已添加'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  // 快捷记录该饮品
  void _quickRecordDrink(ProductPreset product) {
    if (_brand == null) return;

    // 跳转至记录页，并附带预填参数
    context.go(
      '/record',
      extra: {
        ...?widget.recordDraft,
        'brand': _brand!.name,
        'name': product.name,
        'calories': product.calories,
        'volume': product.volume,
        'caffeine': product.caffeine,
        'category': _categoryFor(_brand!, product),
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
    if (text.contains('茶')) {
      return '其他';
    }
    return '瓶装饮品';
  }

  Future<void> _editProduct(ProductPreset product) async {
    if (_brand == null) return;

    final updatedProduct = await _showProductEditor(product: product);
    if (updatedProduct == null || !mounted || _brand == null) return;

    final products = [..._brand!.products];
    final index = products.indexWhere(
      (item) => item.name == product.name && item.volume == product.volume,
    );
    if (index >= 0) {
      products[index] = updatedProduct;
    }

    final updatedBrand = BrandPreset(
      id: _brand!.id,
      name: _brand!.name,
      logo: _brand!.logo,
      products: products,
      isCustom: true,
    );

    if (!mounted) return;
    setState(() => _isLoading = true);
    final userId = await SessionService.getCurrentUserId() ?? 'guest';
    await _db.insertCustomBrand(userId, updatedBrand);
    await _loadBrandDetails();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('饮品已更新'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('品牌详情')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_brand == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('品牌不存在')),
        body: const Center(child: Text('没有找到对应品牌的信息')),
      );
    }

    final isCustom = _brand!.isCustom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_brand!.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => goBackOr(
            context,
            widget.fromRecord ? '/brands?from=record' : '/brands',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add),
            onPressed: _addCustomProduct,
            tooltip: '新增饮品',
          ),
        ],
      ),
      body: Column(
        children: [
          // 品牌头部卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                Text(
                  _brand!.logo.isNotEmpty ? _brand!.logo : '🥤',
                  style: const TextStyle(fontSize: 54),
                ),
                const SizedBox(height: 12),
                Text(
                  _brand!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCustom ? '本地饮品库' : '预设品牌，可编辑为本地模板',
                  style: TextStyle(
                    color: isCustom
                        ? AppColors.warning
                        : AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // 饮品列表
          Expanded(
            child: _brand!.products.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('这个品牌还没有饮品模板'),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _addCustomProduct,
                            icon: const Icon(Icons.add),
                            label: const Text('添加第一款饮品'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _brand!.products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final product = _brand!.products[idx];
                      final metrics = [
                        product.volume > 0
                            ? '${product.volume.round()}ml'
                            : '容量未填',
                        product.calories > 0
                            ? '${product.calories.round()}kcal'
                            : '热量未填',
                        product.caffeine > 0
                            ? '咖啡因 ${product.caffeine.round()}mg'
                            : '咖啡因未填',
                      ].join(' · ');
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '$metrics\n${product.description ?? "暂无简介"}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            onPressed: () => widget.fromRecord
                                ? _quickRecordDrink(product)
                                : _editProduct(product),
                            child: Text(widget.fromRecord ? '选择' : '编辑'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
