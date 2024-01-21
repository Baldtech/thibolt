import 'package:after_layout/after_layout.dart';
import 'package:thibolt/common_libs.dart';
import 'package:thibolt/data/repositories/category_repository.dart';
import 'package:thibolt/data/repositories/workout_repository.dart';
import 'package:thibolt/data/sqlite_database.dart';
import 'package:thibolt/pages/workout_add_update.dart';
import 'package:thibolt/pages/workout_details.dart';

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

    _refreshData();
  }

  void _refreshData() async {
    final cat = await categoryRepository.getCategories();
    final work = await workoutRepository.getWorkouts();
    setState(() {
      categories = cat;
      workouts = work;
    });
  }

  Future<void> _pullRefresh() async {
    _refreshData();
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
        child: _pageContent(),
      ),
    );
  }

  Widget _pageContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 20),
          _list(),
        ],
      ),
    );
  }

  Widget _header() {
    return Align(
      alignment: Alignment.topRight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const AddUpdatePage(),
                ),
              )
              .then((value) => _pullRefresh());
        },
        child: const Text("+ New workout"),
      ),
    );
  }

  Widget _list() {
    return Expanded(
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
                        'assets/icons/${categories.firstWhere((element) => element.id == workouts[index].categoryId).icon}',
                        height: 28,
                        width: 28,
                      ),
                      trailing: Row(
                        children: [
                          GestureDetector(
                            onTap: () => {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => AddUpdatePage(
                                        workout: workouts[index],
                                      ),
                                    ),
                                  )
                                  .then((value) => _pullRefresh()),
                            },
                            child: const Icon(Icons.edit),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _openDeletePopup(context, index),
                              ),
                            },
                            child: const Icon(Icons.delete),
                          ),
                        ],
                      )),
                ),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 15,
                ),
            itemCount: workouts.length),
      ),
    );
  }

  AlertDialog _openDeletePopup(BuildContext context, int index) {
    return AlertDialog(
      title: Text(
        "Delete",
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      content: Text("Are you sure you want to delete this workout?",
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await workoutRepository
                .removeWorkout(workouts[index].id)
                .then((value) {
              Navigator.of(context).pop();
              _pullRefresh();
            });
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
