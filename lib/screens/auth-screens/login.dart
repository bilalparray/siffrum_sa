import 'package:flutter/cupertino.dart';
import 'package:siffrum_sa/models/role.dart';
import 'package:siffrum_sa/screens/dashboard.dart';
import 'package:siffrum_sa/services/auth/auth_service.dart';
import 'package:siffrum_sa/utils/dialog_utils.dart';
import 'package:siffrum_sa/utils/picker_utils.dart';
import 'package:siffrum_sa/widgets/auth/auth_guard.dart';
import 'package:siffrum_sa/widgets/scroll_view.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<Role> _roles = [
    Role('superAdmin', 'Super Admin'),
    Role('vendor', 'Vendor'),
    Role('endUser', 'End User'),
    Role('cultureContributor', 'Culture Contributor'),
  ];

  bool _isPasswordHidden = true;
  String _selectedValue = 'superAdmin';
  String get _selectedLabel =>
      _roles.firstWhere((r) => r.value == _selectedValue).label;

  // Added controller for role text field
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _roleController = TextEditingController(text: _selectedLabel);
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void submit() async {
    final userName = _userNameController.text.trim();
    final password = _passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      showErrorDialog(context, "Please fill all fields");
      return;
    }

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
          CupertinoPageRoute(
            builder: (_) => AuthGuard(child: SuperAdminDashboard()),
          ),
          (route) => false,
        );
      }
    } catch (error) {
      if (mounted) {
        hideLoadingIndicator(context);
        showErrorDialog(context, error.toString());
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
          _roleController.text = _selectedLabel;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Login"),
        backgroundColor: CupertinoColors.systemBackground,
      ),
      child: SafeArea(
        child: CenteredScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const Text(
                  "Welcome to Siffrum",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.label,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign in to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                const SizedBox(height: 32),
                // Username Field
                CupertinoTextField(
                  controller: _userNameController,
                  placeholder: "Username",
                  padding: const EdgeInsets.all(16),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(CupertinoIcons.person, size: 20),
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.tertiarySystemBackground,
                    border: Border.all(
                      color: CupertinoColors.systemGrey4,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                CupertinoTextField(
                  controller: _passwordController,
                  placeholder: "Password",
                  padding: const EdgeInsets.all(16),
                  obscureText: _isPasswordHidden,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(CupertinoIcons.lock, size: 20),
                  ),
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      child: Icon(
                        _isPasswordHidden
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                        size: 20,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.tertiarySystemBackground,
                    border: Border.all(
                      color: CupertinoColors.systemGrey4,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                // Role Picker
                GestureDetector(
                  onTap: _showRolePicker,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiarySystemBackground,
                      border: Border.all(
                        color: CupertinoColors.systemGrey4,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.group_solid, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CupertinoTextField(
                              controller: _roleController,
                              readOnly: true,
                              placeholder: "Select Role",
                              style: const TextStyle(
                                color: CupertinoColors.label,
                              ),
                              decoration: const BoxDecoration(border: null),
                              suffix: const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  CupertinoIcons.chevron_down,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(10),
                    onPressed: submit,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
