// l10n 字符串辅助类 - 因为 arb 的 key 是 snake_case 但代码里习惯 camelCase
// 提供便捷的中文常量访问

import 'app_localizations.dart';

class AppL10nStrings {
  final AppL10n l;
  AppL10nStrings(this.l);

  String get agreedPrefix => '我已阅读并同意';
  String get and => ' 和 ';
  String get cancel => '取消';
  String get confirm => '确定';
  String get submit => '提交';
  String get save => '保存';
  String get delete => '删除';
  String get edit => '编辑';
  String get add => '添加';
  String get complete => '完成';
  String get loading => '加载中…';
  String get empty => '暂无数据';
  String get retry => '重试';
  String get skip => '跳过';
  String get next => '下一步';
  String get startUsing => '开始使用';
  String get goSettings => '去设置';

  String get privacyPolicy => '隐私政策';
  String get userAgreement => '用户协议';
  String get privacyUpdateTime => '最近更新：2026-06';
  String get agreementUpdateTime => '最近更新：2026-06';
  String get privacyIntro => '引言';
  String get privacyIntroContent => '我们非常重视您的隐私。本协议说明了我们如何收集、使用、存储和共享您的个人信息。';
  String get privacyInfoCollect => '一、信息收集';
  String get privacyInfoCollectContent => '为提供步数统计、健康分析等功能，我们会收集您的身体活动数据（步数、运动距离）、设备信息（型号、系统版本）、位置信息（仅运动场景）。';
  String get privacyInfoUse => '二、信息使用';
  String get privacyInfoUseContent => '上述信息仅用于为您提供健康数据展示、运动建议、活动统计等核心功能，不会用于商业广告或转售给第三方。';
  String get privacyInfoShare => '三、信息共享';
  String get privacyInfoShareContent => '除以下情形外，我们不会与任何第三方共享您的个人信息：(1) 获得您的明示同意；(2) 根据法律法规要求。';
  String get privacyInfoStorage => '四、信息存储';
  String get privacyInfoStorageContent => '您的数据将存储在本地设备与加密云端，您可随时通过设置-清除数据删除所有记录。';
  String get privacyContact => '五、联系我们';
  String get privacyContactContent => '如有疑问请通过应用内"意见反馈"或邮箱 support@example.com 与我们联系。';

  String get agreementIntro => '一、服务说明';
  String get agreementIntroContent => '微刻运动（"本应用"）是一款记录步数与运动数据的健康类应用。';
  String get agreementService => '二、服务内容';
  String get agreementServiceContent => '本应用提供步数记录、运动打卡、饮水/体重/睡眠追踪、健康数据可视化等功能。';
  String get agreementUserRights => '三、用户权利';
  String get agreementUserRightsContent => '您有权随时查看、修改、删除您的个人数据。';
  String get agreementDisclaimer => '四、免责声明';
  String get agreementDisclaimerContent => '本应用提供的健康数据仅供参考，不构成医疗建议。如有健康问题请咨询专业医生。';
  String get agreementChange => '五、协议变更';
  String get agreementChangeContent => '我们可能根据业务发展修订本协议，重大变更将通过应用内通知告知。';

  String get dataCollectDesc => '我们仅收集与功能直接相关的数据，包括步数、活动时长、地理位置（仅运动时）。您可随时在设置中关闭数据收集。';
  String get deviceSyncDesc => '您可同步华为运动健康、Apple Health、小米 Mi Fit 等第三方设备数据。同步前需要您授权相应权限。';
  String get thirdPartyDesc => '我们集成了友盟统计、穿山甲广告 SDK。详情请见各 SDK 隐私政策。';
  String get coinRuleDesc => '完成每日任务可获得金币，金币可在"我的钱包"中兑换奖励或提现。';
  String get taskRuleDesc => '每日签到、步数达标、运动打卡等任务可获得不同数量的金币奖励。';
  String get inviteRuleDesc => '每邀请一位好友注册，您和好友均可获得 100 金币奖励，无上限。';

  String get healthScore => '健康评分';
  String get healthScoreSubtitle => '基于今日活动数据综合计算';
  String get quickAccess => '快捷功能';
  String get dashboardActions => '数据看板';
  String get weightSubtitle => '记录每日体重变化';
  String get sleepSubtitle => '追踪睡眠时长与质量';
  String get meditationSubtitle => '冥想训练，舒缓压力';
  String get moodSubtitle => '记录每日心情';
  String get dietSubtitle => '饮食记录与营养分析';
  String get whiteNoiseSubtitle => '白噪音助眠/专注';

  String get steps => '步数';
  String get calories => '热量';
  String get sleep => '睡眠';
  String get water => '饮水';
  String get weight => '体重';
  String get mood => '心情';
  String get diet => '饮食';
  String get meditation => '冥想';
  String get whiteNoise => '白噪音';
  String get setting => '设置';
  String get userInfo => '个人资料';
  String get deviceSync => '设备同步';
  String get healthVisualization => '数据可视化';
  String get vitalSigns => '生命体征';
  String get unitStep => '步';
  String get unitKcal => '千卡';
  String get unitHour => '小时';
  String get unitMl => '毫升';
  String get commonProblem => '常见问题';

  String get onboardingTitle1 => '每日精准计步';
  String get onboardingDesc1 => '自动记录步数和运动路线，让每一步都有意义。';
  String get onboardingTitle2 => '全方位健康管理';
  String get onboardingDesc2 => '一站式追踪饮水、体重和训练计划。';
  String get onboardingTitle3 => '达成目标赢奖励';
  String get onboardingDesc3 => '达成每日活动目标赚取金币，邀请好友获得更多奖励。';

  String get loginOrRegister => '登录 / 注册';
  String get welcomeBack => '欢迎回来';
  String get loginSubtitle => '登录后开启你的健康之旅';
  String get phoneHint => '请输入手机号';
  String get smsCode => '验证码';
  String get getCode => '获取验证码';
  String get login => '登录';
  String get wechatLogin => '微信';
  String get qqLogin => 'QQ';
  String get guestLogin => '游客';

  String get inviteCodeTitle => '填写邀请码';
  String get inviteCodeSubtitle => '填写邀请码，与好友互赠奖励';
  String get inviteCodeHint => '下载应用后的24小时内输入有效';

  String get permActivityTitle => '活动识别';
  String get permActivityDesc => '用于自动记录您的步数和运动距离';
  String get permLocationTitle => '位置信息';
  String get permLocationDesc => '用于运动轨迹记录';
  String get permNotificationTitle => '通知';
  String get permNotificationDesc => '用于提醒您每日活动目标';
  String get permEnter => '进入应用';
  String get permGrant => '授权';
  String get permOpenSettings => '需要手动开启';
  String get permOpenSettingsDesc => '权限被永久拒绝，请到系统设置中开启';

  String get faq1q => '步数怎么计算？';
  String get faq1a => '本应用通过手机内置传感器记录步数。';
  String get faq2q => '如何同步华为运动健康数据？';
  String get faq2a => '进入"我的-设备同步"，授权华为运动健康权限即可。';
  String get faq3q => '金币有什么用？';
  String get faq3a => '金币可在"我的钱包"兑换实物奖品或提现。';
  String get faq4q => '运动数据如何删除？';
  String get faq4a => '进入设置-数据管理-清除数据。';
  String get faq5q => '支持哪些运动？';
  String get faq5a => '支持跑步、骑行、游泳、瑜伽、健身等 50+ 运动类型。';
  String get faq6q => '支持鸿蒙手表吗？';
  String get faq6a => '支持华为 WATCH GT/数字系列、鸿蒙智行手表。';
  String get faq7q => '如何修改身高体重？';
  String get faq7a => '进入"我的-个人资料"修改。';
  String get faq8q => '忘记密码怎么办？';
  String get faq8a => '本应用使用手机号+验证码登录，无需密码。';

  String get countStep => '计步设置';
  String get countStepNew => '步数详情';
  String get setTarget => '目标设置';
  String get setSportTarget => '运动目标';
  String get target => '目标';
  String get customTarget => '自定义目标';
  String get stepTargetList => '步数目标';
  String get countTime => '运动计时';
  String get distanceSport => '距离运动';
  String get timeSport => '时长运动';
  String get sportTypeSelector => '运动类型';
  String get sportDetail => '运动详情';
  String get addSportRecord => '添加运动记录';
  String get movementDetail => '动作详情';
  String get movementLibrary => '动作库';
  String get movementTimer => '动作计时';
  String get guidedWorkout => '指导训练';
  String get exerciseTracking => '运动追踪';
  String get trainingPlan => '训练计划';
  String get myTrainingPlan => '我的计划';
  String get weekSportReport => '周运动报告';
  String get weekCalReport => '周热量报告';
  String get waterRecord => '饮水记录';
  String get waterStatistics => '饮水统计';
  String get waterKnowledge => '饮水知识';
  String get weightRecord => '体重记录';
  String get weightCalendar => '体重日历';
  String get professionalWeight => '专业体重';
  String get bodyRecord => '身体数据';
  String get bodyRecordInfo => '数据详情';
  String get sleepRecord => '睡眠记录';
  String get sleepStatistics => '睡眠统计';
  String get meditationSettings => '冥想设置';
  String get dietRecord => '饮食记录';
  String get dietStatistics => '饮食统计';
  String get foodRecognition => '食物识别';
  String get foodSelection => '食物选择';
  String get moodRecord => '心情记录';
  String get moodStatistics => '心情统计';
  String get healthDashboard => '健康看板';
  String get healthRecords => '健康档案';
  String get editMainCard => '编辑主页卡片';
  String get mainCardDataShow => '卡片详情';
  String get aiHealthScan => 'AI 健康扫描';
  String get achievements => '成就';
  String get leaderboard => '排行榜';
  String get challenge => '挑战';
  String get taskCenter => '任务中心';
  String get sign => '签到';
  String get myMoney => '我的钱包';
  String get coinRecord => '金币记录';
  String get taskAd => '看广告领金币';
  String get luckReward => '幸运奖励';
  String get socialFeed => '动态';
  String get createPost => '发布动态';
  String get socialWorkoutInvite => '约练';
  String get shareFriends => '分享好友';
  String get bdMapTrace => '运动轨迹';
  String get traceHistoryList => '历史轨迹';

  // 底部 Tab
  String get tabStep => '健康';
  String get tabDaily => '报告';
  String get tabTarget => '目标';
  String get tabSport => '运动';
  String get tabUser => '我的';

  // 步数页
  String get remaining => '还差';
  String get activeDuration => '活动时长';
  String get hourlySteps => '每小时步数';
  String get weeklySteps => '近 7 天步数';
  String get today => '今天';
  String get thisWeek => '本周';
  String get recommend => '建议';
  String get stepGoalHint => '请输入步数';
  String get targetReached => '目标达成 🎉';
  String get finishRatio => '完成度';
  String get goal => '目标';
  String get distance => '距离';

  // 运动页
  String get startSport => '开始运动';
  String get totalSession => '运动次数';
  String get totalDuration => '总时长';
  String get totalCal => '总热量';
  String get totalDistance => '总距离';
  String get session => '次';
  String get recentRecord => '运动记录';

  // 计时页
  String get notStarted => '未开始';
  String get ongoing => '进行中';
  String get paused => '已暂停';
  String get pause => '暂停';
  String get resume => '继续';
  String get finish => '完成';
  String get start => '开始';
  String get pace => '配速';
  String get sportDuration => '运动时长';
  String get sportComplete => '运动完成';
  String get backToList => '返回列表';
  String get viewDetail => '查看详情';
  String get sportExitConfirm => '确认结束运动？';
  String get sportExitHint => '当前运动进行中，退出将不保存';

  // 睡眠页
  String get addSleep => '记录睡眠';
  String get sleepSaved => '已记录睡眠';
  String get bedTime => '入睡时间';
  String get wakeTime => '起床时间';
  String get deepSleep => '深睡';
  String get lightSleep => '浅睡';
  String get remSleep => 'REM';
  String get sleepScore => '睡眠评分';
  String get sleepStructure => '睡眠构成';
  String get recent7Days => '近 7 天';
  String get history => '历史记录';
  String get noSleepData => '还没有睡眠记录';
  String get addSleepHint => '点击右上角记录你的睡眠情况';

  // 体重页
  String get addWeight => '记录体重';
  String get weightSaved => '已记录';
  String get currentWeight => '当前体重';
  String get weightTrend => '体重趋势';
  String get days => '天';
  String get noWeightData => '还没有体重记录';
  String get addWeightHint => '记录每日体重，掌握变化趋势';
  String get normalRange => '正常范围';

  // 饮食页
  String get calorieIntake => '已摄入热量';
  String get protein => '蛋白质';
  String get fat => '脂肪';
  String get carbs => '碳水';
  String get tapToAdd => '点击 + 添加食物';

  // 设置页
  String get account => '账户';
  String get notifSetting => '通知提醒';
  String get stepGoal => '步数目标';
  String get darkMode => '深色模式';
  String get language => '语言';
  String get dataAndPrivacy => '数据与隐私';
  String get appearance => '外观';
  String get sport => '运动';
  String get about => '关于';
  String get clearData => '清除数据';
  String get clearDataConfirm => '确定要清除所有本地数据吗？此操作不可恢复。';
  String get cleared => '已清除';
  String get logout => '退出登录';
  String get logoutConfirm => '确定要退出登录吗？';
  String get appVersion => '应用版本';
  String get rateUs => '评价我们';

  // 成就
  String get totalPoints => '累计积分';
  String get unlocked => '已解锁';
  String get total => '总数';

  // 水页
  String get quickAdd => '快速添加';
  String get customAmount => '自定义饮水量';
  String get weeklyHeatmap => '近 7 天热力图';
  String get timeDistribution => '时段分布';
  String get todayRecord => '今日记录';
  String get setWaterTarget => '设置饮水目标';

  // 冥想页
  String get meditationIntro => '深呼吸，专注于当下';
  String get chooseScene => '选择冥想场景';
  String get meditationComplete => '冥想完成';

  // 白噪音
  String get playDuration => '已播放';
  String get stop => '停止';
  String get more => '更多';
  String get collapse => '收起';
  String get looping => '循环';
  String get singlePlay => '单曲';
  String get sleepTimer => '定时关闭';
  String get noLimit => '不限';
  String get minute => '分钟';

  // 个人资料
  String get nickname => '昵称';
  String get nicknameHint => '请输入昵称';
  String get gender => '性别';
  String get male => '男';
  String get female => '女';
  String get selectGender => '选择性别';
  String get height => '身高';
  String get birthday => '生日';
  String get notSet => '未设置';
  String get editProfile => '编辑资料';
  String get accountSecurity => '账户安全';

  // 设备同步
  String get availableDevice => '可用设备';
  String get connected => '已连接';
  String get lastSync => '最后同步';
  String get connect => '连接';
  String get syncSuccess => '同步成功';
  String get syncTip => '提示：设备授权后会自动同步数据，连接不同设备可合并步数/心率/睡眠等多源数据';

  // 生命体征
  String get heart => '心率';
  String get bp => '血压';
  String get bg => '血糖';
  String get spo2 => '血氧';
  String get temp => '体温';

  // 目标 Tab
  String get todayCompletion => '今日完成度';
  String get completedGoal => '已完成';
  String get inProgress => '进行中';
  String get todayGoals => '今日目标';
  String get shortcuts => '快捷入口';

  // 我的 Tab
  String get daysConsecutive => '天连续打卡';
  String get totalSteps => '总步数';
  String get totalSession2 => '总次数';
  String get achievement2 => '成就';
  String get todaySummary => '今日数据';
  String get myFeatures => '我的功能';
  String get privacyAndService => '隐私与服务';
  String get weeklyReport => '周报';
  String get daily4Dim => '今日 4 维度';
  String get daily => '日报';

  // 任务/激励
  String get daily1 => '每日';
  String get newbie => '新手';
  String get growth => '成长';
  String get claim => '领取';
  String get claimed => '已领取';
  String get claimNow => '立即领取';
  String get tasksReadyClaim => '个任务可领取';
  String get youHaveClaimable => '你有可领取的奖励';
  String get goEarn => '去赚金币';
  String get goEarnChance => '去赚取次数';
  String get moreRewards => '更多奖励等你拿';
  String get goTaskCenter => '去任务中心获取更多金币';
  String get taskNotComplete => '任务未完成';
  String get tasks => '任务';
  String get luck => '幸运';
  String get ad => '广告';
  String get tasksReady => '个任务';

  // 签到
  String get consecutiveDays => '连续签到';
  String get totalSigned => '累计签到';
  String get totalEarned => '累计获得';
  String get makeupCard => '补签卡';
  String get makeupSuccess => '补签成功';
  String get noMakeupCard => '补签卡不足';
  String get confirmMakeup => '确认补签？';
  String get makeupDayTip => '补签第';
  String get useMakeupCard => '将消耗 1 张补签卡';
  String get signedToday => '今日已签到';
  String get signSuccess => '签到成功';
  String get weekSign => '本周签到';
  String get signRules => '签到规则';
  String get tasks2 => '可领奖励';
  String get claimSuccess => '领取成功';
  String get tasks2Hint => '完成新手和成长任务获得更多金币';
  String get onGoing2 => '可领取';

  // 钱包
  String get totalBalance => '总余额';
  String get totalSpent => '累计支出';
  String get totalTransaction => '交易笔数';
  String get statistics => '统计';
  String get withdraw => '提现';
  String get balanceNotEnough => '余额不足';
  String get confirmWithdraw => '确认提现？';
  String get withdrawAmount => '提现金币';
  String get estimatedCashback => '预计到账';
  String get withdrawSuccess => '提现成功';
  String get cashbackToAccount => '已转入账户';
  String get withdrawAmounts => '提现金额';
  String get withdrawTip => '1000 金币 = 1 元，每天最多提现 1 次';
  String get quickEntry => '快捷入口';
  String get coin => '金币';

  // 金币明细
  String get income => '收入';
  String get expense => '支出';
  String get noRecords => '暂无记录';

  // 幸运奖励
  String get remainingChances => '剩余次数';
  String get startSpin => '开始抽奖';
  String get spinning => '抽奖中...';
  String get earnMoreChances => '获取更多次数';
  String get luckRules => '抽奖规则';

  // 看广告
  String get watchingAd => '正在观看';
  String get doubleCoin => '双倍领取';
  String get watchAnother => '再看一个';
  String get startWatch => '开始观看';
  String get adRewardRules => '奖励规则';

  // 排行榜
  String get stepsRank => '步数榜';
  String get friendRank => '好友榜';
  String get donateRank => '打赏榜';

  // 挑战
  String get challengeBannerSub => '加入挑战，赢取金币和成就';
  String get ongoingChallenges => '进行中';
  String get availableChallenges => '可加入';
  String get joinNow => '立即加入';
  String get daysLeft => '剩余天数';
  String get daysPerWeek => '天/周';

  // 训练计划
  String get choosePlan => '选择适合你的训练计划';
  String get choosePlanSub => '科学训练，让进步看得见';
  String get todayTraining => '今日训练';
  String get startTodayTraining => '开始今日训练';
  String get calendarProgress => '训练日历';
  String get stepsTarget => '步数目标';

  // 动作库
  String get actionSteps => '动作要点';
  String get startTraining => '开始训练';
  String get step => '步骤';
  String get sets => '组';
  String get equipment => '器材';
  String get realTimeTrack => '实时轨迹';
  String get stop2 => '停止';

  // 指导训练
  String get guidedWorkoutSub => '专业教练带练，循序渐进';

  // 周报
  String get dailyBreakdown => '每日分布';
  String get weeklyTrend => '周趋势';
  String get avgDay => '日均';
  String get bestDay => '最佳';
  String get weekStepSummary => '本周步数汇总';
  String get weekCalSummary => '本周热量汇总';
  String get weekOverWeek => '周环比';
  String get weekDimension => '4 维度';

  // 步数目标
  String get sensorSettings => '传感器设置';
  String get autoStartCount => '自动开启计步';
  String get autoStartCountSub => '应用启动时自动开始计步';
  String get countWhenIdle => '锁屏计步';
  String get countWhenIdleSub => '锁屏后继续计步';
  String get sensitivity => '灵敏度';
  String get stepTarget => '步数目标';
  String get chooseMilestone => '选择目标里程碑';
  String get easy => '轻松';
  String get light => '较轻';
  String get challenging => '有挑战';
  String get expert => '高难度';
  String get stepCountAbout => '本应用使用手机内置传感器记录步数，与主流健康 App 数据保持一致。';
  String get dailySteps => '每日步数';
  String get sportCalorie => '运动消耗';
  String get sportTargetTip => '为不同场景设置不同目标，运动起来更有动力';

  // 社交
  String get createPostHint => '说点什么吧，分享你的运动心得...';
  String get createPostAction => '发布';
  String get createPostSuccess => '发布成功！';
  String get addDataTitle => '添加运动数据';
  String get socialWorkoutTitle => '和好友一起运动';
  String get socialWorkoutSubtitle => '组队打卡更容易坚持，每周一起冲刺运动目标';
  String get socialWorkoutFriendStatus => '好友状态';
  String get invite => '邀请';
  String get joined => '已加入';
  String get shared => '已分享';
  String get sharePageInviteTitle => '邀请好友一起运动';
  String get sharePageInviteSubtitle => '分享邀请码，双方都能获得奖励';
  String get recognize => '识别中';

  // AI / 食物
  String get scanning => '扫描中';
  String get scanComplete => '扫描完成';
  String get tapToScan => '点击扫描';
  String get heartRate => '心率';
  String get stressLevel => '压力';
  String get recognized => '识别结果';
  String get foodSelectionHint => '从食物库中选择食物添加到今日记录';
  String get goDietPage => '前往饮食记录';
  String get goWaterPage => '前往喝水记录';
  String get goSleepPage => '前往睡眠记录';

  // 周/水/食 统计
  String get avgSleep => '平均睡眠';
  String get sleepQuality => '睡眠质量';
  String get sleepHabit => '睡眠习惯';
  String get avgIntake => '日均摄入';
  String get goalRate => '目标达成率';
  String get weeklyWater => '本周饮水';
  String get intakeDistribution => '时段分布';
  String get nutritionDistribution => '营养素分布';

  // 体重扩展
  String get bmi => 'BMI';
  String get bodyFat => '体脂率';
  String get bodyWater => '水分';
  String get muscleMass => '肌肉量';
  String get visceralFat => '内脏脂肪';
  String get bmr => '基础代谢';
  String get professionalWeightSub => '全面分析你的身体数据';
  String get bodyData => '身体数据';
  String get bodyDataIntro => '身体数据是评估健康状况的重要指标，集成体重、BMI、体脂率、肌肉量等多项指标。';

  // 心情
  String get howAreYou => '今天心情如何？';
  String get moodDiaryHint => '记录此刻的心情（可选）';
  String get moodAvg => '心情不错';
  String get moodAvgSub => '本周平均心情指数 4.2/5';
  String get moodDistribution => '心情分布';
  String get moodTrend => '心情趋势';

  // 运动扩展
  String get distanceGoal => '距离目标';
  String get timeGoal => '时长目标';
  String get chooseDistance => '选择距离';
  String get chooseDuration => '选择时长';
  String get paceAnalysis => '配速分析';
  String get heartRateZone => '心率区间';
  String get calorieBreakdown => '热量分布';

  // 设置
  String get reminder => '提醒';
  String get dailyReminder => '每日提醒';
  String get reminderTime => '提醒时间';
  String get ambientSound => '环境音';
  String get ambientSoundSub => '冥想时播放白噪音';
  String get defaultDuration => '默认时长';
  String get chooseBelow => '下方选择';

  // 通用
  String get goWater => '前往喝水';
  String get goWeight => '前往体重';
  String get goSleep => '前往睡眠';
  String get thisWeek2 => '本周';
  String get weekDimension2 => '4 维度';
  String get rank => '第';
  String get day => '天';
  String get weekday => '周一';
  String get sleepRecords => '睡眠记录';
  String get weightRecords => '体重记录';
  String get sportSession => '运动次数';
  String get noData => '暂无数据';
  String get sportType => '运动类型';
  String get clickToAdd => '点击 + 添加';
  String get isSigned => '已签到';
  String get wait => '等待';
  String get unlockProgress => '解锁进度';
  String get unlockCondition => '解锁条件';
  String get unlockedOn => '已于今日解锁';
  String get dragToReorder => '长按拖动可调整顺序';
  String get healthDashboardHint => '综合健康数据看板正在建设中';
  String get sleepRecordHint => '从睡眠页添加睡眠记录';
  String get waterRecordHint => '从喝水页添加饮水记录';

  // 排行榜/钱包/统计 补充
  String get daysReached => '达标天数';
  String get avgDaily => '日均';
  String get donate => '打赏';
  String get all => '全部';
  String get duration => '时长';

  // 星期
  String get mon => '一';
  String get tue => '二';
  String get wed => '三';
  String get thu => '四';
  String get fri => '五';
  String get sat => '六';
  String get sun => '日';
  String get thisMonth => '本月';
  String get goWatch => '去观看';
  String get signToday2 => '今日签到';
}

extension AppL10nToStrings on AppL10n {
  AppL10nStrings get s => AppL10nStrings(this);
}
