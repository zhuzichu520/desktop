import 'package:fluent_ui/fluent_ui.dart';
import '../widgets/page.dart';
import 'package:auto_updater/auto_updater.dart';
import 'package:package_info_plus/package_info_plus.dart';

class About extends ScrollablePage {
  About({super.key});

  void checkUpdate() async {
    await autoUpdater.checkForUpdates();
  }

  @override
  Widget buildHeader(BuildContext context) {
    return const PageHeader(title: Text('关于'));
  }

  @override
  List<Widget> buildScrollable(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    return [
      Row(
        children: [
          Text('当前版本：',style: FluentTheme.of(context).typography.caption),
          FilledButton(
            child: const Text('检查更新'),
            onPressed: () => checkUpdate(),
          )
        ],
      ),
    ];
  }
}
