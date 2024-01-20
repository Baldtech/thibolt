import 'package:after_layout/after_layout.dart';
import 'package:thibolt/common_libs.dart';
import 'package:thibolt/data/repositories/category_repository.dart';
import 'package:thibolt/data/repositories/workout_repository.dart';
import 'package:thibolt/data/sqlite_database.dart';
import 'package:thibolt/models/category.dart';

import 'package:thibolt/pages/add_v2.dart';
import 'package:thibolt/pages/details.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with AfterLayoutMixin<ListPage> {
  late ICategoryRepository categoryRepository;
  late IWorkoutRepository workoutRepository;

  List<Category> categories = [];
  List<Workout> workouts = [];

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    var db = await SQLiteDatabase().initializeDB();
    categoryRepository = CategoryRepository(db: db);
    workoutRepository = WorkoutRepository(db: db);
    refreshData();
  }

  void refreshData() async {
    final cat = await categoryRepository.getCategories();
    final work = await workoutRepository.getWorkouts();
    setState(() {
      categories = cat;
      workouts = work;
    });
  }

  Future<void> pullRefresh() async {
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
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
                      'assets/icons/${categories.firstWhere((element) => element.id == workouts[index].categoryId).icon}',
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
