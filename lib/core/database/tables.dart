import 'package:drift/drift.dart';

// -----------------------------------------------------------------------------
// DatabaseHelper.java 表结构
// -----------------------------------------------------------------------------

// 1. 步数明细表 (对应 steps_count)
class StepCounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  IntColumn get useTime => integer().withDefault(const Constant(0))();
  IntColumn get stepsNum => integer().withDefault(const Constant(0))();
  IntColumn get type => integer().withDefault(const Constant(0))();
  IntColumn get subType => integer().withDefault(const Constant(0))();
  TextColumn get speed => text().nullable()();
  TextColumn get cstatus => text().nullable()();
  TextColumn get cal => text().nullable()();
  TextColumn get sync1 => text().nullable()();
  TextColumn get sync2 => text().nullable()();
  TextColumn get distance => text().nullable()();
}

// 2. 每日步数汇总表 (对应 step_per_day)
class StepPerDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()(); // yyyy-MM-dd
  DateTimeColumn get time => dateTime()();
  IntColumn get stepCount => integer().withDefault(const Constant(0))();
  IntColumn get state => integer().withDefault(const Constant(0))();
  IntColumn get backup1 => integer().withDefault(const Constant(0))();
}

// 3. 目标表 (对应 target)
class Targets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get targetName => text().nullable()();
  TextColumn get targetHint => text().nullable()();
  IntColumn get targetAllTimes => integer().withDefault(const Constant(1))();
  IntColumn get targetFinishTimes => integer().withDefault(const Constant(0))();
  BoolColumn get isLoop => boolean().withDefault(const Constant(false))();
  TextColumn get achieveDataList => text().nullable()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get lastTime => dateTime()();
  DateTimeColumn get targetTime => dateTime()();
  IntColumn get targetType => integer().withDefault(const Constant(0))();
  TextColumn get targetSync1 => text().nullable()();
  TextColumn get targetSync2 => text().nullable()();
  TextColumn get targetSync3 => text().nullable()();
  TextColumn get targetSync4 => text().nullable()();
}

// 4. 饮水记录表 (对应 water_record)
class WaterRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get time => dateTime()();
  IntColumn get amount => integer().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
  TextColumn get waterType => text().withDefault(const Constant('白水'))();
}

// 5. 饮食记录表 (对应 diet_record)
class DietRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get time => dateTime()();
  IntColumn get calories => integer().withDefault(const Constant(0))();
  TextColumn get foodName => text().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get mealType => integer().withDefault(const Constant(0))(); // 0=breakfast, 1=lunch, 2=dinner, 3=snack
  RealColumn get weight => real().withDefault(const Constant(0.0))();
}

// 6. 心情记录表 (对应 mood_record)
class MoodRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get time => dateTime()();
  IntColumn get mood => integer().withDefault(const Constant(3))();
  TextColumn get note => text().nullable()();
  TextColumn get reasons => text().nullable()(); // comma-separated
}

// 7. 训练计划表 (对应 training_plan)
class TrainingPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalType => integer().withDefault(const Constant(0))();
  IntColumn get levelType => integer().withDefault(const Constant(0))();
  TextColumn get planName => text().nullable()();
  TextColumn get planDesc => text().nullable()();
  TextColumn get planTips => text().nullable()();
  TextColumn get weeklyPlanJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get completedDays => text().nullable()();
}

// 8. 睡眠记录表 (对应 sleep_record)
class SleepRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get sleepTime => dateTime()();
  DateTimeColumn get wakeTime => dateTime()();
  IntColumn get duration => integer().withDefault(const Constant(0))(); // in minutes
  IntColumn get quality => integer().withDefault(const Constant(3))();
  IntColumn get sleepScore => integer().withDefault(const Constant(0))();
  IntColumn get heartRate => integer().withDefault(const Constant(0))();
  TextColumn get tags => text().nullable()();
  TextColumn get note => text().nullable()();
}

// 9. 社区动态缓存 (对应 social_feed)
class SocialFeeds extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().nullable()();
  TextColumn get avatarRes => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  IntColumn get steps => integer().nullable()();
  IntColumn get calories => integer().nullable()();
  DateTimeColumn get time => dateTime()();
  IntColumn get type => integer().nullable()(); // 0: 步数达标, 1: 训练完成, 2: 冥想心得
  IntColumn get likeCount => integer().withDefault(const Constant(0))();
  BoolColumn get isMock => boolean().withDefault(const Constant(true))();
}

// -----------------------------------------------------------------------------
// EnhancedDatabaseHelper.java 表结构
// -----------------------------------------------------------------------------

// 10. 专业体重记录表 (替代 boday_record)
class ProfessionalWeightRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get recordDatetime => dateTime()();
  RealColumn get weight => real()();
  
  // 身体成分
  RealColumn get bodyFatPercentage => real().nullable()();
  RealColumn get muscleMass => real().nullable()();
  RealColumn get boneMass => real().nullable()();
  RealColumn get bodyWater => real().nullable()();
  IntColumn get visceralFatLevel => integer().nullable()();
  IntColumn get basalMetabolism => integer().nullable()();
  RealColumn get proteinRate => real().nullable()();
  RealColumn get subcutaneousFat => real().nullable()();
  
  // 测量条件与生理状态
  TextColumn get measurementTimeType => text().nullable()();
  TextColumn get measurementDevice => text().nullable()();
  RealColumn get roomTemperature => real().nullable()();
  RealColumn get humidity => real().nullable()();
  IntColumn get menstrualCycleDay => integer().nullable()();
  IntColumn get sleepQuality => integer().nullable()();
  IntColumn get stressLevel => integer().nullable()();
  TextColumn get hydrationStatus => text().nullable()();
  
  // 备注
  TextColumn get notes => text().nullable()();
  TextColumn get tags => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  IntColumn get moodScore => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 11. 血压记录表
class BloodPressureRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get recordDatetime => dateTime()();
  
  IntColumn get systolicPressure => integer()();
  IntColumn get diastolicPressure => integer()();
  IntColumn get pulseRate => integer().nullable()();
  RealColumn get meanArterialPressure => real().nullable()();
  
  TextColumn get measurementPosition => text().nullable()();
  TextColumn get armUsed => text().nullable()();
  TextColumn get cuffSize => text().nullable()();
  TextColumn get deviceModel => text().nullable()();
  IntColumn get measurementCount => integer().withDefault(const Constant(1))();
  
  IntColumn get beforeRestTime => integer().nullable()();
  RealColumn get caffeineIntakeHours => real().nullable()();
  RealColumn get exerciseHoursBefore => real().nullable()();
  RealColumn get lastMealHours => real().nullable()();
  RealColumn get smokingHoursBefore => real().nullable()();
  RealColumn get alcoholHoursBefore => real().nullable()();
  
  TextColumn get symptoms => text().nullable()();
  TextColumn get medicationTaken => text().nullable()();
  RealColumn get sleepHours => real().nullable()();
  TextColumn get stressEvents => text().nullable()();
  RealColumn get roomTemperature => real().nullable()();
  TextColumn get noiseLevel => text().nullable()();
  
  TextColumn get notes => text().nullable()();
  TextColumn get tags => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 12. 心率记录表
class HeartRateRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get recordStartTime => dateTime()();
  IntColumn get recordDuration => integer().nullable()();
  
  IntColumn get avgHeartRate => integer()();
  IntColumn get maxHeartRate => integer().nullable()();
  IntColumn get minHeartRate => integer().nullable()();
  IntColumn get restingHeartRate => integer().nullable()();
  
  RealColumn get rmssd => real().nullable()();
  RealColumn get pnn50 => real().nullable()();
  RealColumn get sdnn => real().nullable()();
  RealColumn get stressIndex => real().nullable()();
  
  IntColumn get zone1Time => integer().nullable()();
  IntColumn get zone2Time => integer().nullable()();
  IntColumn get zone3Time => integer().nullable()();
  IntColumn get zone4Time => integer().nullable()();
  IntColumn get zone5Time => integer().nullable()();
  
  TextColumn get activityType => text().nullable()();
  TextColumn get bodyPosition => text().nullable()();
  TextColumn get breathingPattern => text().nullable()();
  
  BoolColumn get caffeineIntake => boolean().withDefault(const Constant(false))();
  BoolColumn get alcoholIntake => boolean().withDefault(const Constant(false))();
  TextColumn get medicationTaken => text().nullable()();
  RealColumn get sleepHours => real().nullable()();
  TextColumn get stressEvents => text().nullable()();
  
  TextColumn get deviceInfo => text().nullable()();
  TextColumn get rawDataUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get tags => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 13. 血糖记录表
class BloodGlucoseRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get recordDatetime => dateTime()();
  
  RealColumn get glucoseValue => real()();
  TextColumn get glucoseUnit => text().withDefault(const Constant('mmol/L'))();
  
  TextColumn get measurementTiming => text().nullable()();
  RealColumn get fastingHours => real().nullable()();
  TextColumn get mealRelationship => text().nullable()();
  
  RealColumn get lastMealCarbs => real().nullable()();
  RealColumn get lastMealGiScore => real().nullable()();
  TextColumn get mealComposition => text().nullable()();
  
  TextColumn get exerciseBeforeTest => text().nullable()();
  TextColumn get exerciseIntensity => text().nullable()();
  IntColumn get exerciseDuration => integer().nullable()();
  
  RealColumn get insulinDose => real().nullable()();
  IntColumn get insulinTimeBefore => integer().nullable()();
  TextColumn get medicationList => text().nullable()();
  
  TextColumn get illnessStatus => text().nullable()();
  IntColumn get stressLevel => integer().nullable()();
  IntColumn get menstrualCycleDay => integer().nullable()();
  IntColumn get sleepQuality => integer().nullable()();
  
  TextColumn get hypoglycemiaSymptoms => text().nullable()();
  TextColumn get hyperglycemiaSymptoms => text().nullable()();
  RealColumn get ketoneLevel => real().nullable()();
  
  TextColumn get notes => text().nullable()();
  TextColumn get deviceInfo => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 14. 血脂记录表
class BloodLipidsRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get recordDatetime => dateTime()();
  
  RealColumn get totalCholesterol => real().nullable()();
  RealColumn get triglycerides => real().nullable()();
  RealColumn get hdlCholesterol => real().nullable()();
  RealColumn get ldlCholesterol => real().nullable()();
  
  BoolColumn get fastingStatus => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastMealTime => dateTime().nullable()();
  TextColumn get deviceInfo => text().nullable()();
  
  TextColumn get medicationTaken => text().nullable()();
  TextColumn get symptoms => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get tags => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 15. 运动记录表
class ExerciseRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get duration => integer().nullable()();
  
  TextColumn get exerciseType => text().nullable()();
  TextColumn get exerciseName => text().nullable()();
  TextColumn get intensity => text().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get weatherCondition => text().nullable()();
  
  RealColumn get distance => real().nullable()();
  RealColumn get averageSpeed => real().nullable()();
  RealColumn get maxSpeed => real().nullable()();
  TextColumn get routeData => text().nullable()();
  RealColumn get elevation => real().nullable()();
  
  IntColumn get averageHeartRate => integer().nullable()();
  IntColumn get maxHeartRate => integer().nullable()();
  IntColumn get minHeartRate => integer().nullable()();
  IntColumn get restingHeartRate => integer().nullable()();
  IntColumn get hrZone1Time => integer().nullable()();
  IntColumn get hrZone2Time => integer().nullable()();
  IntColumn get hrZone3Time => integer().nullable()();
  IntColumn get hrZone4Time => integer().nullable()();
  IntColumn get hrZone5Time => integer().nullable()();
  
  TextColumn get exerciseSets => text().nullable()();
  RealColumn get totalWeight => real().nullable()();
  IntColumn get totalReps => integer().nullable()();
  RealColumn get oneRepMax => real().nullable()();
  
  IntColumn get caloriesBurned => integer().nullable()();
  IntColumn get steps => integer().nullable()();
  TextColumn get feeling => text().nullable()();
  RealColumn get trainingLoad => real().nullable()();
  TextColumn get rpeScore => text().nullable()();
  RealColumn get trainingStressScore => real().nullable()();
  
  IntColumn get averageCadence => integer().nullable()();
  IntColumn get maxCadence => integer().nullable()();
  RealColumn get strideLength => real().nullable()();
  RealColumn get verticalRatio => real().nullable()();
  RealColumn get groundContactTime => real().nullable()();
  
  RealColumn get temperature => real().nullable()();
  RealColumn get humidity => real().nullable()();
  IntColumn get sleepHoursLastNight => integer().nullable()();
  IntColumn get stressLevel => integer().nullable()();
  IntColumn get energyLevel => integer().nullable()();
  IntColumn get motivationLevel => integer().nullable()();
  
  TextColumn get equipment => text().nullable()();
  TextColumn get shoes => text().nullable()();
  TextColumn get deviceInfo => text().nullable()();
  
  TextColumn get goals => text().nullable()();
  BoolColumn get personalRecord => boolean().withDefault(const Constant(false))();
  TextColumn get achievements => text().nullable()();
  
  IntColumn get recoveryHeartRate => integer().nullable()();
  RealColumn get recoveryScore => real().nullable()();
  TextColumn get recoveryMetrics => text().nullable()();
  
  TextColumn get notes => text().nullable()();
  TextColumn get tags => text().nullable()();
  TextColumn get photos => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 16. 轻断食记录表
class FastingRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get planType => text().nullable()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get duration => integer().nullable()();
  IntColumn get targetHours => integer().nullable()();
  IntColumn get status => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 17. 用户设置表 (保留 Flutter 特有配置)
class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text()();
  TextColumn get value => text()();
}

// 18. 生理期记录表 (Flutter 新增或移植)
class PeriodRecords extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startDate => dateTime()();
  IntColumn get durationDays => integer().withDefault(const Constant(5))();
  IntColumn get cycleDays => integer().withDefault(const Constant(28))();
  TextColumn get symptoms => text().nullable()(); // comma-separated
  TextColumn get note => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// -----------------------------------------------------------------------------
// 通用体征记录表
// -----------------------------------------------------------------------------
class VitalRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // e.g. 'heart_rate', 'bp', 'glucose', 'spo2', 'temp'
  RealColumn get value1 => real()();
  RealColumn get value2 => real().nullable()();
  DateTimeColumn get time => dateTime()();
}
