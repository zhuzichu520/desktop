import 'package:desktop/repository/mail_repository.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import '../widgets/body_view.dart';

const String appTitle = '我的程序';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  List<TreeViewItem> items = [TreeViewItem(content: const Text("文件夹"), value: "文件夹", children: [])];

  @override
  void initState() {
    super.initState();
    print("开始下载");
    loadListMailboxes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadListMailboxes() async {
    var listMailBoxes = await MailRepository.listMailboxes();
    print(listMailBoxes);
    var treeView = _convertToTree(listMailBoxes);
    setState(() {
      items = treeView;
    });
    // print('mailboxes: $listMailBoxes');
  }

  List<TreeViewItem> _convertToTree(List<Mailbox> data){
    var root = TreeViewItem(content: const Text("文件夹"), value: "文件夹",children: []);
    for (var item in data) {
      var node = root;
      var parts = item.path.split("/");
      for (var part in parts) {
        var child = node.children.firstWhere((c) => c.value == part, orElse: () {
          var newChild = TreeViewItem(content: Text(part), value: part,children: []);
          node.children.add(newChild);
          return newChild;
        });
        node = child;
      }
    }
    return [root];
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return BodyView(
      title: appTitle,
      child: Row(
        children: [
          SizedBox(
              width: 250,
              child: SizedBox.expand(
                child: TreeView(
                  items: items,
                ),
              ))
        ],
      ),
    );
  }
}
