import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siffrum_sa/models/role.dart';
import 'package:siffrum_sa/screens/home.dart';
import 'package:siffrum_sa/services/auth/auth_service.dart';
import 'package:siffrum_sa/utils/dialog_utils.dart';
import 'package:siffrum_sa/utils/picker_utils.dart';
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
    Role('vendor', 'Vendor'),
    Role('endUser', 'End User'),
    Role('cultureContributor', 'Culture Contributor'),
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
      showLoadingIndicator(context);
      try {
        await AuthService.instance.login(
          username: userName,
          password: password,
          role: _selectedValue,
        );

        if (mounted) {
          hideLoadingIndicator(context);
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => const AuthGuard(child: Home())),
            (route) => false,
          );
        }
      } catch (error) {
        if (mounted) {
          Navigator.of(context).pop(); // Close the loader
          showErrorDialog(context, error.toString());
        }
      }
    }
  }

  void _showRolePicker() {
    showRolePicker(
      context: context,
      roles: _roles,
      selectedValue: _selectedValue,
      onSelected: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
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
                                const Text(
                                  'Role',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _selectedLabel,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      CupertinoIcons.chevron_down,
                                      size: 20,
                                    ),
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
