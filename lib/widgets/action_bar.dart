import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart' hide Page;

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class ActionBar extends StatefulWidget {
  const ActionBar({Key? key}) : super(key: key);

  @override
  State<ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return SizedBox(
      child: Row(
        children: [
          Expanded(child: MoveWindow()),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: ToggleSwitch(
                content: const Text('夜间模式'),
                checked: FluentTheme.of(context).brightness.isDark,
                onChanged: (v) {
                  if (v) {
                    appTheme.mode = ThemeMode.dark;
                  } else {
                    appTheme.mode = ThemeMode.light;
                  }
                },
              ),
            ),
            const WindowButtons(),
          ])
        ],
      ),
    );
  }
}

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {

  void minimize() {
    setState(() {
      appWindow.minimize();
    });
  }

  void close() {
    setState(() {
      appWindow.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(width: 10.0);
    return Row(
      children: [
        SizedBox(
            child: Tooltip(
          message: "最小化",
          child: IconButton(
              icon: const Icon(FluentIcons.chrome_minimize),
              onPressed: minimize),
        )),
        spacer,
        const MaxButton(),
        spacer,
        SizedBox(
          child: Tooltip(
            message: "关闭",
            child: IconButton(
              icon: const Icon(FluentIcons.chrome_close),
              onPressed: close,
            ),
          ),
        ),
        spacer
      ],
    );
  }
}

class MaxButton extends StatefulWidget {
  const MaxButton({Key? key}) : super(key: key);

  @override
  State<MaxButton> createState() => _MaxButtonState();
}

class _MaxButtonState extends State<MaxButton> {

  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return appWindow.isMaximized
        ? SizedBox(
      child: Tooltip(
        message: "还原",
        child: IconButton(
          icon: const Icon(FluentIcons.chrome_restore),
          onPressed: maximizeOrRestore,
        ),
      ),
    )
        : SizedBox(
      child: Tooltip(
        message: "最大化",
        child: IconButton(
          icon: const Icon(FluentIcons.chrome_full_screen),
          onPressed: maximizeOrRestore,
        ),
      ),
    );
  }
}
