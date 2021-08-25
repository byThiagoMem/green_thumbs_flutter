import 'package:flutter/material.dart';
import 'package:flutter_awesome_notifications_tutorial/pages/home_page.dart';

import 'notifications/initialize.dart';

void main() async {
  await InitializeNotifications.initialize;
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.tealAccent,
      ),
      title: 'Green Thumbs',
      home: HomePage(),
    );
  }
}
