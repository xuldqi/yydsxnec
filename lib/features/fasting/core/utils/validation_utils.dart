/// 数据验证工具类
class ValidationUtils {
  /// 验证体重 (kg)
  static bool isValidWeight(double? weight) {
    if (weight == null) return false;
    return weight > 0 && weight <= 500;
  }

  /// 验证身高 (cm)
  static bool isValidHeight(double? height) {
    if (height == null) return false;
    return height > 0 && height <= 300;
  }

  /// 验证年龄
  static bool isValidAge(int? age) {
    if (age == null) return false;
    return age > 0 && age <= 150;
  }

  /// 验证饮水量 (ml)
  static bool isValidWaterAmount(double? amount) {
    if (amount == null) return false;
    return amount > 0 && amount <= 5000;
  }

  /// 验证断食时长 (小时)
  static bool isValidFastingHours(int? hours) {
    if (hours == null) return false;
    return hours >= 8 && hours <= 48;
  }

  /// 验证进食时长 (小时)
  static bool isValidEatingHours(int? hours) {
    if (hours == null) return false;
    return hours >= 4 && hours <= 16;
  }

  /// 验证运动时长 (分钟)
  static bool isValidExerciseDuration(int? minutes) {
    if (minutes == null) return false;
    return minutes > 0 && minutes <= 600; // 最多10小时
  }

  /// 验证运动消耗卡路里
  static bool isValidCaloriesBurned(double? calories) {
    if (calories == null) return false;
    return calories > 0 && calories <= 5000;
  }

  /// 验证用户名
  static bool isValidUsername(String? username) {
    if (username == null || username.isEmpty) return false;
    return username.length >= 2 && username.length <= 20;
  }

  /// 验证邮箱
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// 验证手机号
  static bool isValidPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  /// 验证密码强度
  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    return password.length >= 6 && password.length <= 20;
  }

  /// 验证BMI值
  static bool isValidBMI(double? bmi) {
    if (bmi == null) return false;
    return bmi > 0 && bmi <= 100;
  }

  /// 计算BMI
  static double? calculateBMI(double? weight, double? height) {
    if (!isValidWeight(weight) || !isValidHeight(height)) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// 获取BMI分类
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return '偏瘦';
    } else if (bmi < 24) {
      return '正常';
    } else if (bmi < 28) {
      return '超重';
    } else {
      return '肥胖';
    }
  }

  /// 验证目标体重
  static bool isValidTargetWeight(double? currentWeight, double? targetWeight) {
    if (!isValidWeight(currentWeight) || !isValidWeight(targetWeight)) {
      return false;
    }

    // 目标体重不能与当前体重相差超过50kg
    final difference = (currentWeight! - targetWeight!).abs();
    return difference <= 50;
  }

  /// 验证日期范围
  static bool isValidDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return false;
    return startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate);
  }

  /// 验证时间格式 (HH:mm)
  static bool isValidTimeFormat(String? time) {
    if (time == null || time.isEmpty) return false;
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return timeRegex.hasMatch(time);
  }

  /// 获取体重验证错误信息
  static String? getWeightValidationError(double? weight) {
    if (weight == null) return '请输入体重';
    if (weight <= 0) return '体重必须大于0';
    if (weight > 500) return '体重不能超过500kg';
    return null;
  }

  /// 获取身高验证错误信息
  static String? getHeightValidationError(double? height) {
    if (height == null) return '请输入身高';
    if (height <= 0) return '身高必须大于0';
    if (height > 300) return '身高不能超过300cm';
    return null;
  }

  /// 获取饮水量验证错误信息
  static String? getWaterAmountValidationError(double? amount) {
    if (amount == null) return '请输入饮水量';
    if (amount <= 0) return '饮水量必须大于0';
    if (amount > 5000) return '单次饮水量不能超过5000ml';
    return null;
  }

  /// 获取断食时长验证错误信息
  static String? getFastingHoursValidationError(int? hours) {
    if (hours == null) return '请输入断食时长';
    if (hours < 8) return '断食时长不能少于8小时';
    if (hours > 48) return '断食时长不能超过48小时';
    return null;
  }
}
