import 'package:enough_mail/enough_mail.dart';

class MailRepository {
  static final ImapClient _imapClient = ImapClient(isLogEnabled: false);
  static final _smtpClient = SmtpClient('enough.de', isLogEnabled: false);

  static Future<void> initialize() async {}

  static Future<void> login(String username, String password) async {
    String imapServerHost = 'imap-mail.outlook.com';
    int imapServerPort = 993;
    bool isImapServerSecure = true;
    String smtpServerHost = 'smtp-mail.outlook.com';
    int smtpServerPort = 587;
    bool isSmtpServerSecure = false;
    await _imapClient.connectToServer(imapServerHost, imapServerPort,
        isSecure: isImapServerSecure);
    await _imapClient.login(username, password);

    await _smtpClient.connectToServer(smtpServerHost, smtpServerPort,
        isSecure: isSmtpServerSecure);
    await _smtpClient.ehlo();
    if (_smtpClient.serverInfo.supportsAuth(AuthMechanism.plain)) {
      await _smtpClient.authenticate(
          'user.name', 'password', AuthMechanism.plain);
    } else if (_smtpClient.serverInfo.supportsAuth(AuthMechanism.login)) {
      await _smtpClient.authenticate(
          'user.name', 'password', AuthMechanism.login);
    }
  }

  static Future<List<Mailbox>> listMailboxes() async {
    final mailboxes = await _imapClient.listMailboxes();
    return mailboxes;
  }
}
