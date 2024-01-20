import 'package:thibolt/common_libs.dart';

import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:audioplayers/audioplayers.dart';

// Details page
class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, required this.workout}) : super(key: key);

  final Workout workout;
  final AudioPlayer audioCache = AudioPlayer();

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final CountDownController controller = CountDownController();
  final PanelController pc = PanelController();

  int duration = 0;
  List<WorkoutStep> steps = [];
  List<WorkoutStep> nextSteps = [];
  int currentStepIndex = 0;
  String actionText = 'Start workout';
  String titleText = "";
  bool isCurrentRest = false;
  String restDuration = "";
  int currentSecond = -1;

  void getInitialInfo() {
    steps = WorkoutStep.getStepsByWorkoutId(widget.workout.id);
    nextSteps = steps.sublist(currentStepIndex + 1);
    duration = steps[0].duration;
    titleText = steps[currentStepIndex].name;
  }

  @override
  Widget build(BuildContext context) {
    getInitialInfo();

    if (MediaQuery.of(context).size.height > 700) {
      return Scaffold(
        appBar: const NavBar(),
        body: pageContent(context),
      );
    }

    return Scaffold(
      appBar: const NavBar(),
      body: slidingPanelWidget(context),
    );
  }

  Widget slidingPanelWidget(BuildContext context) {
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
          nextStepsWidget(hideTitle: true),
        ]);
      },
      body: pageContent(context),
    );
  }

  Widget pageContent(BuildContext context) {
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
                titleWidget(context),
                const SizedBox(height: 10),
                current(context),
                const SizedBox(height: 35),
              ],
            ),
          ),
          Visibility(
            visible: MediaQuery.of(context).size.height > 700,
            replacement: const SizedBox.shrink(),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: nextStepsWidget(hideTitle: false),
            ),
          )
        ],
      ),
    );
  }

  Widget titleWidget(BuildContext context) {
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

  Widget current(context) {
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
                onComplete: onStepComplete,
                timeFormatterFunction: timerFormatter,
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
          onPressed: onWorkoutActionButtonPressed,
          child: Text(actionText),
        ),
      ],
    );
  }

  void onWorkoutActionButtonPressed() async {
    if (!controller.isStarted) {
      controller.restart(duration: steps[currentStepIndex].duration);
      setState(() {
        actionText = 'Pause';
      });
    } else {
      if (controller.isPaused) {
        controller.resume();
        setState(() {
          actionText = 'Pause';
        });
      } else {
        controller.pause();
        setState(() {
          actionText = 'Resume';
        });
      }
    }
  }

  timerFormatter(defaultFormatterFunction, duration) {
    if (currentSecond == -1) {
      currentSecond = duration.inSeconds;
    }
    if (currentSecond != duration.inSeconds && duration.inSeconds < 5) {
      Future.delayed(Duration.zero, () async {
        widget.audioCache.play(AssetSource('audio/step-beep.mp3'));

        setState(() {
          currentSecond = duration.inSeconds;
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

  void onStepComplete() {
    Future.delayed(Duration.zero, () async {
      widget.audioCache.play(AssetSource('audio/step-end.mp3'));

      setState(() {
        currentSecond = -1;
      });
    });
    if (!isCurrentRest) {
      if (steps[currentStepIndex].restDuration > 0) {
        setState(() {
          isCurrentRest = true;
          duration = steps[currentStepIndex].restDuration;
        });
        controller.restart(duration: steps[currentStepIndex].restDuration);
        return;
      }
    }
    setState(() {
      currentStepIndex++;
      isCurrentRest = false;
    });

    if (currentStepIndex >= steps.length) {
      setState(() {
        currentStepIndex = 0;
        duration = steps[currentStepIndex].duration;
        actionText = 'Start workout';
      });
      controller.reset();
    } else {
      setState(() {
        duration = steps[currentStepIndex].duration;
      });
      controller.restart(duration: steps[currentStepIndex].duration);
    }
  }

  Widget nextStepsWidget({bool hideTitle = false}) {
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
