import 'package:flutter/cupertino.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AdaptiveThemeMode? _tempSelection;

  @override
  Widget build(BuildContext context) {
    final themeMgr = CupertinoAdaptiveTheme.of(context);
    final currentMode = themeMgr.mode;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Appearance Settings'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // A tappable row with arrow
            CupertinoFormSection(
              header: const Text('Theme'),
              children: [
                CupertinoFormRow(
                  prefix: const Text('Use Theme'),
                  helper: Text(_modeLabel(currentMode)),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _tempSelection = currentMode;
                      _showThemeDialog(context, themeMgr);
                    },
                    child: const Icon(CupertinoIcons.right_chevron),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _modeLabel(AdaptiveThemeMode mode) {
    switch (mode) {
      case AdaptiveThemeMode.light:
        return 'Light';
      case AdaptiveThemeMode.dark:
        return 'Dark';
      case AdaptiveThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(
    BuildContext context,
    AdaptiveThemeManager<CupertinoThemeData> themeMgr,
  ) {
    // Initialize the temp selection to the current mode:
    _tempSelection = themeMgr.mode;

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return CupertinoAlertDialog(
              title: const Text('Select Theme'),
              content: Column(
                // Shrink to fit
                mainAxisSize: MainAxisSize.min,
                children: AdaptiveThemeMode.values.map((mode) {
                  final label = _modeLabel(mode);
                  final selected = _tempSelection == mode;
                  return CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      // Update only the dialog’s state
                      setDialogState(() {
                        _tempSelection = mode;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(label),
                        if (selected)
                          const Icon(CupertinoIcons.check_mark)
                        else
                          const SizedBox(width: 24),
                      ],
                    ),
                  );
                }).toList(),
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('OK'),
                  onPressed: () {
                    // Apply & persist the choice
                    switch (_tempSelection!) {
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
                    Navigator.of(context).pop();
                    setState(() {}); // rebuild the SettingsPage row
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
