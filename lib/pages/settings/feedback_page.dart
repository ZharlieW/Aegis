import 'package:aegis/common/common_tips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  bool get _canCopy {
    return _titleController.text.trim().isNotEmpty &&
        _bodyController.text.trim().isNotEmpty;
  }

  void _onTextChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTextChanged);
    _bodyController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _bodyController.removeListener(_onTextChanged);
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

  String get _copyText {
    return 'Type: $_feedbackTypeLabel\n'
        'Title: ${_titleController.text.trim()}\n\n'
        '${_bodyController.text.trim()}';
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _copyText));
    if (!mounted) return;
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: const Key('feedback_copy_button'),
                  onPressed: _canCopy ? _copyToClipboard : null,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
