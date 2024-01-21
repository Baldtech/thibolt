import 'dart:async';
import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/services.dart';
import 'package:thibolt/common_libs.dart';
import 'package:thibolt/data/repositories/category_repository.dart';
import 'package:thibolt/data/repositories/workout_repository.dart';
import 'package:thibolt/data/sqlite_database.dart';

class AddUpdatePage extends StatefulWidget {
  const AddUpdatePage({Key? key, this.workout}) : super(key: key);

  final Workout? workout;

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage>
    with AfterLayoutMixin<AddUpdatePage> {
  final formKey = GlobalKey<FormState>();

  late ICategoryRepository categoryRepository;
  late IWorkoutRepository workoutRepository;

  List<Category> categories = [];
  List<WorkoutStep> steps = [];
  List<DragAndDropList> _contents = [];

  late Workout workout = widget.workout == null
      ? Workout(
          name: "",
          categoryId: -1,
          duration: 100,
        )
      : Workout(
          id: widget.workout!.id,
          name: widget.workout!.name,
          categoryId: widget.workout!.categoryId,
          duration: widget.workout!.duration,
          stepJson: widget.workout!.stepJson,
        );

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    var db = await SQLiteDatabase().initializeDB();
    categoryRepository = CategoryRepository(db: db);
    workoutRepository = WorkoutRepository(db: db);

    _loadData();
  }

  void _loadData() async {
    final cat = await categoryRepository.getCategories();

    List<WorkoutStep> lSteps = [];
    // New workout
    if (workout.categoryId == -1) {
      workout.categoryId = cat.first.id;
      lSteps.add(WorkoutStep(
          name: "Step #1",
          order: steps.length,
          type: StepType.single,
          duration: 60,
          restDuration: 15));
      lSteps.add(WorkoutStep(
          name: "Step #1",
          order: steps.length,
          type: StepType.single,
          duration: 60,
          restDuration: 15));
    } else {
      lSteps = jsonDecode(workout.stepJson)
          .map<WorkoutStep>((e) => WorkoutStep.fromJson(e))
          .toList();
    }

    setState(() {
      categories = cat;
      steps = lSteps;
    });
  }

  void _setContent() {
    _contents = steps.map((step) {
      return DragAndDropList(
        contentsWhenEmpty: null,
        header: step.type == StepType.repeat
            ? Container(
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        initialValue: step.occurence.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) => {
                          if (value.isNotEmpty)
                            setState(() {
                              step.occurence = int.parse(value);
                            })
                        },
                        decoration: const InputDecoration(hintText: 'Duration'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          step.children!.add(WorkoutStep(
                              name: "Step",
                              order: step.children!.length,
                              duration: 60,
                              restDuration: 15));
                        })
                      },
                      child: const Icon(Icons.add),
                    ),
                    GestureDetector(
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildDeletePopupDialog(context, step, null)),
                      },
                      child: const Icon(Icons.delete_forever),
                    )
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
                      GestureDetector(
                        onTap: () => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildEditPopupDialog(context, step)),
                        },
                        child: const Icon(Icons.edit),
                      ),
                      GestureDetector(
                        onTap: () => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildDeletePopupDialog(context, step, null)),
                        },
                        child: const Icon(Icons.delete_forever),
                      ),
                    ]),
              ),
        children: step.type == StepType.repeat
            ? step.children!.map((child) {
                return DragAndDropItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          '${child.name} (${Utils.formatTime(child.duration)}) (${Utils.formatTime(child.restDuration)})',
                          style: const TextStyle(color: Colors.red)),
                      GestureDetector(
                        onTap: () => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildEditPopupDialog(context, child)),
                        },
                        child: const Icon(Icons.edit),
                      ),
                      GestureDetector(
                        onTap: () => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildDeletePopupDialog(
                                      context, step, child)),
                        },
                        child: const Icon(Icons.delete_forever),
                      ),
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

  @override
  Widget build(BuildContext context) {
    _setContent();
    
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
                initialValue: workout.name,
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
                value: categories.isNotEmpty
                    ? workout.categoryId.toString()
                    : null,
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
                items:
                    categories.map<DropdownMenuItem<String>>((Category value) {
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
                            name: "Repeat",
                            order: steps.length,
                            type: StepType.repeat,
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
                    child: const Text("Repeat"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        workout.stepJson = jsonEncode(steps);
                        workout.duration = _getWorkoutDuration(steps);
                        if (workout.id != -1) {
                          await workoutRepository
                              .updateWorkout(workout)
                              .then((value) => Navigator.pop(context));
                        } else {
                          await workoutRepository
                              .addWorkout(workout)
                              .then((value) => Navigator.pop(context));
                        }
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

  int _getWorkoutDuration(List<WorkoutStep> steps) {
    var total = 0;
    for (var step in steps) {
      if (step.type == StepType.repeat) {
        for (var i = 0; i < step.occurence; i++) {
          total += _getWorkoutDuration(step.children!);
        }
      } else {
        total += step.duration + step.restDuration;
      }
    }
    return total;
  }

  Widget _buildEditPopupDialog(BuildContext context, WorkoutStep step,
      {bool newStep = false}) {
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: Text(newStep ? "New step" : step.name,
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary)),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              initialValue: step.name,
              decoration: const InputDecoration(hintText: 'Step name'),
              onSaved: (val) {
                setState(() {
                  step.name = val!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              initialValue: step.duration.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(hintText: 'Duration'),
              onSaved: (val) {
                setState(() {
                  step.duration = int.parse(val!);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a duration';
                }
                if (int.parse(value) == 0) {
                  return 'Must be higher than 0';
                }
                return null;
              },
            ),
            TextFormField(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              initialValue: step.restDuration.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(hintText: 'Rest duration'),
              onSaved: (val) {
                setState(() {
                  step.restDuration = int.parse(val!);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a duration';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      if (newStep) {
                        setState(() {
                          step.order = steps.length;
                          steps.add(step);
                        });
                      }
                      Navigator.of(context).pop();
                    }
                  },
                ),
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDeletePopupDialog(
      BuildContext context, WorkoutStep parent, WorkoutStep? child) {
    return AlertDialog(
      title: Text(child != null ? child.name : parent.name,
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary)),
      content: Text(
        "Are you sure you want to delete this step?",
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              if (child != null) {
                parent.children!.remove(child);
              } else {
                steps.remove(parent);
              }
            });
            Navigator.of(context).pop();
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
