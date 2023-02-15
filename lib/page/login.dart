import 'package:fluent_ui/fluent_ui.dart' hide Page;

import 'package:provider/provider.dart';
import '../theme.dart';
import '../widgets/action_bar.dart';

const String appTitle = '添加账号';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool value = false;

  int index = 0;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');

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

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
      content: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 300,
                child: TextBox(
                  controller: emailController,
                  placeholder: "E-mail地址",
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: TextBox(
                  controller: passwordController,
                  placeholder: "密码",
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FilledButton(
                    onPressed: () {
                      // 添加按钮点击事件
                    },
                    child: const Text('添加'),
                  ),
                  FilledButton(
                    onPressed: () {
                      // 取消按钮点击事件
                    },
                    child: const Text('取消'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}