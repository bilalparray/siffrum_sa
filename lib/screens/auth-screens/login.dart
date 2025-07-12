import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siffrum_sa/widgets/centered_scroll_view.dart';
import 'package:siffrum_sa/widgets/cupertino_card.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hidePassword = true;
  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void submit() {
    final userName = _userNameController.text;
    final password = _passwordController.text;

    //remove this dialog when testing done
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Entered Credentials"),
          content: Column(
            children: [
              SizedBox(height: 10),
              Text("Username: $userName"),
              SizedBox(height: 5),
              Text("Password: $password"),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );

        //dialog to be romved when testing is done
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
                          obscureText: _hidePassword,
                          suffix: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
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
