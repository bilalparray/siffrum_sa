import 'package:flutter/cupertino.dart';
import 'package:siffrum_sa/screens/auth-screens/login.dart';
import 'package:siffrum_sa/widgets/scroll_view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Home")),
      child: CenteredScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome to Siffrum Home Page"),
            CupertinoButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
