import 'dart:math';

/// 首页气泡文案：根据时段随机返回问候/问句，引导用户记录此刻经历与心情
class PromptService {
  static final Random _random = Random();

  /// 根据当前时段返回一条问候语
  static String getGreetingPrompt() {
    final hour = DateTime.now().hour;
    final all = _getPromptsForHour(hour);
    return all[_random.nextInt(all.length)];
  }

  static List<String> _getPromptsForHour(int hour) {
    if (hour >= 5 && hour < 9) {
      return [
        '起那么早，是要去做什么呀？',
        '早安～今天有什么安排？',
        '睡得好吗？',
        '早起的鸟儿有虫吃，早起的你有啥心事？',
        '昨晚睡得好吗？',
        '今天打算做点什么？',
      ];
    }
    if (hour >= 9 && hour < 12) {
      return [
        '上班路上了吗？',
        '上午过得怎么样？',
        '今天忙吗？',
        '通勤路上累不累？',
        '上午开会了吗？',
        '有没有什么烦心事？',
        '上午心情如何？',
      ];
    }
    if (hour >= 12 && hour < 14) {
      return [
        '吃午饭了吗？',
        '今天中午过得怎么样？',
        '休息一下～',
        '午饭吃的啥？',
        '午休睡得好吗？',
        '中午有空喘口气吗？',
      ];
    }
    if (hour >= 14 && hour < 18) {
      return [
        '下午过得怎么样？',
        '今天忙吗？',
        '有什么想说的吗？',
        '下午困不困？',
        '项目进展顺利吗？',
        '有没有想吐槽的？',
        '下午心情如何？',
      ];
    }
    if (hour >= 18 && hour < 21) {
      return [
        '吃晚饭了吗？',
        '今天加班了吗？',
        '下班路上累吗？',
        '晚上过得怎么样？',
        '晚饭吃的啥？',
        '今天累不累？',
        '下班后打算干嘛？',
        '今天有开心的事吗？',
      ];
    }
    if (hour >= 21 || hour < 5) {
      return [
        '这么晚还没睡呀～',
        '今天过得怎么样？',
        '有什么想记录的吗？',
        '今天最开心/最累的事是什么？',
        '睡前想聊聊吗？',
        '今天有没有想吐槽的？',
        '夜深了，心情如何？',
      ];
    }
    return ['今天过得怎么样？'];
  }

  /// 随机返回一条「写几句试试」的灵感提示，用于记录引导
  static String getWritingInspiration() {
    const prompts = [
      '今天最开心的事是什么？',
      '今天最累的时刻？',
      '此刻最想对谁说句话？',
      '今天最感动的一个瞬间？',
      '今天有没有想吐槽的？',
      '此刻的心情，用三个词形容？',
      '今天和谁聊了天？感觉如何？',
      '今天身体感觉怎么样？',
      '今天看到什么好看的？',
      '今天吃了什么好吃的？',
      '此刻最想做的事？',
      '今天有什么小确幸？',
      '今天天气如何？影响心情了吗？',
    ];
    return prompts[_random.nextInt(prompts.length)];
  }

  /// 返回多条不重复的灵感提示，用于首页「想说的话」参考（保证同一次展示绝不重复）
  static List<String> getUniqueInspirations(int count) {
    const prompts = [
      '今天最开心的事是什么？',
      '今天最累的时刻？',
      '此刻最想对谁说句话？',
      '今天最感动的一个瞬间？',
      '今天有没有想吐槽的？',
      '此刻的心情，用三个词形容？',
      '今天和谁聊了天？感觉如何？',
      '今天身体感觉怎么样？',
      '今天看到什么好看的？',
      '今天吃了什么好吃的？',
      '此刻最想做的事？',
      '今天有什么小确幸？',
      '今天天气如何？影响心情了吗？',
    ];
    // 先按集合去重再打乱，确保返回的每条都不同
    final unique = prompts.toSet().toList();
    final shuffled = List<String>.from(unique)..shuffle(_random);
    return shuffled.take(count).toList();
  }
}
