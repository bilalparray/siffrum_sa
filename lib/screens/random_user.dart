import 'package:flutter/cupertino.dart';
import '../models/random_user.dart';
import '../services/random_user_service.dart';

class RandomUserPage extends StatefulWidget {
  const RandomUserPage({super.key});
  @override
  State<RandomUserPage> createState() => _RandomUserPageState();
}

class _RandomUserPageState extends State<RandomUserPage> {
  RandomUser? _user;
  String? _errorMsg;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    final resp = await RandomUserService().fetchRandomUser();

    if (!resp.isError && resp.successData != null) {
      setState(() {
        _user = resp.successData;
        _loading = false;
      });
    } else {
      final err = resp.errorData!;
      setState(() {
        _errorMsg = err.userMessage;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Random User")),
      child: SafeArea(
        child: Center(
          child: _loading
              ? const CupertinoActivityIndicator()
              : _errorMsg != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMsg!,
                      style: const TextStyle(color: CupertinoColors.systemRed),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: _loadUser,
                      child: const Text("Retry"),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(_user!.thumbnailUrl),
                    const SizedBox(height: 12),
                    Text(
                      '${_user!.firstName} ${_user!.lastName}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(_user!.email),
                    const SizedBox(height: 16),
                    CupertinoButton.filled(
                      onPressed: _loadUser,
                      child: const Text("Load Another"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
