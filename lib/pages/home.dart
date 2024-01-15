import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workout_app/models/step.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _duration = 10;
  final CountDownController _controller = CountDownController();

  List<StepModel> steps = [];

  void _getInitialInfo() {
    steps = StepModel.getSteps();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();

    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color.fromRGBO(247, 247, 255, 1),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            _title(),
            const SizedBox(height: 25),
            _current(),
            const SizedBox(height: 35),
            _nextSteps(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Column _nextSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Next steps',
            style: TextStyle(
                color: Color.fromRGBO(64, 3, 136, 1),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 35),
        Container(
          height: 90,
          child: ListView.separated(
            itemCount: steps.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(
              width: 25,
            ),
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(220, 203, 245, 1),
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage('assets/icons/illu_top.png'),
                      ),
                    ),
                    Text(
                      steps[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(144, 94, 157, 1),
                          fontSize: 14),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _current() {
    return Column(
      children: [
        const Text(
          'Monkey arm swings',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(64, 3, 136, 1),
              fontSize: 20),
          textAlign: TextAlign.center,
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
            ringColor: const Color.fromRGBO(234, 234, 234, 1),
            ringGradient: null,
            fillColor: const Color.fromRGBO(234, 234, 234, 1),
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
            textStyle: const TextStyle(
                fontSize: 33.0,
                color: Color.fromRGBO(64, 3, 136, 1),
                fontWeight: FontWeight.bold),
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
              if (duration.inSeconds == 0) {
                return _duration;
              } 
              else if(duration.inSeconds == 5) {
                return 'bob';
              }
              else {
                return (_duration - duration.inSeconds).toString();
              }
            },
          ),
        ),
        const SizedBox(height: 35),
        GestureDetector(
          onTap: () {
            _controller.start();
          },
          child: Container(
            height: 45,
            width: 170,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(206, 181, 252, 1),
                borderRadius: BorderRadius.circular(50)),
            child: const Center(
              child: Text(
                'Start workout',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding _title() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        height: 91,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(45),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ]),
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Image(
                image: AssetImage('assets/icons/illu_top.png'),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Week 1 - Session 2 ',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(64, 3, 136, 1),
                        fontSize: 16,),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Duration: 18m 50s',
                    style: TextStyle(
                        color: Color.fromRGBO(206, 181, 252, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Back',
        style: TextStyle(
            color: Color.fromRGBO(64, 3, 136, 1),
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Color.fromRGBO(247, 247, 255, 1),
      elevation: 0.0,
      centerTitle: false,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(247, 247, 255, 1),
              borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset(
            'assets/icons/arrow-prev.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }
}
