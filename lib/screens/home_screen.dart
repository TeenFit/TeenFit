import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/adState.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:teenfit/providers/user.dart';
import 'package:teenfit/providers/userProv.dart';
import 'package:teenfit/screens/auth/login_screen.dart';
import 'package:teenfit/screens/discovery_page.dart';
import 'package:teenfit/screens/planning_screen.dart';
import 'package:teenfit/screens/my_workouts.dart';
import 'package:teenfit/screens/user_screen.dart';
import 'package:teenfit/screens/workout_page.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInit = false;
  Widget? pageView;
  NotificationSettings? settings;

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'newWorkout') {
      Navigator.of(context).pushNamed(
        WorkoutPage.routeName,
        arguments: {
          'workoutId': message.data['workoutId'],
          'workout': null,
          'isDeletable': false,
        },
      );
    }
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    await FirebaseMessaging.instance.subscribeToTopic("newWorkout");
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit == false) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: true,
        sound: true,
      );

      if (settings!.authorizationStatus == AuthorizationStatus.authorized) {
        await setupInteractedMessage();
      }

      var auth = Provider.of<Auth>(context, listen: false);

      if (auth.isAuth()) {
        await Provider.of<UserProv>(context, listen: false)
            .fetchAndSetUser(context);
      }

      User? user = Provider.of<UserProv>(context, listen: false).getUser;

      pageView = PageView(
        controller: pageController,
        children: [
          DiscoveryPage(),
          auth.isAuth() == true
              ? CreateWorkout(
                  false,
                  user,
                )
              : LoginScreen(),
          auth.isAuth() == true ? PlanningScreen(user) : LoginScreen(),
          UserScreen(),
        ],
      );

      setState(() {
        isInit = true;
      });
    }
  }

  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 800), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return isInit == false
        ? Container(
            color: _theme.secondaryHeaderColor,
            height: _mediaQuery.size.height,
            width: _mediaQuery.size.width,
            child: Center(
                child: Container(
                    width: _mediaQuery.size.width * 0.5, 
                    height: _mediaQuery.size.width * 0.5,
                    child: Image.asset(
                      'assets/images/teen_fit_logo_white_withpeople.png',
                      fit: BoxFit.contain,
                    ))),
          )
        : Scaffold(
            backgroundColor: _theme.primaryColor,
            body: pageView,
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.search_rounded), label: 'Find'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.table_chart), label: 'Planning'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ],
              elevation: 5,
              currentIndex: _selectedIndex,
              selectedItemColor: _theme.secondaryHeaderColor,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              backgroundColor: _theme.primaryColor,
              selectedLabelStyle: TextStyle(
                color: _theme.cardColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'PTSans',
                letterSpacing: 1,
              ),
              unselectedLabelStyle: TextStyle(
                color: _theme.cardColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'PTSans',
                letterSpacing: 1,
              ),
              onTap: onTap,
              iconSize: _mediaQuery.size.height * 0.05,
            ),
          );
  }
}
