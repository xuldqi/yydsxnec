import 'dart:math';

class Quote {
  final String text;
  final String author;

  const Quote({required this.text, required this.author});
}

class QuoteService {
  static final List<Quote> _quotes = [
    const Quote(text: "生活不是等待风暴过去，而是学会在雨中跳舞。", author: "Vivian Greene"),
    const Quote(text: "凡是过往，皆为序章。", author: "莎士比亚"),
    const Quote(text: "未经审视的人生不值得一过。", author: "苏格拉底"),
    const Quote(text: "世界上只有一种英雄主义，就是在认清生活真相之后依然热爱生活。", author: "罗曼·罗兰"),
    const Quote(text: "万物皆有裂痕，那是光照进来的地方。", author: "莱昂纳德·科恩"),
    const Quote(text: "种一棵树最好的时间是十年前，其次是现在。", author: "Dambisa Moyo"),
    const Quote(text: "你若盛开，清风自来。", author: "佚名"),
    const Quote(text: "人生没有白走的路，每一步都算数。", author: "李宗盛"),
    const Quote(text: "心若向阳，无谓悲伤。", author: "佚名"),
    const Quote(text: "只有极致的拼搏，才能配得上极致的风景。", author: "佚名"),
    const Quote(text: "虽然辛苦，我还是会选择那种滚烫的人生。", author: "北野武"),
    const Quote(text: "要有最朴素的生活，与最遥远的梦想。", author: "七堇年"),
    const Quote(text: "满地都是六便士，他却抬头看见了月亮。", author: "毛姆"),
    const Quote(text: "前路浩浩荡荡，万事尽可期待。", author: "佚名"),
    const Quote(text: "保持热爱，奔赴山海。", author: "佚名"),
    const Quote(text: "既然选择了远方，便只顾风雨兼程。", author: "汪国真"),
    const Quote(text: "每一个不曾起舞的日子，都是对生命的辜负。", author: "尼采"),
    const Quote(text: "愿你出走半生，归来仍是少年。", author: "佚名"),
    const Quote(text: "星光不问赶路人，时光不负有心人。", author: "佚名"),
    const Quote(text: "无论黑夜多么漫长，白昼总会到来。", author: "莎士比亚"),
    const Quote(text: "生活总是让我们遍体鳞伤，但到后来，那些受伤的地方一定会变成我们最强壮的地方。", author: "海明威"),
    const Quote(text: "在隆冬，我终于知道，我身上有一个不可战胜的夏天。", author: "加缪"),
    const Quote(text: "不必行色匆匆，不必光芒四射，不必成为别人，只需做自己。", author: "弗吉尼亚·伍尔夫"),
    const Quote(text: "我们听过无数的道理，却仍旧过不好这一生。", author: "韩寒"),
    const Quote(text: "人间值得，夜晚值得，你也值得。", author: "佚名"),
    const Quote(text: "温柔是宝藏，你也是。", author: "佚名"),
    const Quote(text: "今天的不开心就到此为止，明天依旧光芒万丈。", author: "佚名"),
    const Quote(text: "你被安稳地爱着，应该有做任何事的勇气。", author: "佚名"),
    const Quote(text: "不必纠结于当下，也不必忧虑于未来。", author: "村上春树"),
    const Quote(text: "慢品人间烟火色，闲观万事岁月长。", author: "佚名"),
    const Quote(text: "愿你有好运气，如果没有，愿你在不幸中学会慈悲。", author: "刘瑜"),
    const Quote(text: "你要相信，你比想象中更强大。", author: "佚名"),
    const Quote(text: "生活明朗，万物可爱，人间值得，未来可期。", author: "佚名"),
    const Quote(text: "愿你一生努力，一生被爱，想要的都拥有，得不到的都释怀。", author: "八月长安"),
    const Quote(text: "岁月不饶人，我亦未曾饶过岁月。", author: "木心"),
    const Quote(text: "从前的日色变得慢，车、马、邮件都慢，一生只够爱一个人。", author: "木心"),
    const Quote(text: "世界上有不绝的风景，我有不老的心情。", author: "汪国真"),
    const Quote(text: "没有不可治愈的伤痛，没有不能结束的沉沦。", author: "佚名"),
    const Quote(text: "你简单，世界就简单。", author: "佚名"),
    const Quote(text: "愿所有梦见远方的人，心有惊雷，生似静湖。", author: "蔡崇达"),
    const Quote(text: "所谓无底深渊，下去，也是前程万里。", author: "木心"),
    const Quote(text: "我们都在阴沟里，但仍有人仰望星空。", author: "王尔德"),
    const Quote(text: "对待自己温柔一点，你只不过是宇宙的孩子。", author: "佚名"),
    const Quote(text: "不必太纠结于当下，也不必太忧虑未来。", author: "村上春树"),
    const Quote(text: "愿你眼里有星辰大海，心中有繁花似锦。", author: "佚名"),
    const Quote(text: "今天也要做全宇宙最快乐的小朋友。", author: "佚名"),
    const Quote(text: "愿你有盔甲也有软肋，有傲骨也有慈悲。", author: "佚名"),
    const Quote(text: "山有峰顶，海有彼岸，漫漫长路，终有回转。", author: "佚名"),
    const Quote(text: "愿你成为自己的太阳，无需凭借谁的光。", author: "佚名"),
    const Quote(text: "所有失去的，会以另一种方式归来。", author: "佚名"),
    const Quote(text: "好好生活，慢慢相遇。", author: "佚名"),
    const Quote(text: "愿你心中有花，手里有剑，有底气，有温柔。", author: "佚名"),
    const Quote(text: "你只管努力，剩下的交给时间。", author: "佚名"),
    const Quote(text: "愿你所遇皆温暖，所梦皆成真。", author: "佚名"),
    const Quote(text: "愿你一生清澈明朗，做你愿做之事，爱你想爱之人。", author: "佚名"),
    const Quote(text: "日子平淡，好在我喜欢。", author: "佚名"),
    const Quote(text: "愿你被这个世界温柔以待。", author: "佚名"),
  ];

  static Quote getDailyQuote() {
    // 使用当前日期作为种子，保证每天显示的语录一样，但不同日期不同
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final random = Random(seed);
    return _quotes[random.nextInt(_quotes.length)];
  }
}