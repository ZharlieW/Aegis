import 'package:aegis/common/common_tips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

enum FeedbackType { bug, enhancement }

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  FeedbackType _feedbackType = FeedbackType.bug;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  String get _feedbackTypeLabel {
    switch (_feedbackType) {
      case FeedbackType.bug:
        return 'Bug';
      case FeedbackType.enhancement:
        return 'Enhancement';
    }
  }

  String get _mailSubject {
    final trimmedTitle = _titleController.text.trim();
    if (trimmedTitle.isEmpty) {
      return '[Aegis][$_feedbackTypeLabel]';
    }
    return '[Aegis][$_feedbackTypeLabel] $trimmedTitle';
  }

  String get _mailBody {
    final userBody = _bodyController.text.trim();
    if (userBody.isEmpty) {
      return 'Type: $_feedbackTypeLabel\n\nDetails:\n';
    }
    return 'Type: $_feedbackTypeLabel\n\nDetails:\n$userBody';
  }

  String get _copyText {
    return 'Type: $_feedbackTypeLabel\n'
        'Title: ${_titleController.text.trim()}\n\n'
        '${_bodyController.text.trim()}';
  }

  Future<void> _sendFeedback() async {
    final uri = Uri(
      scheme: 'mailto',
      queryParameters: <String, String>{
        'subject': _mailSubject,
        'body': _mailBody,
      },
    );

    final launched = await launchUrl(uri);
    if (!mounted) return;

    if (launched) {
      CommonTips.success(context, 'Email draft opened.');
      return;
    }

    await _copyToClipboard(showSuccessText: false);
    if (!mounted) return;
    CommonTips.success(
      context,
      'Mail app unavailable. Feedback content copied to clipboard.',
    );
  }

  Future<void> _copyToClipboard({bool showSuccessText = true}) async {
    await Clipboard.setData(ClipboardData(text: _copyText));
    if (!mounted || !showSuccessText) return;
    CommonTips.success(context, 'Feedback content copied.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<FeedbackType>(
                value: _feedbackType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                ),
                items: const [
                  DropdownMenuItem(
                    value: FeedbackType.bug,
                    child: Text('Bug'),
                  ),
                  DropdownMenuItem(
                    value: FeedbackType.enhancement,
                    child: Text('Enhancement'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _feedbackType = value);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Short summary',
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                    hintText: 'Describe what happened and what you expected.',
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _sendFeedback,
                      icon: const Icon(Icons.send),
                      label: const Text('Send'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
