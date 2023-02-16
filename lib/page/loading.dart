import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadingNotifier = context.watch<LoadingNotifier>();
    return Visibility(
        visible: loadingNotifier._visible,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            const Center(child: ProgressRing())
          ],
        ));
  }
}

class LoadingNotifier extends ChangeNotifier {
  bool _visible = false;

  void showLoading() {
    _visible = true;
    notifyListeners();
  }

  void hideLoading() {
    _visible = false;
    notifyListeners();
  }
}
