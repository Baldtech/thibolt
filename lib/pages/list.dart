import 'package:thibolt/common_libs.dart';

import 'package:thibolt/models/workout.dart';
import 'package:thibolt/pages/add_v2.dart';
import 'package:thibolt/pages/details.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Workout> workouts = [];

  void _getInitialInfo() {
    workouts = Workout.workouts;
  }

  Future<void> _pullRefresh() async {
    setState(() {
      workouts = Workout.workouts;
    });
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
        child: _pageContent(),
      ),
    );
  }

  Padding _pageContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(workout: workouts[index]),
                            ),
                          ),
                        },
                        child: BaseCard(
                          title: workouts[index].name,
                          subTitle: Utils.formatTime(workouts[index].duration),
                          icon: SvgPicture.asset(
                            'assets/icons/${workouts[index].category.icon}',
                            height: 28,
                            width: 28,
                          ),
                        ),
                      ),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 15,
                      ),
                  itemCount: workouts.length),
            ),
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
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPage(),
            ),
          ).then((value) => _pullRefresh());
        },
        child: const Text("+ New workout"),
      ),
    );
  }
}
