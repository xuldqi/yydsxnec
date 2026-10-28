class GuidedQuestion {
  final String id;
  final String question;
  final String placeholder;

  const GuidedQuestion({
    required this.id,
    required this.question,
    required this.placeholder,
  });

  static const List<GuidedQuestion> defaultQuestions = [
    GuidedQuestion(
      id: 'what_happened',
      question: '今天发生了什么？',
      placeholder: '描述今天让你产生这种情绪的事情...',
    ),
    GuidedQuestion(
      id: 'how_feel',
      question: '你有什么感觉？',
      placeholder: '描述你的身体感受和心理状态...',
    ),
    GuidedQuestion(
      id: 'what_learned',
      question: '你学到了什么？',
      placeholder: '从这次经历中有什么收获或启发...',
    ),
    GuidedQuestion(
      id: 'next_step',
      question: '接下来想做什么？',
      placeholder: '有什么计划或行动可以让自己感觉更好...',
    ),
  ];

  GuidedQuestion copyWith({String? id, String? question, String? placeholder}) {
    return GuidedQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      placeholder: placeholder ?? this.placeholder,
    );
  }
}
