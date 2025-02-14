import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:teenfit/pickers/exercise_image_picker.dart';
import '/providers/exercise.dart';
import 'package:uuid/uuid.dart';

class SetsAndReps extends StatefulWidget {
  final Map? exerciseProv;

  SetsAndReps(
    this.exerciseProv,
  );

  @override
  _SetsAndRepsState createState() => _SetsAndRepsState();
}

class _SetsAndRepsState extends State<SetsAndReps> {
  final _formKey4 = GlobalKey<FormState>();
  var uuid = Uuid();
  bool isInit = false;
  bool isLoading = false;
  int reps = 5;
  int sets = 5;
  int time = 5;
  int restTime = 5;

  Map? _exerciseProv;
  Exercise? _newExercise;
  Function? _addExercise;
  Function? _updateExercise;

  @override
  void didChangeDependencies() {
    _exerciseProv = widget.exerciseProv;

    if (isInit == false) {
      _newExercise = _exerciseProv!['exercise'];

      reps = _newExercise!.reps != null ? _newExercise!.reps! : 5;
      sets = _newExercise!.sets != null ? _newExercise!.sets! : 5;

      _newExercise = Exercise(
        name2: _newExercise!.name2,
        exerciseImage2: _newExercise!.exerciseImage2,
        exerciseImageLink2: _newExercise!.exerciseImageLink2,
        reps2: _newExercise!.reps2,
        exerciseImageLink: _newExercise!.exerciseImageLink,
        exerciseId: _newExercise!.exerciseId,
        name: _newExercise!.name,
        exerciseImage: _newExercise!.exerciseImage,
        reps: _newExercise!.reps,
        sets: _newExercise!.sets,
        restTime: _newExercise!.restTime,
        timeSeconds: _newExercise!.timeSeconds,
      );

      setState(() {
        isInit = true;
      });
    }

    _addExercise = _exerciseProv!['addExercise'];

    _updateExercise = _exerciseProv!['updateExercise'];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    bool isEdit = _exerciseProv!['edit'];

    void _showToast(String msg) {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: msg,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        webShowClose: true,
        textColor: Colors.white,
        backgroundColor: Colors.grey.shade700,
      );
    }

    Future<void> _pick(File? image, File? video) async {
      setState(() {
        isLoading = true;
      });
      if (image != null) {
        setState(() {
          _newExercise = Exercise(
              name2: _newExercise!.name2,
              exerciseImage2: _newExercise!.exerciseImage2,
              exerciseImageLink2: _newExercise!.exerciseImageLink2,
              reps2: _newExercise!.reps2,
              exerciseId: _newExercise!.exerciseId,
              name: _newExercise!.name,
              exerciseImage: image,
              sets: _newExercise!.sets,
              reps: _newExercise!.reps,
              timeSeconds: _newExercise!.timeSeconds,
              restTime: _newExercise!.restTime,
              exerciseImageLink: _newExercise!.exerciseImageLink);
        });
      } else if (video != null) {
        setState(() {
          _newExercise = Exercise(
              name2: _newExercise!.name2,
              exerciseImage2: _newExercise!.exerciseImage2,
              exerciseImageLink2: _newExercise!.exerciseImageLink2,
              reps2: _newExercise!.reps2,
              exerciseId: _newExercise!.exerciseId,
              name: _newExercise!.name,
              exerciseImage: video,
              sets: _newExercise!.sets,
              reps: _newExercise!.reps,
              timeSeconds: _newExercise!.timeSeconds,
              restTime: _newExercise!.restTime,
              exerciseImageLink: _newExercise!.exerciseImageLink);
        });
      }
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

    void removeImage() {
      print('image');
      setState(() {
        _newExercise = Exercise(
            name2: _newExercise!.name2,
            exerciseImage2: _newExercise!.exerciseImage2,
            exerciseImageLink2: _newExercise!.exerciseImageLink2,
            reps2: _newExercise!.reps2,
            exerciseId: _newExercise!.exerciseId,
            name: _newExercise!.name,
            exerciseImage: null,
            sets: _newExercise!.sets,
            reps: _newExercise!.reps,
            timeSeconds: _newExercise!.timeSeconds,
            restTime: _newExercise!.restTime,
            exerciseImageLink: null);
      });
    }

    Future<void> _submit() async {
      if (!_formKey4.currentState!.validate()) {
        _showToast('Failed Fields');
        return;
      }

      setState(() {
        isLoading = true;
      });

      _formKey4.currentState!.save();

      _newExercise = Exercise(
          name2: null,
          exerciseId: _newExercise!.exerciseId,
          name: _newExercise!.name,
          exerciseImage: _newExercise!.exerciseImage,
          sets: sets,
          reps: reps,
          reps2: null,
          timeSeconds: null,
          restTime: null,
          exerciseImage2: null,
          exerciseImageLink2: null,
          exerciseImageLink: _newExercise!.exerciseImageLink);

      isEdit
          ? await _updateExercise!(_newExercise)
          : await _addExercise!(_newExercise);

      Navigator.of(context).pop();

      if (this.mounted) {
        setState(() {
          isLoading = true;
        });
      }
    }

    Widget buildExerciseName() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: _newExercise!.name,
            decoration: InputDecoration(
              hintText: 'Exercise Name',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().trim().isEmpty) {
                return 'Name is Required';
              } else if (value == null) {
                return 'Name is Required';
              }
              return null;
            },
            onSaved: (input) {
              _newExercise = Exercise(
                  name2: _newExercise!.name2,
                  exerciseImage2: _newExercise!.exerciseImage2,
                  exerciseImageLink2: _newExercise!.exerciseImageLink2,
                  reps2: _newExercise!.reps2,
                  exerciseId: _newExercise!.exerciseId,
                  name: input.toString().trim(),
                  timeSeconds: _newExercise!.timeSeconds,
                  restTime: _newExercise!.restTime,
                  sets: _newExercise!.sets,
                  reps: _newExercise!.reps,
                  exerciseImage: _newExercise!.exerciseImage,
                  exerciseImageLink: _newExercise!.exerciseImageLink);
            },
          ),
        ),
      );
    }

    Widget buildReps() {
      return Container(
        height: _mediaQuery.size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.32,
                width: _mediaQuery.size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: _mediaQuery.size.height * 0.02,
                    ),
                    Text(
                      'SETS',
                      style: TextStyle(
                        wordSpacing: 2,
                        fontSize: 20,
                      ),
                    ),
                    NumberPicker(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(),
                      ),
                      value: sets,
                      minValue: 1,
                      maxValue: 10,
                      step: 1,
                      onChanged: (value) => setState(() => sets = value),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.32,
                width: _mediaQuery.size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: _mediaQuery.size.height * 0.02,
                    ),
                    Text(
                      'REPS',
                      style: TextStyle(
                        wordSpacing: 2,
                        fontSize: 20,
                      ),
                    ),
                    NumberPicker(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(),
                      ),
                      value: reps,
                      minValue: 5,
                      maxValue: 25,
                      step: 1,
                      onChanged: (value) => setState(() => reps = value),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: (_mediaQuery.size.height - _appBarHeight) * 0.77,
      width: _mediaQuery.size.width,
      child: Form(
        key: _formKey4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
              ),
              ExerciseImagePicker(
                _pick,
                null,
                _newExercise!.exerciseImageLink,
                _newExercise!.exerciseImage,
                false,
                removeImage,
                null,
              ),
              buildExerciseName(),
              SizedBox(
                height: _mediaQuery.size.height * 0.03,
              ),
              buildReps(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: _mediaQuery.size.width,
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: _theme.secondaryHeaderColor,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 4,
                            backgroundColor: _theme.shadowColor,
                            color: Colors.white,
                          )
                        : Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                              fontSize: _mediaQuery.size.height * 0.03,
                            ),
                          ),
                    onPressed: isLoading
                        ? () {}
                        : () async {
                            await _submit();
                          },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
