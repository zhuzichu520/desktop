import 'package:desktop/page/loading.dart';
import 'package:desktop/repository/mail_repository.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;

import 'package:provider/provider.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import '../widgets/action_bar.dart';
import '../widgets/toast.dart';

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
    final loadingNotifier = context.watch<LoadingNotifier>();
    final nav = Navigator.of(context);
    final toast = Toast(context);

    final TextEditingController emailController =
        TextEditingController(text: "zhuzichu520@outlook.com");
    final TextEditingController passwordController =
        TextEditingController(text: "qaioasd520");

    void accountAdd() async {
      loadingNotifier.showLoading();
      try {
        await MailRepository.login(
            emailController.text, passwordController.text);
      } on Exception catch (e) {
        loadingNotifier.hideLoading();
        toast.error('failed with $e');
        return;
      }
      loadingNotifier.hideLoading();
      nav.pushNamed('/index');
    }

    var spacer = const SizedBox(height: 30);

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
        decoration: const BoxDecoration(color: Colors.white),
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
              spacer,
              SizedBox(
                width: 300,
                child: TextBox(
                  controller: passwordController,
                  placeholder: "密码",
                  obscureText: true,
                ),
              ),
              spacer,
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FilledButton(
                      onPressed: accountAdd,
                      child: const Text('添加'),
                    ),
                    const SizedBox(width: 30),
                    FilledButton(
                      onPressed: () {
                        appWindow.close();
                      },
                      child: const Text('取消'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
