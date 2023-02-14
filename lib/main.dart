import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/link.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'package:auto_updater/auto_updater.dart';

import 'screens/home.dart';
import 'screens/about.dart';
import 'theme.dart';

const String appTitle = '我的程序';

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String feedURL = 'http://localhost:5000/appcast.xml';
  await autoUpdater.setFeedURL(feedURL);
  // await autoUpdater.checkForUpdates();
  await autoUpdater.setScheduledCheckInterval(3600);

  if (!kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.android,
      ].contains(defaultTargetPlatform)) {
    SystemTheme.accentColor.load();
  }
  setPathUrlStrategy();
  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
  }
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = const Size(755, 545);
    win.size = const Size(350, 600);
    win.alignment = Alignment.center;
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          color: appTheme.color,
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            fontFamily: "Source Han Sans CN",
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          theme: FluentThemeData(
            fontFamily: "Source Han Sans CN",
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
          initialRoute: '/',
          routes: {'/': (context) => const MyHomePage()},
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;

  int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');

  final List<NavigationPaneItem> originalItems = [
    PaneItem(
      icon: const Icon(FluentIcons.home),
      title: const Text('首页'),
      body: const HomePage(),
    )
  ];

  final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      icon: const Icon(FluentIcons.alert_solid),
      title: const Text('关于'),
      body: About(),
    ),
    _LinkPaneItemAction(
      icon: const Icon(FluentIcons.open_source),
      title: const Text('源码'),
      link: 'https://github.com/zhuzichu520/desktop',
      body: const SizedBox.shrink(),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          height: 50,
          title: () {
            return const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            );
          }(),
          actions: SizedBox(
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
          )),
      pane: NavigationPane(
          selected: index,
          onChanged: (i) {
            setState(() => index = i);
          },
          header: SizedBox(
            height: kOneLineTileHeight,
            child: ShaderMask(
              shaderCallback: (rect) {
                final color = appTheme.color.defaultBrushFor(
                  theme.brightness,
                );
                return LinearGradient(
                  colors: [
                    color,
                    color,
                  ],
                ).createShader(rect);
              },
              child: const FlutterLogo(
                style: FlutterLogoStyle.horizontal,
                size: 80.0,
                textColor: Colors.white,
                duration: Duration.zero,
              ),
            ),
          ),
          displayMode: appTheme.displayMode,
          indicator: () {
            switch (appTheme.indicator) {
              case NavigationIndicators.end:
                return const EndNavigationIndicator();
              case NavigationIndicators.sticky:
              default:
                return const StickyNavigationIndicator();
            }
          }(),
          items: originalItems,
          footerItems: footerItems),
    );
  }
}

class _LinkPaneItemAction extends PaneItem {
  _LinkPaneItemAction({
    required super.icon,
    required this.link,
    required super.body,
    super.title,
  });

  final String link;

  @override
  Widget build(
    BuildContext context,
    bool selected,
    VoidCallback? onPressed, {
    PaneDisplayMode? displayMode,
    bool showTextOnTop = true,
    bool? autofocus,
    int? itemIndex,
  }) {
    return Link(
      uri: Uri.parse(link),
      builder: (context, followLink) => super.build(
        context,
        selected,
        followLink,
        displayMode: displayMode,
        showTextOnTop: showTextOnTop,
        itemIndex: itemIndex,
        autofocus: autofocus,
      ),
    );
  }
}

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  WindowButtonsState createState() => WindowButtonsState();
}

class WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

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
        appWindow.isMaximized
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
              ),
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
