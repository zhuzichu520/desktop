import 'package:desktop/page/loading.dart';
import 'package:desktop/repository/mail_repository.dart';
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
import 'widgets/action_bar.dart';
import 'page/index.dart';
import 'page/login.dart';

const String appTitle = 'ζηη¨εΊ';

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  await MailRepository.initialize();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppTheme()),
        ChangeNotifierProvider(create: (context) => LoadingNotifier()),
      ],
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
                child: Stack(
                  children: [
                    child!,
                    const LoadingPage()
                  ],
                ),
              ),
            );
          },
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginPage(),
            '/index': (context) => const IndexPage()
          },
        );
      },
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;

  int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');

  final List<NavigationPaneItem> originalItems = [
    PaneItem(
      icon: const Icon(FluentIcons.home),
      title: const Text('ι¦ι‘΅'),
      body: const HomePage(),
    )
  ];

  final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      icon: const Icon(FluentIcons.alert_solid),
      title: const Text('ε³δΊ'),
      body: About(),
    ),
    _LinkPaneItemAction(
      icon: const Icon(FluentIcons.open_source),
      title: const Text('ζΊη '),
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
          actions: const ActionBar()),
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
