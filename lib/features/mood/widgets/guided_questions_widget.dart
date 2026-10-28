import 'package:flutter/material.dart';
import '../models/guided_question.dart';
import '../theme/app_theme.dart';

class GuidedQuestionsWidget extends StatelessWidget {
  final Map<String, String>? answers;
  final ValueChanged<Map<String, String>?> onAnswersChanged;

  const GuidedQuestionsWidget({
    super.key,
    required this.answers,
    required this.onAnswersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '引导问题（可选）',
          style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryText),
        ),
        SizedBox(height: AppTheme.paddingM),
        ...GuidedQuestion.defaultQuestions.map((question) {
          return _QuestionInput(
            question: question,
            answer: answers?[question.id] ?? '',
            onChanged: (value) {
              final newAnswers = Map<String, String>.from(answers ?? {});
              if (value.trim().isEmpty) {
                newAnswers.remove(question.id);
              } else {
                newAnswers[question.id] = value.trim();
              }
              onAnswersChanged(newAnswers.isEmpty ? null : newAnswers);
            },
          );
        }),
      ],
    );
  }
}

class _QuestionInput extends StatelessWidget {
  final GuidedQuestion question;
  final String answer;
  final ValueChanged<String> onChanged;

  const _QuestionInput({
    required this.question,
    required this.answer,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: answer);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        SizedBox(height: AppTheme.paddingS),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: question.placeholder,
            filled: true,
            fillColor: AppTheme.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: BorderSide(color: AppTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: BorderSide(color: AppTheme.mistyPurple, width: 2),
            ),
            contentPadding: EdgeInsets.all(AppTheme.paddingM),
          ),
          maxLines: 3,
          minLines: 1,
        ),
        SizedBox(height: AppTheme.paddingM),
      ],
    );
  }
}
