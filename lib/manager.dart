import 'package:flutter/material.dart';
import 'package:flutter_email/data_classes.dart';

import 'auth/login.dart';
import 'constants.dart';
import 'views/auto_reply_settings_screen.dart';
import 'views/edit_profile_screen.dart';
import 'views/gmail_email_detail_screen.dart';
import 'views/gmail_inbox_screen.dart';
import 'views/gmail_register_screen.dart';
import 'views/notifications_screen.dart';
import 'views/user_settings_screen.dart';

PageRouteBuilder getRouterManager(
  RouteSettings settings,
  BuildContext context,
) {
  print(settings.name);
  if (settings.name != null) {
    if (settings.name!.startsWith(AuthRoutes.ROOT.value)) {
      return MainManager.redirector(
        context,
        settings.name!,
        arguments: settings.arguments,
      );
    } else if (settings.name!.startsWith(SettingsRoutes.ROOT.value)) {
      return SettingManager.redirector(context, settings.name!);
    } else if (settings.name!.startsWith(AuthRoutes.AUTHROOT.value)) {
      return LoginManager.redirector(context, settings.name!);
    }
  }
  return MainManager.redirector(context, Route404);
}

class Screen404 extends StatelessWidget {
  const Screen404({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: const Center(child: Text('Page not found')),
    );
  }
}

abstract class RouterManager {}

class MainManager extends RouterManager {
  static PageRouteBuilder redirector(
    BuildContext context,
    String path, {
    Object? arguments,
  }) {
    final Map<String, WidgetBuilder> routeMap = {
      AuthRoutes.LOGIN.value: (context) => const GmailLoginScreen(),
      MailRoutes.INBOX.value: (context) => const GmailInboxScreen(),
      MailRoutes.EMAIL_DETAIL.value: (context) => GmailEmailDetailScreen(
            email: arguments as Email,
          ),
      MailRoutes.NOTIF.value: (context) => const NotificationsScreen(),
    };

    WidgetBuilder builder = routeMap[path] ?? (context) => const Screen404();
    return tweenRoute(builder);
  }
}

class SettingManager extends RouterManager {
  static const root = "settings/";

  static PageRouteBuilder redirector(
    BuildContext context,
    String path, {
    Object? arguments,
  }) {
    final Map<String, WidgetBuilder> routeMap = {
      SettingsRoutes.USER.value: (context) => const UserSettingsScreen(),
      SettingsRoutes.AUTOREP.value: (context) => const AutoReplySettingsScreen(),
      SettingsRoutes.EDITPROFILE.value: (context) => const EditProfileScreen(),
    };

    WidgetBuilder builder = routeMap[path] ?? (context) => const Screen404();
    return tweenRoute(builder);
  }
}

class LoginManager extends RouterManager {
  static PageRouteBuilder redirector(
    BuildContext context,
    String path, {
    Object? arguments,
  }) {
    final Map<String, WidgetBuilder> routeMap = {
      AuthRoutes.REGISTER.value: (context) => GmailRegisterScreen(),
    };

    WidgetBuilder builder =
        routeMap[path] ?? (context) => const GmailLoginScreen();
    return tweenRoute(builder);
  }
}

PageRouteBuilder<dynamic> tweenRoute(WidgetBuilder builder) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var slideTween = Tween(begin: begin, end: end).chain(
        CurveTween(
          curve: curve,
        ),
      );
      var slideAnimation = animation.drive(slideTween);

      var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(
          curve: curve,
        ),
      );
      var fadeAnimation = animation.drive(fadeTween);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}
