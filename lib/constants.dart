const Route404 = "404";

enum SettingsRoutes {
  ROOT("settings/"),
  USER("settings/userSettings"),
  AUTOREP("settings/autoReply"),
  EDITPROFILE("settings/editProfile");

  const SettingsRoutes(this.value);
  final String value;
}

enum AuthRoutes {
  ROOT("/"),
  LOGIN("/"),
  AUTHROOT("auth/"),
  REGISTER("auth/register");

  const AuthRoutes(this.value);
  final String value;
}

enum MailRoutes {
  INBOX("/inbox"),
  EMAIL_DETAIL("/emailDetail"),
  COMPOSE("/compose"),
  NOTIF("/notif");

  const MailRoutes(this.value);
  final String value;
}

enum MailSubroutes {
  DRAFT("mails/drafts"),
  SENT("mails/sent"),
  STARRED("mails/starred"),
  SPAM("mails/spam"),
  ALL("mails/allMail");

  const MailSubroutes(this.value);
  final String value;
}

const placeholderImage = 'assets/placeholder.jpg';
const appName = "GotMail";
