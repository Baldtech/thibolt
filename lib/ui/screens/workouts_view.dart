import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/common_libs.dart';
import '../cubits/workouts/workouts_cubit.dart';

@RoutePage()
class WorkoutsView extends StatefulWidget {
  const WorkoutsView({Key? key}) : super(key: key);

  @override
  State<WorkoutsView> createState() => _buildWorkoutsViewState();
}

class _buildWorkoutsViewState extends State<WorkoutsView> {
  @override
  Widget build(BuildContext context) {
    final workoutsCubit = BlocProvider.of<WorkoutsCubit>(context);

    return Scaffold(
      appBar: const NavBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(workoutsCubit),
              const SizedBox(height: 20),
              BlocBuilder<WorkoutsCubit, WorkoutsState>(builder: (_, state) {
                switch (state.runtimeType) {
                  case WorkoutsLoading:
                    return const Center(child: CupertinoActivityIndicator());
                  case WorkoutsFailed:
                    return const Center(child: Icon(Icons.error));
                  case WorkoutsSuccess:
                    return _buildWorkouts(
                      workoutsCubit,
                      state.workouts,
                    );
                  default:
                    return const SizedBox();
                }
              }),
              //_buildWorkouts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(WorkoutsCubit workoutsCubit) {
    return Align(
      alignment: Alignment.topRight,
      child: ElevatedButton(
        onPressed: () {
          // Navigator.of(context)
          //     .push(
          //       MaterialPageRoute(
          //         builder: (context) => const WorkoutsView(), //AddUpdatePage(),
          //       ),
          //     )
          //     .then((value) => {}); //_refreshData());

          workoutsCubit.saveWorkout(
              workout: Workout(
                  id: -1,
                  name: "Test",
                  category: WorkoutCategory(id: 3, name: "Test", icon: "test"),
                  duration: 0,
                  steps: []));
        },
        child: const Text("+ New workout"),
      ),
    );
  }

  Widget _buildWorkouts(WorkoutsCubit workoutsCubit, List<Workout> workouts) {
    return Expanded(
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) =>
              _buildWorkout(workoutsCubit, workouts, context, index),
          separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
          itemCount: workouts.length),
    );
  }

  Widget _buildWorkout(WorkoutsCubit workoutsCubit, List<Workout> workouts,
      BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _onWorkoutTap(context, index),
      child: BaseCard(
          title: workouts[index].name,
          subTitle: Utils.formatTime(workouts[index].duration),
          icon: SvgPicture.asset(
            'assets/icons/${workouts[index].category.icon}',
            height: 28,
            width: 28,
          ),
          trailing: Row(
            children: [
              GestureDetector(
                onTap: () => _onWorkoutEditTap(context, index),
                child: const Icon(Icons.edit),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _onWorkoutDeleteTap(
                    workoutsCubit, context, workouts[index]),
                child: const Icon(Icons.delete),
              ),
            ],
          )),
    );
  }

  Set<Future<dynamic>> _onWorkoutTap(BuildContext context, int index) {
    return {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                WorkoutsView() //DetailsPage(workout: workouts[index]),
            ),
      ),
    };
  }

  Set<Future<void>> _onWorkoutEditTap(BuildContext context, int index) {
    return {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => WorkoutsView(//AddUpdatePage(
                  //workout: workouts[index],
                  ),
            ),
          )
          .then((value) => {}), //_refreshData()),
    };
  }

  Set<Future<dynamic>> _onWorkoutDeleteTap(
      WorkoutsCubit workoutsCubit, BuildContext context, Workout workout) {
    return {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
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
                workoutsCubit.removeWorkout(workout: workout);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        ),
      ),
    };
  }
}
