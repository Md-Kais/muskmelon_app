import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../app_theme.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _title = TextEditingController(text: 'সমস্যা জানান');
  final _message = TextEditingController();

  bool _isOffline = false;
  bool _sending = false;
  XFile? _picked;

  @override
  void initState() {
    super.initState();
    // Offline banner state
    Connectivity().onConnectivityChanged.listen((s) {
      if (!mounted) return;
      setState(() => _isOffline = s == ConnectivityResult.none);
    });
    Connectivity().checkConnectivity().then((s) {
      if (!mounted) return;
      setState(() => _isOffline = s == ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    if (img != null) setState(() => _picked = img);
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);

    // Compose body (Bangla first, then English tags if needed)
    final body = '''
শিরোনাম: ${_title.text.trim()}
ইমেইল: ${_email.text.trim()}
ফোন: ${_phone.text.trim()}

বিবরণ:
${_message.text.trim()}

—
(এই ইমেইলটি অ্যাপ থেকে তৈরি করা হয়েছে)
''';

    final attachmentPaths = <String>[];
    if (_picked != null) attachmentPaths.add(_picked!.path);

    final email = Email(
      recipients: const [
        // TODO: put YOUR destination email here
        'you@example.com',
      ],
      subject: _title.text.trim().isEmpty ? 'সমস্যা জানান' : _title.text.trim(),
      body: body,
      isHTML: false,
      attachmentPaths: attachmentPaths,
      // You can also set cc: and bcc: if you want a copy
      // cc: [_email.text.trim()], // not recommended unless you want auto-CC
    );

    try {
      await FlutterEmailSender.send(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primary,
          content: Text(
            _isOffline
                ? 'আপনার বার্তাটি ইমেইল অ্যাপে কিউ হয়েছে—ইন্টারনেট পেলেই পাঠাবে।'
                : 'ইমেইল কম্পোজার খোলা হয়েছে—“Send” চাপুন।',
          ),
        ),
      );
      // keep email/phone for convenience; clear message
      _message.clear();
      setState(() => _picked = null);
    } catch (e) {
      if (!mounted) return;
      // If no email client installed or user cancelled, you’ll land here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ইমেইল পাঠানো সম্ভব হয়নি: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('সমস্যা জানান', style: theme.textTheme.titleMedium),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            if (_isOffline)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDD835).withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDD835).withValues(alpha: .6)),
                ),
                child: const Text('আপনার বার্তাটি সংরক্ষিত হয়েছে, ইন্টারনেট সংযুক্ত হলে পাঠানো হবে।'),
              ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Put your email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'ইমেইল দিন';
                      final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
                      return ok ? null : 'সঠিক ইমেইল দিন';
                    },
                  ),
                  const SizedBox(height: 12),

                  // Phone
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'ফোন নম্বর দিন' : null,
                  ),
                  const SizedBox(height: 12),

                  // Title
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(
                      labelText: 'শিরোনাম',
                      hintText: 'সমস্যা জানান',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'শিরোনাম দিন' : null,
                  ),
                  const SizedBox(height: 12),

                  // Message
                  TextFormField(
                    controller: _message,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'বিবরণ',
                      hintText: 'এখানে লিখুন…',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'বিবরণ লিখুন' : null,
                  ),
                  const SizedBox(height: 12),

                  // Photo row
                  Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('ছবি যোগ করুন'),
                        onPressed: _pickImage,
                      ),
                      const SizedBox(width: 12),
                      if (_picked != null)
                        Expanded(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  File(_picked!.path),
                                  width: 64, height: 64, fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _picked!.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => setState(() => _picked = null),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Send button (opens native email composer)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _sending ? null : _sendEmail,
                      child: _sending
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('পাঠান'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
