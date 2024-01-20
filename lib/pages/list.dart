import 'package:thibolt/common_libs.dart';

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

  Future<void> pullRefresh() async {
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
        child: pageContent(),
      ),
    );
  }

  Widget pageContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          header(),
          const SizedBox(height: 20),
          _listWidget(),
        ],
      ),
    );
  }

  Widget header() {
    return Align(
      alignment: Alignment.topRight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const AddPage(),
                ),
              )
              .then((value) => pullRefresh());
        },
        child: const Text("+ New workout"),
      ),
    );
  }

  Widget _listWidget() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: pullRefresh,
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
    );
  }
}
