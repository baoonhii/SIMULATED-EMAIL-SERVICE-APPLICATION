import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../other_widgets/general.dart';
import '../utils/api_pipeline.dart';
import '../constants.dart';
import 'gmail_base_screen.dart';

class AutoReplySettingsScreen extends StatefulWidget {
  const AutoReplySettingsScreen({super.key});

  @override
  State<AutoReplySettingsScreen> createState() =>
      _AutoReplySettingsScreenState();
}

class _AutoReplySettingsScreenState extends State<AutoReplySettingsScreen> {
  // Controllers and state variables
  final TextEditingController _autoReplyMessageController =
      TextEditingController();

  bool _isLoading = true;
  bool _autoReplyEnabled = false;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchAutoReplySettings();
  }

  Future<void> _fetchAutoReplySettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final responseData = await makeAPIRequest(
        url: Uri.parse(API_Endpoints.USER_AUTO_REPLY.value),
        method: 'GET',
      );

      print(responseData);

      setState(() {
        _autoReplyEnabled = responseData['auto_reply_enabled'] ?? false;
        _autoReplyMessageController.text =
            responseData['auto_reply_message'] ?? '';

        // Parse dates if available
        if (responseData['auto_reply_start_date'] != null) {
          _startDate = DateTime.parse(responseData['auto_reply_start_date']);
        }
        if (responseData['auto_reply_end_date'] != null) {
          _endDate = DateTime.parse(responseData['auto_reply_end_date']);
        }
      });
    } catch (e) {
      if (mounted) {
        showSnackBar(context, AppLocalizations.of(context)!.errorFetchSettings);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAutoReplySettings() async {
    // Validate inputs
    if (_autoReplyEnabled && _autoReplyMessageController.text.isEmpty) {
      if (mounted) {
        showSnackBar(
            context, AppLocalizations.of(context)!.autoReplyMessageRequired);
      }
      return;
    }

    // Prepare request body
    final body = {
      'auto_reply_enabled': _autoReplyEnabled,
      'auto_reply_message': _autoReplyMessageController.text,
      if (_startDate != null)
        'auto_reply_start_date': _startDate!.toIso8601String(),
      if (_endDate != null) 'auto_reply_end_date': _endDate!.toIso8601String(),
    };

    try {
      await makeAPIRequest(
        url: Uri.parse(API_Endpoints.USER_AUTO_REPLY.value),
        method: 'PUT',
        body: body,
      );

      if (mounted) {
        showSnackBar(context, AppLocalizations.of(context)!.saveSettingChanges);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
            context, AppLocalizations.of(context)!.errorSavingSettings);
      }
    }
  }

  // Date picker for start and end dates
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

    // Ensure the initial date is not in the past
    if (initialDate.isBefore(DateTime.now())) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Ensure end date is after start date
          if (_endDate != null && picked.isAfter(_endDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GmailBaseScreen(
      title: AppLocalizations.of(context)!.autoRepSetting,
      addDrawer: false,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Auto Reply Toggle
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.turnOnAutoRep),
            value: _autoReplyEnabled,
            onChanged: (bool value) {
              setState(() {
                _autoReplyEnabled = value;
              });
            },
            secondary: Icon(
              Icons.reply,
              color: _autoReplyEnabled ? Colors.blue : Colors.grey,
            ),
          ),

          // Auto Reply Configuration
          if (_autoReplyEnabled) ...[
            const SizedBox(height: 16),

            // Auto Reply Message
            TextField(
              controller: _autoReplyMessageController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.autoRepMessage,
                hintText: AppLocalizations.of(context)!.autoRepMessageHint,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Date Range Selection
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(_startDate == null
                        ? AppLocalizations.of(context)!.selectStartDate
                        : '${AppLocalizations.of(context)!.startDate}: ${_formatDate(_startDate!)}'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(_endDate == null
                        ? AppLocalizations.of(context)!.selectEndDate
                        : '${AppLocalizations.of(context)!.endDate}: ${_formatDate(_endDate!)}'),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),

          // Save Button
          ElevatedButton(
            onPressed: _saveAutoReplySettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.saveSettingChanges),
          ),
        ],
      ),
    );
  }

  // Utility method to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _autoReplyMessageController.dispose();
    super.dispose();
  }
}
