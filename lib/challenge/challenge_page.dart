import 'package:flutter/material.dart';

import 'package:DevQuiz/challenge/challenge_controller.dart';
import 'package:DevQuiz/challenge/widgets/next_button/next_button_widget.dart';
import 'package:DevQuiz/challenge/widgets/question_indicator/question_indicator_widget.dart';
import 'package:DevQuiz/challenge/widgets/quiz/quiz_widget.dart';
import 'package:DevQuiz/result/result_page.dart';
import 'package:DevQuiz/shared/models/question_model.dart';

class ChallengePage extends StatefulWidget {
  final List<QuestionModel> questions;
  final String title;

  const ChallengePage({
    Key? key,
    required this.questions,
    required this.title,
  }) : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final _controller = ChallengeController();
  final _pageController = PageController();

  @override
  void initState() {
    _pageController.addListener(() {
      _controller.currentPage = _pageController.page!.toInt() + 1;
    });
    super.initState();
  }

  void _nextPage() {
    if (_controller.currentPage < widget.questions.length)
      _pageController.nextPage(
          duration: Duration(milliseconds: 100), curve: Curves.linear);
  }

  void _onSelected(bool value){
    if (value) {
      _controller.qndAnswerRight++;
    }
    _nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(115),
        child: SafeArea(
            top: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ValueListenableBuilder<int>(
                  valueListenable: _controller.currentPageNotifier,
                  builder: (context, value, _) => QuestionIndicatorWidget(
                    currentPage: value,
                    length: widget.questions.length,
                  ),
                ),
              ],
            )),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: widget.questions
            .map((e) => QuizWidget(
                  question: e,
                  onSelected: _onSelected,
                ))
            .toList(),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ValueListenableBuilder<int>(
            valueListenable: _controller.currentPageNotifier,
            builder: (context, value, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (value != widget.questions.length)
                  Expanded(
                      child: NextButtonWidget.white(
                    label: "Pular",
                    onTap: _nextPage,
                  )),
                if (value == widget.questions.length)
                  Expanded(
                    child: NextButtonWidget.green(
                        label: "Confirmar",
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultPage(
                                      title: widget.title,
                                      length: widget.questions.length,
                                      result: _controller.qndAnswerRight,
                                    )),
                          );
                        }),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
