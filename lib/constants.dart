// ignore_for_file: camel_case_types

const Route404 = "404";
const placeholderImage = "assets/placeholder.jpg";
const appName = "GotMail";

enum SettingsRoutes {
  ROOT("settings/"),
  USER("settings/userSettings"),
  AUTOREP("settings/autoReply"),
  EDITPROFILE("settings/editProfile"),
  COMPOSEPREF("settings/composePrefs");

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
  NOTIF("/notif"),
  ;

  const MailRoutes(this.value);
  final String value;
}

enum MailSubroutes {
  ROOT("mails/"),
  DRAFT("mails/drafts"),
  SENT("mails/sent"),
  STARRED("mails/starred"),
  SPAM("mails/spam"),
  ALL("mails/allMail");

  const MailSubroutes(this.value);
  final String value;
}

const API_ROOT = "http://127.0.0.1:8000";
const mediaServer = "http://127.0.0.1:8000";

enum API_Endpoints {
  AUTH_REGISTER("$API_ROOT/auth/register/"),
  AUTH_LOGIN("$API_ROOT/auth/login/"),
  AUTH_LOGOUT("$API_ROOT/auth/logout/"),
  AUTH_VALIDATE_TOKEN("$API_ROOT/auth/validate_token/"),
  USER_PROFILE("$API_ROOT/user/profile/"),
  GET_IMAGE(mediaServer),
  USER_AUTO_REPLY("$API_ROOT/user/auto_rep/"),
  USER_DARKMODE("$API_ROOT/user/darkmode/"),
  USER_EMAIL_PREF("$API_ROOT/user/email_pref/"),
  EMAIL_SEND("$API_ROOT/email/send/"),
  EMAIL_LIST("$API_ROOT/email_list"),
  ;

  const API_Endpoints(this.value);
  final String value;
}

String getUserProfileImageURL(String url) {
  final finalUrl = "${API_Endpoints.GET_IMAGE.value}$url";
  return finalUrl;
}

const List<String> fontSizes = ["Small", "Medium", "Large"];
const List<String> fontFamilies = ["Sans-serif", "Serif", "Monospace"];



const Map<String, String> fontFamilySelectMap = {
  "Sans-serif": "sans-serif",
  "Serif": "serif",
  "Monospace": "monospace"
};


var fontFamilyValueMap = fontFamilySelectMap.map((k, v) => MapEntry(v, k));