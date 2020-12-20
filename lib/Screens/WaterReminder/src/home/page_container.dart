import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare/Screens/WaterReminder/models/user.dart';
import 'package:healthcare/Screens/WaterReminder/src/global_blocs/auth/auth.dart';
import 'package:healthcare/Screens/WaterReminder/src/home/pages/cups.dart';
import 'package:healthcare/Screens/WaterReminder/src/global_blocs/theme_changer.dart';
import 'package:healthcare/Screens/WaterReminder/src/global_blocs/app_bloc.dart';
import 'package:healthcare/Screens/WaterReminder/src/home/pages/drink_page.dart';
import 'package:healthcare/Screens/WaterReminder/src/home/pages/notifcation_page.dart';
import 'package:healthcare/Screens/WaterReminder/src/widgets/widgets/bottom_app_bar.dart';
import 'package:healthcare/Screens/WaterReminder/src/enums/enums.dart';


class PageContainer extends StatefulWidget {
  const PageContainer({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  int _currentIndex = 0;
  final List<Widget> _children = [

    DrinkPage(),
    NotificationPage(),

  ];
  Auth auth;
  bool isAnonymous = false;

  @override
  void initState() {
    super.initState();
    delayedInit();
  }

  @override
  void didUpdateWidget(PageContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.maxWaterPerDay != widget.user.maxWaterPerDay) {
      delayedInit();
    }
  }

  Future<void> delayedInit() async {
    if (widget.user.maxWaterPerDay == 1) {
      // Replace screen with onboarding page
      // await Future.delayed(Duration.zero, () {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //       builder: (context) => OnboardingPage(),
      //     ),
      //   );
      // });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    auth = Provider.of<Auth>(context);
    final firebaseUser = await auth.currentUser();
    setState(() {
      isAnonymous = firebaseUser.isAnonymous;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    final drinkBloc = Provider.of<AppBloc>(context).drinkBloc;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Water Reminder',
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) => onMenuSelection(value, auth),
            itemBuilder: (context) {
              return [
                const PopupMenuItem<PopupMenuChoices>(
                  value: PopupMenuChoices.Cups,
                  child: Text('Cups'),
                ),
              ];
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: FABBottomAppBar(
        color: Colors.grey,
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).accentColor,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.alarm, text: 'Alarm'),

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          drinkBloc.drinkWater();
        },
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }

  void onMenuSelection(PopupMenuChoices value, Auth auth) async {
    final themeChanger = Provider.of<ThemeChanger>(context);
    switch (value) {
      case PopupMenuChoices.Cups:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CupsPage()),
        );
        final firebaseUser = await auth.currentUser();
        setState(() {
          isAnonymous = firebaseUser.isAnonymous;
        });
        break;
      default:
    }
  }
}
