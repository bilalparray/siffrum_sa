import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siffrum_sa/screens/home.dart';
import 'package:siffrum_sa/widgets/auth/auth_guard.dart';
import 'package:siffrum_sa/widgets/scroll_view.dart';
import 'package:siffrum_sa/widgets/dialog.dart';
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
  // vaiable for password hide
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void submit() {
    final userName = _userNameController.text.trim();
    final password = _passwordController.text;

    //remove this dialog when testing done
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        bool isValidForm = userName.isNotEmpty && password.isNotEmpty;
        if (isValidForm) {
          return CupertinoDialog(
            title: "Entered Credentials",
            message: password + userName,
          );
        }
        return CupertinoDialog(title: "Error", message: "Invalid Credentials");
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
                        CupertinoButton.filled(
                          onPressed: submit,
                          child: Text('Submit'),
                        ),

                        CupertinoButton.filled(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const AuthGuard(child: Home()),
                              ),
                            );
                          },
                          child: Text('Home'),
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
