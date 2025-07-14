import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siffrum_sa/constants/environment.dart';
import 'package:siffrum_sa/models/role.dart';
import 'package:siffrum_sa/screens/home.dart';
import 'package:siffrum_sa/services/auth/auth_service.dart';
import 'package:siffrum_sa/widgets/auth/auth_guard.dart';
import 'package:siffrum_sa/widgets/scroll_view.dart';
import 'package:siffrum_sa/widgets/card.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // variable for text field
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<Role> _roles = [
    Role('superAdmin', 'Super Admin'),
    Role('admin', 'Admin'),
    Role('editor', 'Editor'),
    Role('user', 'User'),
    Role('guest', 'Guest'),
  ];
  // vaiable for password hide
  bool _isPasswordHidden = true;
  String _selectedValue = 'superAdmin';
  String get _selectedLabel =>
      _roles.firstWhere((r) => r.value == _selectedValue).label;
  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void submit() async {
    final userName = _userNameController.text.trim();
    final password = _passwordController.text;
    if (userName.isNotEmpty && password.isNotEmpty) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const CupertinoAlertDialog(
          content: SizedBox(
            height: 50,
            child: Center(child: CupertinoActivityIndicator()),
          ),
        ),
      );

      try {
        await AuthService.instance.login(
          username: userName,
          password: password,
          role: _selectedValue,
        );

        if (mounted) {
          Navigator.of(context).pop(); // Close the loader
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => const AuthGuard(child: Home())),
            (route) => false,
          );
        }
      } catch (error) {
        if (mounted) {
          Navigator.of(context).pop(); // Close the loader
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: const Text('Error'),
              content: Text(Environment.errorMessages['user_not_found']!),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  void _showRolePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            // Done button
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Done'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Picker wheel
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32,
                backgroundColor: CupertinoColors.systemBackground.resolveFrom(
                  context,
                ),
                scrollController: FixedExtentScrollController(
                  initialItem: _roles.indexWhere(
                    (r) => r.value == _selectedValue,
                  ),
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedValue = _roles[index].value;
                  });
                },
                children: _roles
                    .map((r) => Center(child: Text(r.label)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Login")),
      child: SafeArea(
        child: CenteredScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome to Siffrum Login Page"),
              Padding(
                padding: EdgeInsets.all(20),
                child: CupertinoCard(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CupertinoTextField(
                          controller: _userNameController,
                          placeholder: "Enter Your Username",
                          placeholderStyle: TextStyle(
                            color: CupertinoColors.systemGrey,
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        const SizedBox(height: 20),
                        CupertinoTextField(
                          controller: _passwordController,
                          placeholder: "Enter Your Password",
                          placeholderStyle: TextStyle(
                            color: CupertinoColors.systemGrey,
                          ),
                          padding: EdgeInsets.all(10),
                          obscureText: !_isPasswordHidden,
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPasswordHidden = !_isPasswordHidden;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                _isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: _showRolePicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Role', style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    Text(
                                      _selectedLabel,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(CupertinoIcons.chevron_down, size: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CupertinoButton.filled(
                          onPressed: submit,
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
