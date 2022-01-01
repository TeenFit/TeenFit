import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:teenfit/screens/user_screen.dart';
import 'package:uuid/uuid.dart';

import '/providers/workout.dart';
import 'create_workout.dart';
import '/providers/workouts.dart';
import '/widgets/workout_tile.dart';

class CreateWorkout extends StatefulWidget {
  static const routeName = '/create-workout';

  @override
  State<CreateWorkout> createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends State<CreateWorkout> {
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });

    Provider.of<Workouts>(context, listen: false).removeFailedWorkouts();

    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    var uuid = Uuid();

    String uid = Provider.of<Auth>(context, listen: false).userId!;

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            IconThemeData(color: Colors.white, size: _appBarHeight * 0.5),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddWorkoutScreen.routeName,
                  arguments: {
                    'workout': Workout(
                      failed: false,
                      pending: true,
                      date: DateTime.now(),
                      creatorName: '',
                      creatorId: uid,
                      workoutId: uuid.v4(),
                      workoutName: '',
                      instagram: '',
                      facebook: '',
                      tiktokLink: '',
                      bannerImage: null,
                      bannerImageLink: null,
                      exercises: [],
                    ),
                    'isEdit': false
                  },
                );
              },
              icon: Icon(
                Icons.add_box_outlined,
                color: Colors.white,
                size: _appBarHeight * 0.45,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  UserScreen.routeName,
                );
              },
              icon: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: _appBarHeight * 0.45,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: _mediaQuery.size.width * 0.5,
                width: _mediaQuery.size.width * 0.5,
                child: Image.asset(
                  'assets/images/teen_fit_logo_white_withpeople 1@3x.png',
                  fit: BoxFit.contain,
                ),
              ),
            )
          : Container(
              height: _mediaQuery.size.height,
              width: _mediaQuery.size.width,
              child: Consumer<Workouts>(
                builder: (ctx, workout, _) => ListView.builder(
                  itemBuilder: (ctx, index) {
                    return workout.findByCreatorId(uid).length == 0
                        ? Container(
                            height: (_mediaQuery.size.height - _appBarHeight),
                            width: _mediaQuery.size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: (_mediaQuery.size.height -
                                          _appBarHeight) *
                                      0.05,
                                ),
                                Container(
                                  height: (_mediaQuery.size.height -
                                          _appBarHeight) *
                                      0.05,
                                  width: _mediaQuery.size.width * 0.8,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Create Your First Workout...',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            _mediaQuery.size.height * 0.025,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : WorkoutTile(
                            workout.findByCreatorId(uid)[index],
                            true,
                            false,
                          );
                  },
                  itemCount: workout.findByCreatorId(uid).length == 0
                      ? 1
                      : workout.findByCreatorId(uid).length,
                ),
              ),
            ),
    );
  }
}
