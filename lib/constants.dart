// ignore_for_file: camel_case_types

const Route404 = "404";
const placeholderImage = 'assets/placeholder.jpg';
const appName = "GotMail";

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

enum API_Endpoints {
  AUTH_REGISTER('http://127.0.0.1:8000/auth/register/'),
  AUTH_LOGIN('http://127.0.0.1:8000/auth/login/'),
  AUTH_LOGOUT('http://127.0.0.1:8000/auth/logout/'),
  AUTH_VALIDATE_TOKEN('http://127.0.0.1:8000/auth/validate_token/'),
  USER_PROFILE('http://127.0.0.1:8000/user/profile/'),
  GET_IMAGE("http://127.0.0.1:8000"),
  ;

  const API_Endpoints(this.value);
  final String value;
}

String getUserProfileImageURL(String url) {
  final finalUrl = "${API_Endpoints.GET_IMAGE.value}$url";
  return finalUrl;
}
