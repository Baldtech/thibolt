import 'package:thibolt/common_libs.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:thibolt/models/step.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _workoutTitle = 'Workout of the day';
  final _duration = 10;
  final CountDownController _controller = CountDownController();

  List<StepModel> steps = [];

  void _getInitialInfo() {
    steps = StepModel.getSteps();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();

    return Container(
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const SizedBox(height: 10),
                _title(),
                const SizedBox(height: 10),
                _current(context),
                const SizedBox(height: 35),
              ],
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _nextSteps())
        ],
      ),
    );
  }

  Padding _title() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: BaseCard(
        title: _workoutTitle,
        subTitle: 'Duration: 1m:5s',
        icon: const Image(
          image: AssetImage('assets/icons/illu_top.png'),
        ),
      ),
    );
  }

  Column _current(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'Monkey arm swings',
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
            isReverse: false,
            isReverseAnimation: false,
            isTimerTextShown: true,
            onStart: () {
              debugPrint('Countdown Started');
            },
            onComplete: () {
              debugPrint('Countdown Ended');
            },
            onChange: (String timeStamp) {
              debugPrint('Countdown Changed $timeStamp');
            },
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              debugPrint(duration.inSeconds.toString());
              if (duration.inSeconds == 0) {
                return _duration;
              } else if (duration.inSeconds == 5) {
                return 'bob';
              } else {
                return (_duration - duration.inSeconds).toString();
              }
            },
          ),
        ),
        const SizedBox(height: 35),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              //elevation: 0,
              ),
          onPressed: () {
            _controller.start();
          },
          child: const Text("Start workout"),
        ),
      ],
    );
  }

  Column _nextSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Next steps',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary, fontSize: 20),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 90,
          child: ListView.separated(
            itemCount: steps.length,
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
                        'Lateral plank',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.onTertiary),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '2 min',
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
                            '30 sec',
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
