import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:thibolt/common_libs.dart';
import 'package:thibolt/data/repositories/category_repository.dart';
import 'package:thibolt/data/repositories/workout_repository.dart';
import 'package:thibolt/data/sqlite_database.dart';
import 'package:thibolt/models/category.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with AfterLayoutMixin<AddPage> {
  final formKey = GlobalKey<FormState>();

  late ICategoryRepository categoryRepository;
  late IWorkoutRepository workoutRepository;

  List<Category> categories = [];
  late Workout workout = Workout(
      name: "",
      categoryId: -1,
      duration: 100,
      );

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    var db = await SQLiteDatabase().initializeDB();
    categoryRepository = CategoryRepository(db: db);
    workoutRepository = WorkoutRepository(db: db);

    loadData();    
  }

  void loadData() async {
    final cat = await categoryRepository.getCategories();
    setState(() {
      categories = cat;

      workout.categoryId = categories.first.id;
    });
  }

  final List<WorkoutStep> steps = [
    WorkoutStep(name: 'Plank', duration: 60, restDuration: 15, order: 0),
    WorkoutStep(name: 'Plank 2', duration: 60, restDuration: 15, order: 1),
    WorkoutStep(
        name: 'Block 1',
        order: 2,
        type: StepType.block,
        occurence: 2,
        children: [
          WorkoutStep(name: 'Sub 1', duration: 60, restDuration: 15, order: 0),
          WorkoutStep(
              name: 'Sub 2 2', duration: 60, restDuration: 15, order: 1),
        ]),
  ];

  void _getInitialInfo() {
    _contents = steps.map((step) {
      return DragAndDropList(
        contentsWhenEmpty: null,
        header: step.type == StepType.block
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('${step.name} (${step.occurence})'),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            step.children!.add(WorkoutStep(
                                name: "Step",
                                order: step.children!.length,
                                duration: 60,
                                restDuration: 15));
                          });
                        },
                        child: const Text("+")),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            steps.remove(step);
                          });
                        },
                        child: const Text("X")),
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          '${step.name} (${Utils.formatTime(step.duration)}) (${Utils.formatTime(step.restDuration)})'),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              steps.remove(step);
                            });
                          },
                          child: const Text("X")),
                    ]),
              ),
        children: step.type == StepType.block
            ? step.children!.map((child) {
                return DragAndDropItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          '${child.name} (${Utils.formatTime(child.duration)}) (${Utils.formatTime(child.restDuration)})',
                          style: const TextStyle(color: Colors.red)),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              step.children!.remove(child);
                              if (step.children!.isEmpty) steps.remove(step);
                            });
                          },
                          child: const Text("X")),
                    ],
                  ),
                );
              }).toList()
            : [
                DragAndDropItem(
                    child: Container(
                  width: 0,
                  height: 0,
                  color: Colors.transparent,
                ))
              ],
      );
    }).toList();
  }

  late List<DragAndDropList> _contents;
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
        child: _pageContent(context),
      ),
    );
  }

  Padding _pageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: const Text("<"),
        ),
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                initialValue: workout != null ? workout.name : "",
                decoration: const InputDecoration(hintText: 'Workout name'),
                onSaved: (val) {
                  setState(() {
                    workout.name = val!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              DropdownButton<String>(
                value: categories.isNotEmpty ? workout.categoryId.toString() : null,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    workout.categoryId = int.parse(value!);
                  });
                },
                items: categories
                    .map<DropdownMenuItem<String>>((Category value) {
                  return DropdownMenuItem<String>(
                    value: value.id.toString(),
                    child: Text(value.name),
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        steps.add(WorkoutStep(
                            name: "Step",
                            order: steps.length,
                            type: StepType.single,
                            duration: 60,
                            restDuration: 15));
                      });
                    },
                    child: const Text("Step"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        steps.add(WorkoutStep(
                            name: "Block",
                            order: steps.length,
                            type: StepType.block,
                            occurence: 2,
                            children: [
                              WorkoutStep(
                                  name: "Sub 1",
                                  order: 0,
                                  duration: 60,
                                  restDuration: 15),
                              WorkoutStep(
                                  name: "Sub 2",
                                  order: 1,
                                  duration: 60,
                                  restDuration: 15)
                            ]));
                      });
                    },
                    child: const Text("Block"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        workoutRepository.addWorkout(workout);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: DragAndDropLists(
            children: _contents,
            onItemReorder: _onItemReorder,
            onListReorder: _onListReorder,
            listPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemDivider: const Divider(
              thickness: 2,
              height: 2,
              color: backgroundColor,
            ),
            itemDecorationWhileDragging: BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            listInnerDecoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            lastItemTargetHeight: 0,
            addLastItemTargetHeightToTop: true,
            lastListTargetSize: 40,
            listDragHandle: const DragHandle(
              verticalAlignment: DragHandleVerticalAlignment.top,
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.menu,
                  color: Colors.red,
                ),
              ),
            ),
            itemDragHandle: const DragHandle(
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.menu,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = steps[oldListIndex].children!.removeAt(oldItemIndex);
      steps[newListIndex].children!.insert(newItemIndex, movedItem);

      if (steps[oldListIndex].children!.isEmpty) steps.removeAt(oldListIndex);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = steps.removeAt(oldListIndex);
      steps.insert(newListIndex, movedList);
    });
  }
}
