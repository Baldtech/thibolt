import 'package:thibolt/common_libs.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:thibolt/models/step.dart';
import 'package:thibolt/models/workout.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.workout}) : super(key: key);

  final Workout workout;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var _duration = 0;
  final CountDownController _controller = CountDownController();

  List<StepModel> steps = [];
  List<StepModel> _nextSteps = [];
  int _currentStepIndex = 0;
  String _actionText = 'Start workout';
  String _titleText = "";

  void _getInitialInfo() {
    steps = StepModel.getStepsByWorkoutId(widget.workout.id);
    _nextSteps = steps.sublist(_currentStepIndex + 1);
    _duration = steps[0].duration;
    _titleText = steps[_currentStepIndex].name;
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();

    return Scaffold(
      appBar: const NavBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _pageContent(context),
      ),
    );
  }

  Container _pageContent(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const SizedBox(height: 10),
                _titleWidget(context),
                const SizedBox(height: 10),
                _current(context),
                const SizedBox(height: 35),
              ],
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _nextStepsWidget())
        ],
      ),
    );
  }

  Padding _titleWidget(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.all(15),
                child: Stack(
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(45),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.2),
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                              offset: const Offset(
                                1.0,
                                1.0,
                              ),
                            ),
                          ]),
                    ),
                    Positioned(
                        top: 27,
                        left: 13,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        )),
                    Positioned.fill(
                      top: 0,
                      left: 35,
                      child: BaseCard(
                        title: widget.workout.name,
                        subTitle: Utils.formatTime(widget.workout.duration),
                        icon: const Image(
                          image: AssetImage('assets/icons/illu_top.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }


  Column _current(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            _titleText,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 35),
        Padding(
          padding: const EdgeInsets.only(left: 70.0, right: 70.0),
          child: CircularCountDownTimer(
            autoStart: false,
            duration: _duration,
            initialDuration: 0,
            controller: _controller,
            width: 200,
            height: 200,
            ringColor: Theme.of(context).colorScheme.surface,
            ringGradient: null,
            fillColor: Theme.of(context).colorScheme.surface,
            fillGradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(207, 216, 255, 1),
                Color.fromRGBO(217, 203, 242, 1),
                Color.fromRGBO(201, 234, 235, 1),
              ],
            ),
            strokeWidth: 20.0,
            strokeCap: StrokeCap.round,
            textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 40,
                fontWeight: FontWeight.w300),
            textFormat: CountdownTextFormat.S,
            isReverse: true,
            isReverseAnimation: false,
            isTimerTextShown: true,
            onComplete: () {
              setState(() {
                _currentStepIndex++;
              });

              if (_currentStepIndex >= steps.length) {
                setState(() {
                  _currentStepIndex = 0;
                  _duration = steps[_currentStepIndex].duration;
                  _actionText = 'Start workout';
                });
                _controller.reset();
              } else {
                setState(() {
                  _duration = steps[_currentStepIndex].duration;
                });
                _controller.restart(
                    duration: steps[_currentStepIndex].duration);
              }
            },
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              double seconds = duration.inMilliseconds / 1000;
              return seconds.toStringAsFixed(1);
            },
          ),
        ),
        const SizedBox(height: 35),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              //elevation: 0,
              ),
          onPressed: () {
            if (!_controller.isStarted) {
              _controller.restart(duration: steps[_currentStepIndex].duration);
              setState(() {
                _actionText = 'Pause';
              });
            } else {
              if (_controller.isPaused) {
                _controller.resume();
                setState(() {
                  _actionText = 'Pause';
                });
              } else {
                _controller.pause();
                setState(() {
                  _actionText = 'Resume';
                });
              }
            }
          },
          child: Text(_actionText),
        ),
      ],
    );
  }

  Column _nextStepsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            '${'Next steps (${_nextSteps.length}'})',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary, fontSize: 20),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 90,
          child: ListView.separated(
            itemCount: _nextSteps.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 15, right: 15),
            separatorBuilder: (context, index) => const SizedBox(
              width: 15,
            ),
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nextSteps[index].name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onTertiary),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        Utils.formatTime(_nextSteps[index].duration),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.shadow),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/app-icon.svg',
                            height: 13,
                            width: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            Utils.formatTime(_nextSteps[index].restDuration),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.shadow),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}
