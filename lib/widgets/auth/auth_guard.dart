import 'package:flutter/cupertino.dart';
import 'package:siffrum_sa/screens/auth-screens/login.dart';
import 'package:siffrum_sa/services/auth/auth_service.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _checking = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final service = AuthService.instance;

    await service.init();

    if (!mounted) return;

    setState(() {
      _isLoggedIn = service.isLoggedIn;
      _checking = false;
    });

    if (!_isLoggedIn) {
      _redirectToLogin();
    }
  }

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return widget.child;
  }
}
