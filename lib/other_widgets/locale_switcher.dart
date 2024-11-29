import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../state_management/locale_provider.dart';

// Define constants for locales
const Locale localeEN = Locale('en');
const Locale localeVI = Locale('vi');
const TextStyle dropdownTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

List<Widget> getLanguageChangeDropdown(
  Locale currentLocale,
  BuildContext context,
  LocaleProvider localeProvider,
  FocusNode focusNode,
) {
  final theme = Theme.of(context);
  final dropdownTextStyle = getDropdownTextStyle(context);

  return [
    SizedBox(
      width: 200,
      child: Focus(
        focusNode: focusNode,
        child: DropdownButtonFormField<Locale>(
          value: currentLocale,
          items: [
            DropdownMenuItem<Locale>(
              value: localeEN,
              child: Text(
                AppLocalizations.of(context)!.language_EN,
                style: dropdownTextStyle,
              ),
            ),
            DropdownMenuItem<Locale>(
              value: localeVI,
              child: Text(
                AppLocalizations.of(context)!.language_VI,
                style: dropdownTextStyle,
              ),
            ),
          ],
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              // Use the LocaleProvider to change the locale
              localeProvider.setLocale(newLocale);
            }
          },
          decoration: InputDecoration(
            // Customize the border
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            // Customize the filled color
            filled: true,
            fillColor: theme.brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[200],
            // Customize the content padding
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            // Optional: customize the dropdown icon
            suffixIcon: Icon(
              Icons.language,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          style: dropdownTextStyle,
          dropdownColor: theme.brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.white,
        ),
      ),
    ),
  ];
}

TextStyle getDropdownTextStyle(BuildContext context) {
  final theme = Theme.of(context);
  return TextStyle(
    fontSize: 16,
    color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
  );
}
