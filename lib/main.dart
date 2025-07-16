import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:siffrum_sa/clients/api_client.dart';
import 'package:siffrum_sa/screens/auth-screens/login.dart';
import 'package:siffrum_sa/screens/dashboard.dart';
import 'package:siffrum_sa/services/auth/auth_service.dart';
import 'package:siffrum_sa/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedMode = await CupertinoAdaptiveTheme.getThemeMode();

  await AuthService.instance.init();
  ApiClient.initializeInterceptors(AuthService.instance.dioInterceptor);

  runApp(
    CupertinoAdaptiveTheme(
      light: lightCupertinoTheme,
      dark: darkCupertinoTheme,
      initial: savedMode ?? AdaptiveThemeMode.light,
      builder: (theme) => CupertinoApp(
        theme: theme,
        home: AuthService.instance.isLoggedIn ? SuperAdminDashboard() : Login(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
