import 'package:flutter/material.dart';

import 'package:DevQuiz/challenge/widgets/answer/answer_widget.dart';
import 'package:DevQuiz/core/app_text_styles.dart';
import 'package:DevQuiz/shared/models/answer_model.dart';
import 'package:DevQuiz/shared/models/question_model.dart';

class QuizWidget extends StatefulWidget {
  final QuestionModel question;
  final ValueChanged<bool> onSelected;

  const QuizWidget({
    Key? key,
    required this.question,
    required this.onSelected,
  }) : super(key: key);

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int _indexSelected = -1;

  AnswerModel answer(int index) => widget.question.answers[index];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            widget.question.title,
            style: AppTextStyles.heading,
          ),
          SizedBox(
            height: 24,
          ),
          for (var i = 0; i < widget.question.answers.length; i++)
            AnswerWidget(
              answer: answer(i),
              disabled: _indexSelected != -1,
              isSelected: _indexSelected == i,
              onTap: (value) {
                _indexSelected = i;
                setState(() {});
                Future.delayed(Duration(seconds: 1))
                    .then((_) => widget.onSelected(value));
              },
            ),
          // ...widget.question.awnsers.map(
          //   (e) => AnswerWidget(
          //     title: e.title,
          //     isRight: e.isRight,
          //   ),
          // ).toList(),
        ],
      ),
    );
  }
}
