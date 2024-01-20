import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:thibolt/common_libs.dart';
import 'package:thibolt/models/category.dart';
import 'package:thibolt/models/step.dart';
import 'package:thibolt/models/workout.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  var steps = [
    WorkoutStep(name: 'Plank', duration: 60, restDuration: 15, order: 0),
    WorkoutStep(name: 'Plank 2', duration: 60, restDuration: 15, order: 1),
  ];

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
        child: _pageContent(context),
      ),
    );
  }

  // reorder method
  void updateStepOrder(int oldIndex, int newIndex) {
    setState(() {
      // this adjustment is needed when moving down the list
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      // get the tile we are moving
      final WorkoutStep tile = steps.removeAt(oldIndex);
      // place the tile in new position
      steps.insert(newIndex, tile);
    });
  }

  Padding _pageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    //elevation: 0,
                    ),
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text("Back"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    //elevation: 0,
                    ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildPopupDialog(
                        context, WorkoutStep(name: ""),
                        newStep: true),
                  );
                },
                child: const Text("Add step"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    //elevation: 0,
                    ),
                onPressed: () {
                  Workout.workouts.add(Workout(
                      id: Workout.workouts.length,
                      name: "Test",
                      category: Category.categories.first));
                  Navigator.pop(context);
                },
                child: const Text("Save workout"),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.all(10),
              dragStartBehavior: DragStartBehavior.start,
              children: steps.map((step) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  key: ValueKey(step.order),
                  child: Container(
                    color: Colors.red,
                    width: 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            '${step.name} (${Utils.formatTime(step.duration)}) (${Utils.formatTime(step.restDuration)})'),
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context, step),
                              );
                            },
                            child: const Text("E")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                steps.remove(step);
                              });
                            },
                            child: const Text("X")),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onReorder: (oldIndex, newIndex) {
                updateStepOrder(oldIndex, newIndex);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, WorkoutStep step,
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
}
