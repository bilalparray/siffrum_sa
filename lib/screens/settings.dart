import 'package:flutter/cupertino.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // <-- Use the Cupertino lookup!
    final themeMgr = CupertinoAdaptiveTheme.maybeOf(context);
    if (themeMgr == null) {
      // If this ever fires, your runApp wrapper is wrong.
      // For now, we just log and show an empty scaffold.
      debugPrint('⚠️ CupertinoAdaptiveTheme not found!');
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Appearance Settings'),
        ),
        child: const Center(child: Text('Theme not available')),
      );
    }

    // Now we can safely read/write the mode:
    final currentMode = themeMgr.mode;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Appearance Settings'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            CupertinoFormSection(
              header: const Text('Theme Mode'),
              children: [
                CupertinoFormRow(
                  prefix: const Text('Use Theme'),
                  child: CupertinoSegmentedControl<AdaptiveThemeMode>(
                    groupValue: currentMode,
                    children: const {
                      AdaptiveThemeMode.light: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Light'),
                      ),
                      AdaptiveThemeMode.dark: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Dark'),
                      ),
                      AdaptiveThemeMode.system: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('System'),
                      ),
                    },
                    onValueChanged: (mode) {
                      // change the theme and rebuild:
                      switch (mode) {
                        case AdaptiveThemeMode.light:
                          themeMgr.setLight();
                          break;
                        case AdaptiveThemeMode.dark:
                          themeMgr.setDark();
                          break;
                        case AdaptiveThemeMode.system:
                          themeMgr.setSystem();
                          break;
                      }
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
