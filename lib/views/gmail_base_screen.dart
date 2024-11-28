import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../other_widgets/locale_switcher.dart';
import 'gmail_drawer.dart';
import '../state_management/locale_provider.dart';

class GmailBaseScreen extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? appBarWidget;
  final FloatingActionButton? floatingActionButton;

  const GmailBaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.appBarWidget,
    this.floatingActionButton,
  });

  @override
  State<GmailBaseScreen> createState() => _GmailBaseScreenState();
}

class _GmailBaseScreenState extends State<GmailBaseScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // Get the current locale from LocaleProvider
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale ??
        Localizations.localeOf(
          context,
        );

    return Scaffold(
      appBar: AppBar(
        title: widget.appBarWidget ?? Text(widget.title),
        actions: getLanguageChangeDropdown(
          currentLocale,
          context,
          localeProvider,
          _focusNode,
        ),
      ),
      drawer: const GmailDrawer(),
      body: GestureDetector(
        onTap: () {
          // Unfocus the dropdown when the body is tapped
          _focusNode.unfocus();
        },
        child: widget.body,
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  @override
  void dispose() {
    // Dispose the FocusNode when the widget is disposed
    _focusNode.dispose();
    super.dispose();
  }
}
