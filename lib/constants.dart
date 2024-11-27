enum Settings {
  USER("settings/userSettings"),
  NOTIF("settings/notifications"),
  AUTOREF("settings/autoReply");

  const Settings(this.value);
  final String value;
}

const placeholderImage = 'assets/placeholder.jpg';