import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:thibolt/common_libs.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:thibolt/models/step.dart';
import 'package:thibolt/models/workout.dart';
import 'package:audioplayers/audioplayers.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, required this.workout}) : super(key: key);

  final Workout workout;
  final AudioPlayer _audioCache = AudioPlayer();

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var _duration = 0;
  final CountDownController _controller = CountDownController();
  final PanelController _pc = PanelController();

  List<StepModel> steps = [];
  List<StepModel> _nextSteps = [];
  int _currentStepIndex = 0;
  String _actionText = 'Start workout';
  String _titleText = "";
  bool _isCurrentRest = false;
  String _restDuration = "";
  int _currentSecond = -1;

  void _getInitialInfo() {
    steps = StepModel.getStepsByWorkoutId(widget.workout.id);
    _nextSteps = steps.sublist(_currentStepIndex + 1);
    _duration = steps[0].duration;
    _titleText = steps[_currentStepIndex].name;
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();

    if (MediaQuery.of(context).size.height > 700) {
      return Scaffold(
        appBar: const NavBar(),
        body: _pageContent(context),
      );
    }

    return Scaffold(
      appBar: const NavBar(),
      body: _slidingPanelWidget(context),
    );
  }

  SlidingUpPanel _slidingPanelWidget(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 50,
      maxHeight: 180,
      controller: _pc,
      panelBuilder: () {
        return Column(children: [
          Container(
            alignment: Alignment.center,
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!_pc.isPanelOpen) {
                      _pc.open();
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Next steps (${_nextSteps.length})',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.5,
            color: Colors.grey[300],
          ),
          _nextStepsWidget(),
        ]);
      },
      body: _pageContent(context),
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
          Visibility(
            visible: MediaQuery.of(context).size.height > 700,
            replacement: const SizedBox.shrink(),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _nextStepsWidget(hideTitle: true),
            ),
          )
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
                    color: Theme.of(context).shadowColor.withOpacity(0.2),
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
              icon: SvgPicture.asset(
                'assets/icons/${widget.workout.category.icon}',
                height: 28,
                width: 28,
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
          child: Stack(
            children: [
              CircularCountDownTimer(
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
                  Future.delayed(Duration.zero, () async {
                      widget._audioCache
                          .play(AssetSource('audio/step-end.mp3'));

                      setState(() {
                        _currentSecond =  -1;
                      });
                    });
                  if (!_isCurrentRest) {
                    if (steps[_currentStepIndex].restDuration > 0) {
                      setState(() {
                        _isCurrentRest = true;
                        _duration = steps[_currentStepIndex].restDuration;
                      });
                      _controller.restart(
                          duration: steps[_currentStepIndex].restDuration);
                      return;
                    }
                  }
                  setState(() {
                    _currentStepIndex++;
                    _isCurrentRest = false;
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
                  if (_currentSecond == -1) {
                    _currentSecond = duration.inSeconds;
                  }
                  if (_currentSecond != duration.inSeconds &&
                      duration.inSeconds < 5) {
                    Future.delayed(Duration.zero, () async {
                      widget._audioCache
                          .play(AssetSource('audio/step-beep.mp3'));

                      setState(() {
                        _currentSecond = duration.inSeconds;
                      });
                    });
                  }

                  double seconds = duration.inMilliseconds / 1000;
                  if (_isCurrentRest) {
                    Future.delayed(Duration.zero, () async {
                      setState(() {
                        _restDuration = seconds.toStringAsFixed(1);
                      });
                    });
                    return '';
                  }
                  Future.delayed(Duration.zero, () async {
                    setState(() {
                      _restDuration = "";
                    });
                  });
                  return seconds.toStringAsFixed(1);
                },
              ),
              Positioned(
                top: 50,
                left: 62,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/rest.svg',
                      height: _isCurrentRest ? 70 : 0,
                      width: _isCurrentRest ? 70 : 0,
                    ),
                    const SizedBox(height: 17),
                    Text(_restDuration,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 25))
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 35),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              //elevation: 0,
              ),
          onPressed: () async {
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

  timerFormatter(defaultFormatterFunction, duration) {
    if (_currentSecond == -1) {
      _currentSecond = duration.inSeconds;
    }
    if (_currentSecond != duration.inSeconds && duration.inSeconds < 5) {
      Future.delayed(Duration.zero, () async {
        widget._audioCache.play(AssetSource('audio/step-beep.mp3'));

        setState(() {
          _currentSecond = duration.inSeconds;
        });
      });
    }

    double seconds = duration.inMilliseconds / 1000;
    if (_isCurrentRest) {
      Future.delayed(Duration.zero, () async {
        setState(() {
          _restDuration = seconds.toStringAsFixed(1);
        });
      });
      return '';
    }
    Future.delayed(Duration.zero, () async {
      setState(() {
        _restDuration = "";
      });
    });
    return seconds.toStringAsFixed(1);
  }

  void onStepComplete() {
    Future.delayed(Duration.zero, () async {
      widget._audioCache.play(AssetSource('audio/step-end.mp3'));

      setState(() {
        _currentSecond = -1;
      });
    });
    if (!_isCurrentRest) {
      if (steps[_currentStepIndex].restDuration > 0) {
        setState(() {
          _isCurrentRest = true;
          _duration = steps[_currentStepIndex].restDuration;
        });
        _controller.restart(duration: steps[_currentStepIndex].restDuration);
        return;
      }
    }
    setState(() {
      _currentStepIndex++;
      _isCurrentRest = false;
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
      _controller.restart(duration: steps[_currentStepIndex].duration);
    }
  }

  Column _nextStepsWidget({bool hideTitle = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: hideTitle,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${'Next steps (${_nextSteps.length}'})',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary, fontSize: 20),
            ),
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
                            'assets/icons/rest.svg',
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
        const SizedBox(height: 15),
      ],
    );
  }
}
