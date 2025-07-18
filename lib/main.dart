import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'clients/api_client.dart';
import 'services/auth/auth_service.dart';
import 'services/banner_service.dart';
import 'providers/banner_provider.dart';
import 'screens/auth-screens/login.dart';
import 'screens/dashboard.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedMode = await CupertinoAdaptiveTheme.getThemeMode();

  // 2️⃣ Init Auth & API interceptors
  await AuthService.instance.init();
  ApiClient.initialize();
  final Dio dio = ApiClient.client;

  runApp(
    MultiProvider(
      providers: [
        Provider<Dio>.value(value: dio),
        Provider<BannerService>(create: (_) => BannerService(dio)),
        ChangeNotifierProvider<BannerProvider>(
          create: (ctx) => BannerProvider(ctx.read<BannerService>()),
        ),

        // ── tomorrow add more services/providers here ──
      ],
      child: CupertinoAdaptiveTheme(
        light: lightCupertinoTheme,
        dark: darkCupertinoTheme,
        initial: savedMode ?? AdaptiveThemeMode.light,
        builder: (theme) => CupertinoApp(
          theme: theme,
          home: AuthService.instance.isLoggedIn
              ? SuperAdminDashboard()
              : Login(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
}
