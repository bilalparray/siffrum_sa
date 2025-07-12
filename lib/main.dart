import 'package:flutter/cupertino.dart';
import 'package:siffrum_sa/clients/api_client.dart';
import 'package:siffrum_sa/screens/auth-screens/login.dart';
import 'package:siffrum_sa/screens/home.dart';
import 'package:siffrum_sa/services/auth/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  ApiClient.initializeInterceptors(AuthService.instance.dioInterceptor);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: AuthService.instance.isLoggedIn ? Home() : Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
