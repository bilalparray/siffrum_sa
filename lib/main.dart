import 'package:flutter/cupertino.dart';
import 'package:siffrum_sa/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(home: Home(), debugShowCheckedModeBanner: false);
  }
}
