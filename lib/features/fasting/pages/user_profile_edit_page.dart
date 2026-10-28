import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_profile.dart';
import '../providers/user_settings_provider.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../utils/app_toast.dart';
import '../utils/picker_utils.dart';

class UserProfileEditPage extends ConsumerStatefulWidget {
  const UserProfileEditPage({super.key});

  @override
  ConsumerState<UserProfileEditPage> createState() =>
      _UserProfileEditPageState();
}

class _UserProfileEditPageState extends ConsumerState<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  String? _nickname;
  String? _gender;
  DateTime? _birthDate;
  double? _heightCm;
  double? _targetWeightKg;
  String? _avatarPath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize fields after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(userProfileProvider).valueOrNull;
      if (profile != null && mounted) {
        setState(() {
          _nickname = profile.nickname;
          _gender = profile.gender;
          _birthDate = profile.birthDate;
          _heightCm = profile.heightCm;
          _targetWeightKg = profile.targetWeightKg;
          _avatarPath = profile.avatarPath;
        });
      }
    });
  }

  Future<void> _pickAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image != null && mounted) {
        setState(() {
          _avatarPath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        showAppToast(context, '无法访问相册', type: AppToastType.error);
      }
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, 1, 1);
    final lastDate = DateTime(now.year, now.month, now.day);
    final initial = _birthDate ?? DateTime(now.year - 25, now.month, now.day);

    final picked = await PickerUtils.showCupertinoDateTimePicker(
      context,
      initialDateTime: initial,
      minimumDate: firstDate,
      maximumDate: lastDate,
      mode: CupertinoDatePickerMode.date,
    );

    if (picked != null && mounted) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _showGenderPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('选择性别'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _gender = 'M');
              Navigator.pop(context);
            },
            child: const Text(
              '男',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _gender = 'F');
              Navigator.pop(context);
            },
            child: const Text(
              '女',
              style: TextStyle(color: AppColors.primaryDark),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _gender = 'other');
              Navigator.pop(context);
            },
            child: const Text(
              '其他 / 不透露',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text(
            '取消',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState?.save();

    final base =
        ref.read(userProfileProvider).valueOrNull ?? const UserProfile();
    final updated = base.copyWith(
      nickname: _nickname?.trim().isEmpty == true ? null : _nickname?.trim(),
      gender: _gender,
      birthDate: _birthDate,
      heightCm: _heightCm,
      targetWeightKg: _targetWeightKg,
      avatarPath: _avatarPath,
    );

    try {
      await ref.read(userProfileProvider.notifier).updateUserProfile(updated);
      if (mounted) {
        Navigator.of(context).pop();
        showAppToast(context, '个人信息已保存', type: AppToastType.success);
      }
    } catch (_) {
      if (mounted) {
        showAppToast(context, '保存失败，请稍后重试', type: AppToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('个人信息'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              '保存',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          children: [
            _buildAvatarSection(),
            const SizedBox(height: 40.0),
            _buildGroup(
              children: [
                _buildTextFieldRow(
                  '昵称',
                  '输入昵称',
                  _nickname,
                  (v) => _nickname = v,
                ),
                _buildDivider(),
                _buildActionRow(
                  '性别',
                  _gender == 'M'
                      ? '男'
                      : _gender == 'F'
                      ? '女'
                      : _gender == 'other'
                      ? '其他'
                      : '请选择',
                  _showGenderPicker,
                ),
                _buildDivider(),
                _buildActionRow(
                  '出生日期',
                  _birthDate == null
                      ? '请选择'
                      : '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}',
                  _pickBirthDate,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                top: 32.0,
                bottom: 8.0,
              ),
              child: Text(
                '健康目标',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
            _buildGroup(
              children: [
                _buildNumberFieldRow(
                  '身高 (cm)',
                  '如: 170',
                  _heightCm,
                  (v) => _heightCm = v,
                ),
                _buildDivider(),
                _buildNumberFieldRow(
                  '目标体重 (kg)',
                  '如: 60',
                  _targetWeightKg,
                  (v) => _targetWeightKg = v,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: GestureDetector(
        onTap: _pickAvatar,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: ClipOval(
                child: _avatarPath != null
                    ? Image.file(File(_avatarPath!), fit: BoxFit.cover)
                    : const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '点击更换头像',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 24.0),
      child: Divider(height: 1, thickness: 1, color: AppColors.divider),
    );
  }

  Widget _buildActionRow(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldRow(
    String label,
    String hint,
    String? initialValue,
    Function(String?) onSaved,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: AppColors.surface,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(fontSize: 16),
              onSaved: onSaved,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberFieldRow(
    String label,
    String hint,
    double? initialValue,
    Function(double?) onSaved,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: initialValue?.toString() ?? '',
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: AppColors.surface,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(fontSize: 16),
              onSaved: (value) {
                if (value == null || value.trim().isEmpty) {
                  onSaved(null);
                } else {
                  onSaved(double.tryParse(value.trim()));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
