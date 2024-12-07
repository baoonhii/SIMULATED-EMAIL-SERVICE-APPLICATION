import 'package:flutter/material.dart';
import 'views/gmail_login_screen.dart';
import 'views/gmail_register_screen.dart';
import 'views/gmail_basic_info_screen.dart';
import 'views/gmail_create_username_screen.dart';
import 'views/gmail_inbox_screen.dart';
import 'views/gmail_compose_email_screen.dart';
import 'views/gmail_email_detail_screen.dart';
import 'views/placeholder_screen.dart';
import 'views/gmail_password_screen.dart';
import 'views/gmail_choose_signin_method_screen.dart';
import 'views/gmail_welcome_screen.dart';
import 'views/edit_profile_screen.dart';
import 'views/gmail_drafts_screen.dart';
import 'views/user_settings_screen.dart';
import 'views/notifications_screen.dart';
import 'views/auto_reply_settings_screen.dart';
import 'views/gmail_sent_mail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gmail Clone',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Color(0xFF121212),
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFF202124),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Color(0xFFBB86FC),
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
              ),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: Color(0xFFFFFFFF),
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFFF5F5F5),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Color(0xFF6200EA),
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.black),
              ),
            ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (context) => GmailLoginScreen();
            break;
          case '/password':
            final email = settings.arguments as String;
            builder = (context) => GmailPasswordScreen(email: email);
            break;
          case '/choose-signin-method':
            final email = settings.arguments as String;
            builder = (context) => GmailChooseSignInMethodScreen(email: email);
            break;
          case '/welcome':
            final email = settings.arguments as String;
            builder = (context) => GmailWelcomeScreen(email: email);
            break;
          case '/register':
            builder = (context) => GmailRegisterScreen();
            break;
          case '/basic-info':
            builder = (context) => GmailBasicInfoScreen();
            break;
          case '/create-username':
            builder = (context) => GmailCreateUsernameScreen();
            break;
          case '/editProfile':
            builder = (context) => EditProfileScreen();
            break;
          case '/userSettings':
            builder =
                (context) => UserSettingsScreen(onThemeToggle: _toggleTheme);
            break;
          case '/notificationSettings':
            builder = (context) => NotificationsScreen();
            break;
          case '/autoReplySettings':
            builder = (context) => AutoReplySettingsScreen();
            break;
          case '/inbox':
            builder = (context) => GmailInboxScreen();
            break;
          case '/sent':
            builder = (context) => GmailSentMailScreen();
            break;
          case '/spam':
            builder = (context) => PlaceholderScreen(title: 'Spam');
            break;
          case '/allMail':
            builder = (context) => PlaceholderScreen(title: 'All Mail');
            break;
          case '/social':
            builder = (context) => PlaceholderScreen(title: 'Social');
            break;
          case '/promotions':
            builder = (context) => PlaceholderScreen(title: 'Promotions');
            break;
          case '/updates':
            builder = (context) => PlaceholderScreen(title: 'Updates');
            break;
          case '/compose':
            builder = (context) => GmailComposeEmailScreen();
            break;
          case '/emailDetail':
            builder = (context) => GmailEmailDetailScreen();
            break;
          case '/drafts':
            builder = (context) => GmailDraftsScreen();
            break;
          case '/settings':
            builder =
                (context) => UserSettingsScreen(onThemeToggle: _toggleTheme);
            break;
          default:
            builder = (context) =>
                Scaffold(body: Center(child: Text('Page not found')));
        }
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    );
  }
}
