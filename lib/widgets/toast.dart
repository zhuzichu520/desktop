import 'package:fluent_ui/fluent_ui.dart';

class Toast {
  BuildContext context;

  Toast(this.context);

  static Toast of(BuildContext context) {
    return Toast(context);
  }

  void info(String message) {
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text(''),
        content: Text(message),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: InfoBarSeverity.info,
      );
    });
  }

  void error(String message) {
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text(''),
        content: Text(message),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: InfoBarSeverity.error,
      );
    });
  }

  void warning(String message) {
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text(''),
        content: Text(message),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: InfoBarSeverity.warning,
      );
    });
  }

  void success(String message) {
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text(''),
        content: Text(message),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: InfoBarSeverity.success,
      );
    });
  }
}
