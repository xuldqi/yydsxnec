import 'package:flutter/material.dart';

import '../models/brand.dart';
import '../../../../core/theme/app_colors.dart';

class ProductPresetEditorResult {
  final ProductPreset product;
  final String? selectedBrandId;
  final String newBrandName;

  const ProductPresetEditorResult({
    required this.product,
    this.selectedBrandId,
    this.newBrandName = '',
  });
}

class ProductPresetEditorSheet extends StatefulWidget {
  final ProductPreset? product;
  final List<BrandPreset> brands;
  final bool showBrandPicker;
  final String? initialBrandId;
  final String fallbackBrandId;
  final String fallbackBrandLabel;
  final String? currentBrandName;

  const ProductPresetEditorSheet({
    super.key,
    this.product,
    this.brands = const [],
    this.showBrandPicker = false,
    this.initialBrandId,
    this.fallbackBrandId = 'custom_drinks',
    this.fallbackBrandLabel = '自定义饮品',
    this.currentBrandName,
  });

  @override
  State<ProductPresetEditorSheet> createState() =>
      _ProductPresetEditorSheetState();
}

class _ProductPresetEditorSheetState extends State<ProductPresetEditorSheet> {
  static const String _newBrandValue = '__new_brand__';

  late final TextEditingController _nameController;
  late final TextEditingController _customBrandController;
  late final TextEditingController _volumeController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _caffeineController;
  late final TextEditingController _descController;
  late String _selectedBrandId;
  String? _errorText;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _customBrandController = TextEditingController();
    _volumeController = TextEditingController(
      text: _numberFieldText(product?.volume),
    );
    _caloriesController = TextEditingController(
      text: _numberFieldText(product?.calories),
    );
    _caffeineController = TextEditingController(
      text: _numberFieldText(product?.caffeine),
    );
    _descController = TextEditingController(text: product?.description ?? '');
    _selectedBrandId = widget.initialBrandId ?? widget.fallbackBrandId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customBrandController.dispose();
    _volumeController.dispose();
    _caloriesController.dispose();
    _caffeineController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String _numberFieldText(double? value) {
    if (value == null || value <= 0) return '';
    return value.round().toString();
  }

  double _optionalNumber(String raw) {
    final value = double.tryParse(raw.trim());
    if (value == null || value <= 0) return 0;
    return value;
  }

  List<DropdownMenuItem<String>> _brandItems() {
    final seenIds = <String>{widget.fallbackBrandId};
    return [
      DropdownMenuItem<String>(
        value: widget.fallbackBrandId,
        child: Text(widget.fallbackBrandLabel),
      ),
      for (final brand in widget.brands)
        if (seenIds.add(brand.id))
          DropdownMenuItem<String>(value: brand.id, child: Text(brand.name)),
      const DropdownMenuItem<String>(
        value: _newBrandValue,
        child: Text('新建品牌'),
      ),
    ];
  }

  void _setError(String? value) {
    if (_errorText == value) return;
    setState(() => _errorText = value);
  }

  void _cancel() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _setError('饮品名称不能为空');
      return;
    }
    if (widget.showBrandPicker &&
        _selectedBrandId == _newBrandValue &&
        _customBrandController.text.trim().isEmpty) {
      _setError('先输入品牌名称');
      return;
    }

    final description = _descController.text.trim();
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(
      ProductPresetEditorResult(
        product: ProductPreset(
          name: name,
          calories: _optionalNumber(_caloriesController.text),
          volume: _optionalNumber(_volumeController.text),
          caffeine: _optionalNumber(_caffeineController.text),
          description: description.isEmpty ? null : description,
        ),
        selectedBrandId: widget.showBrandPicker ? _selectedBrandId : null,
        newBrandName: _customBrandController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    final brandItems = widget.showBrandPicker
        ? _brandItems()
        : const <DropdownMenuItem<String>>[];
    final selectedBrandId =
        brandItems.any((item) => item.value == _selectedBrandId)
        ? _selectedBrandId
        : widget.fallbackBrandId;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: keyboard),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                Text(
                  _isEditing ? '编辑饮品模板' : '添加饮品模板',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.showBrandPicker
                      ? '只要填名称。容量、热量和咖啡因不知道就留空，记录时还能再改。'
                      : '当前品牌：${widget.currentBrandName ?? ''}。只要填名称，其他不知道就留空。',
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _nameController,
                  autofocus: !_isEditing,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _setError(null),
                  decoration: const InputDecoration(
                    labelText: '饮品名称',
                    hintText: '如 生椰拿铁、矿泉水、柠檬茶',
                    prefixIcon: Icon(Icons.local_drink_rounded, size: 18),
                  ),
                ),
                if (widget.showBrandPicker) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedBrandId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: '品牌',
                      prefixIcon: Icon(Icons.storefront_rounded, size: 18),
                    ),
                    items: brandItems,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedBrandId = value;
                        _errorText = null;
                      });
                    },
                  ),
                  if (_selectedBrandId == _newBrandValue) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customBrandController,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _setError(null),
                      decoration: const InputDecoration(
                        labelText: '品牌名称',
                        hintText: '如 小区咖啡、自制饮品',
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _volumeController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: '容量',
                          hintText: '未填',
                          suffixText: 'ml',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _caloriesController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: '热量',
                          hintText: '未填',
                          suffixText: 'kcal',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _caffeineController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: '咖啡因',
                    hintText: '未填',
                    suffixText: 'mg',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descController,
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: '备注（选填）',
                    hintText: '口味、规格、少糖等',
                  ),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorText!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _cancel,
                        child: const Text('取消'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        child: Text(_isEditing ? '保存' : '添加'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
