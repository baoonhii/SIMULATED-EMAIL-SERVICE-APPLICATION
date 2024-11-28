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
              borderSide: const BorderSide(color: Colors.grey),
            ),
            // Customize the filled color
            filled: true,
            fillColor: Colors.white,
            // Customize the content padding
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            // Optional: customize the dropdown icon
            suffixIcon: const Icon(Icons.language, color: Colors.blue),
          ),
          // Customize the dropdown button style
          dropdownColor: Colors.white,
          style: const TextStyle(fontSize: 16, color: Colors.black),
          iconEnabledColor: Colors.blue,
          iconDisabledColor: Colors.grey,
        ),
      ),
    ),
  ];
}
