import 'package:flutter/material.dart';
import 'package:teenfit/Custom/custom_dialog.dart';
import 'package:teenfit/screens/exercise_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/exercise_tiles.dart';
import '../Custom/my_flutter_app_icons.dart';
import '../providers/workout.dart';

class WorkoutPage extends StatelessWidget {
  static const routeName = '/workout-page';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);
    final _statusBarHeight = _mediaQuery.padding.top;

    final Workout workout =
        ModalRoute.of(context)!.settings.arguments as Workout;

    return Scaffold(
      backgroundColor: _theme.highlightColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _mediaQuery.size.height,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: _mediaQuery.size.height * 0.35,
              width: double.infinity,
              child: Stack(
                children: [
                  FadeInImage(
                    placeholder: AssetImage('assets/images/loading-gif.gif'),
                    placeholderErrorBuilder: (context, _, __) => Image.asset(
                      'assets/images/loading-gif.gif',
                      fit: BoxFit.contain,
                    ),
                    fit: BoxFit.cover,
                    image: workout.bannerImage.isEmpty
                        ? AssetImage('assets/images/BannerImageUnavailable.png')
                        : AssetImage(workout.bannerImage),
                    imageErrorBuilder: (image, _, __) => Image.asset(
                      'assets/images/ImageUploadError.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: _mediaQuery.size.height * 0.35,
                          width: _mediaQuery.size.width * 0.1,
                          child: Column(
                            children: [
                              SizedBox(
                                height: _statusBarHeight,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.arrow_back),
                                iconSize: _appBarHeight * 0.55,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: _mediaQuery.size.height * 0.35,
                          width: _mediaQuery.size.width * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: _statusBarHeight,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                                child: Text(
                                  workout.workoutName,
                                  maxLines: 2,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: _mediaQuery.size.height * 0.05,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Container(
                                width: _mediaQuery.size.width * 0.55,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 5, 15, 5),
                                    child: Text(
                                      'by: ${workout.creatorName}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'PTSans',
                                        fontSize:
                                            _mediaQuery.size.height * 0.035,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                child: Container(
                                  height: (_mediaQuery.size.height -
                                          _appBarHeight) *
                                      0.13,
                                  width: _mediaQuery.size.width * 0.55,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        workout.instagram.isEmpty
                                            ? SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  try {
                                                    launch(workout.instagram);
                                                  } catch (e) {
                                                    return null;
                                                  }
                                                },
                                                icon: Icon(
                                                  MyFlutterApp.instagram,
                                                  size:
                                                      _mediaQuery.size.height *
                                                          0.045,
                                                  color: Colors.red,
                                                ),
                                              ),
                                        workout.facebook.isEmpty
                                            ? SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  try {
                                                    launch(workout.facebook);
                                                  } catch (e) {
                                                    return null;
                                                  }
                                                },
                                                icon: Icon(
                                                  MyFlutterApp.facebook_squared,
                                                  size:
                                                      _mediaQuery.size.height *
                                                          0.045,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                        workout.tumblrPageLink.isEmpty
                                            ? SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  try {
                                                    launch(
                                                        workout.tumblrPageLink);
                                                  } catch (e) {
                                                    return null;
                                                  }
                                                },
                                                icon: Icon(
                                                  MyFlutterApp.tumblr_squared,
                                                  size:
                                                      _mediaQuery.size.height *
                                                          0.045,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Container(
                height: _mediaQuery.size.height * 0.07,
                width: _mediaQuery.size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: _theme.primaryColor),
                  child: Text(
                    'Start Workout',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PTSans',
                        fontSize: _mediaQuery.size.height * 0.035),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => CustomDialogBox(
                            'Are You Ready?',
                            'Grab a Water Bottle, Warmup, Lets Do This',
                            'assets/images/water_bottle.jpg',
                            ExerciseScreen.routeName,
                            workout.exercises));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Container(
                  height: _mediaQuery.size.height * 0.5,
                  width: _mediaQuery.size.width,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => ExerciseTiles(
                      workout.exercises[index],
                      _mediaQuery.size.width,
                      false,
                      () {},
                      [],
                    ),
                    itemCount: workout.exercises.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
