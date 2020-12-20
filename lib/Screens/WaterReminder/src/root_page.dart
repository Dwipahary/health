import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthcare/Screens/WaterReminder/src/global_blocs/app_bloc.dart';
import 'package:healthcare/Screens/WaterReminder/src/global_blocs/auth/auth.dart';
import 'package:healthcare/Screens/WaterReminder/src/home/home_page_setup.dart';


/// This RootPage will display the home page

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final auth = Provider.of<Auth>(context);
    final notificationBloc = Provider.of<AppBloc>(context).notificationBloc;
    return StreamBuilder<FirebaseUser>(
    //  stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePageSetup();
        }
        notificationBloc.cancelNotifications();
    //    auth.signInAnonymously();
        return HomePageSetup();
      },
    );
  }
}
