import 'dart:async';
import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:thibolt/common_libs.dart';

import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thibolt/data/repositories/category_repository.dart';
import 'package:thibolt/data/sqlite_database.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// Details page
class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, required this.workout}) : super(key: key);

  final Workout workout;
  final AudioPlayer audioCache = AudioPlayer();

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with AfterLayoutMixin<DetailsPage> {
  final CountDownController controller = CountDownController();
  final PanelController pc = PanelController();

  late ICategoryRepository categoryRepository;

  int duration = 0;
  List<WorkoutStep> steps = [];
  List<WorkoutStep> nextSteps = [];
  int _currentStepIndex = 0;
  String actionText = 'Start workout';
  String titleText = "";
  bool isCurrentRest = false;
  String restDuration = "";
  int _currentSecond = -1;

  Category? category;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    var db = await SQLiteDatabase().initializeDB();
    categoryRepository = CategoryRepository(db: db);

    final Category catDb =
        await categoryRepository.getCategory(widget.workout.categoryId);

    setState(() {
      category = catDb;
    });

    final tempSteps = jsonDecode(widget.workout.stepJson)
        .map<WorkoutStep>((e) => WorkoutStep.fromJson(e))
        .toList();

    for (WorkoutStep step in tempSteps) {
      if (step.type == StepType.repeat) {
        for (var i = 0; i < step.occurence; i++) {
          for (WorkoutStep subStep in step.children!) {
            steps.add(subStep);
          }
        }
      } else {
        steps.add(step);
      }
    }
    nextSteps = steps.sublist(_currentStepIndex + 1);
    duration = steps[0].duration;
    titleText = steps[_currentStepIndex].name;
  }

  @override
  Widget build(BuildContext context) {
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

  Widget _slidingPanelWidget(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 50,
      maxHeight: 180,
      controller: pc,
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
                    if (!pc.isPanelOpen) {
                      pc.open();
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Next steps (${nextSteps.length})',
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
            color: Theme.of(context).colorScheme.secondary,
          ),
          _nextStepsWidget(hideTitle: true),
        ]);
      },
      body: _pageContent(context),
    );
  }

  Widget _pageContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"),
          fit: BoxFit.cover,
        ),
      ),
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
              child: _nextStepsWidget(hideTitle: false),
            ),
          )
        ],
      ),
    );
  }

  Widget _titleWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          Container(
            height: 70,
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
              top: 22,
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
          if (category != null)
            Positioned.fill(
              top: 0,
              left: 35,
              child: BaseCard(
                title: widget.workout.name,
                subTitle: Utils.formatTime(widget.workout.duration),
                icon: SvgPicture.asset(
                  'assets/icons/${category!.icon}',
                  height: 28,
                  width: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _current(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            titleText,
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
                duration: duration,
                initialDuration: 0,
                controller: controller,
                width: 200,
                height: 200,
                ringColor: Theme.of(context).colorScheme.surface,
                ringGradient: null,
                fillColor: Theme.of(context).colorScheme.surface,
                fillGradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    timerGradient1,
                    timerGradient2,
                    timerGradient3,
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
                onComplete: _onStepComplete,
                timeFormatterFunction: _timerFormatter,
              ),
              Positioned(
                top: 50,
                left: 62,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/rest.svg',
                      height: isCurrentRest ? 70 : 0,
                      width: isCurrentRest ? 70 : 0,
                    ),
                    const SizedBox(height: 17),
                    Text(restDuration,
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
          onPressed: _onWorkoutActionButtonPressed,
          child: Text(actionText),
        ),
      ],
    );
  }

  void _onWorkoutActionButtonPressed() async {
    if (!controller.isStarted) {
      controller.restart(duration: steps[_currentStepIndex].duration);
      setState(() {
        actionText = 'Pause';
        WakelockPlus.enable();
      });
    } else {
      if (controller.isPaused) {
        controller.resume();
        setState(() {
          actionText = 'Pause';
          WakelockPlus.enable();
        });
      } else {
        controller.pause();
        setState(() {
          actionText = 'Resume';
          WakelockPlus.disable();
        });
      }
    }
  }

  _timerFormatter(defaultFormatterFunction, duration) {
    if (_currentSecond == -1) {
      _currentSecond = duration.inSeconds;
    }
    if (_currentSecond != duration.inSeconds && duration.inSeconds < 5) {
      Future.delayed(Duration.zero, () async {
        widget.audioCache.play(AssetSource('audio/step-beep.mp3'));

        setState(() {
          _currentSecond = duration.inSeconds;
        });
      });
    }

    double seconds = duration.inMilliseconds / 1000;
    if (isCurrentRest) {
      Future.delayed(Duration.zero, () async {
        setState(() {
          restDuration = seconds.toStringAsFixed(1);
        });
      });
      return '';
    }
    Future.delayed(Duration.zero, () async {
      setState(() {
        restDuration = "";
      });
    });
    return seconds.toStringAsFixed(1);
  }

  void _onStepComplete() {
    Future.delayed(Duration.zero, () async {
      widget.audioCache.play(AssetSource('audio/step-end.mp3'));

      setState(() {
        _currentSecond = -1;
      });
    });
    if (!isCurrentRest) {
      if (steps[_currentStepIndex].restDuration > 0) {
        setState(() {
          isCurrentRest = true;
          duration = steps[_currentStepIndex].restDuration;
        });
        controller.restart(duration: steps[_currentStepIndex].restDuration);
        return;
      }
    }
    setState(() {
      _currentStepIndex++;
      isCurrentRest = false;
    });

    if (_currentStepIndex >= steps.length) {
      setState(() {
        _currentStepIndex = 0;
        duration = steps[_currentStepIndex].duration;
        actionText = 'Start workout';
      });
      controller.reset();
    } else {
      setState(() {
        duration = steps[_currentStepIndex].duration;
      });
      controller.restart(duration: steps[_currentStepIndex].duration);
    }
  }

  Widget _nextStepsWidget({bool hideTitle = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: hideTitle,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${'Next steps (${nextSteps.length}'})',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary, fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 90,
          child: ListView.separated(
            itemCount: nextSteps.length,
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
                        nextSteps[index].name,
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
                        Utils.formatTime(nextSteps[index].duration),
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
                            Utils.formatTime(nextSteps[index].restDuration),
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
