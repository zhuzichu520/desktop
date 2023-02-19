import 'package:fluent_ui/fluent_ui.dart' hide Page;

import 'action_bar.dart';

class BodyView extends StatefulWidget {
  const BodyView({Key? key, this.title = "", this.child}) : super(key: key);

  final String title;
  final Widget? child;

  @override
  State<BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<BodyView> {
  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return NavigationView(
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          height: 50,
          backgroundColor:
              theme.brightness.isDark ? Colors.black : Colors.white,
          title: () {
            return Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(widget.title),
            );
          }(),
          actions: const ActionBar()),
      content: Container(
        decoration:
            BoxDecoration(color: theme.navigationPaneTheme.backgroundColor),
        child: widget.child,
      ),
    );
  }
}
