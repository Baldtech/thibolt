import 'package:thibolt/common_libs.dart';

import 'package:thibolt/models/workout.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Workout> workouts = [];

  void _getInitialInfo() {
    workouts = Workout.getWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(left: 15, right: 15),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => {
                    debugPrint("tapped on ${workouts[index].name}"),
                  },
                  child: BaseCard(
                        title: workouts[index].name,
                        subTitle: Utils.formatTime(workouts[index].duration),
                        icon: const Image(
                          image: AssetImage('assets/icons/illu_top.png'),
                        ),
                      ),
                ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                itemCount: workouts.length),
          ),
        ],
      ),
    );
  }

  Align _header() {
    return Align(
      alignment: Alignment.topRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            //elevation: 0,
            ),
        onPressed: () {},
        child: const Text("+ New workout"),
      ),
    );
  }
}
