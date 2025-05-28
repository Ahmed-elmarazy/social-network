// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DiscussionsScreen extends StatefulWidget {
  const DiscussionsScreen({super.key});

  @override
  State<DiscussionsScreen> createState() => _DiscussionsScreenState();
}

class _DiscussionsScreenState extends State<DiscussionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _discussionController = TextEditingController();
  final _contentController = TextEditingController();

  String? profileId;
  bool isPosting = false;

  @override
  void initState() {
    super.initState();
    _loadProfileId();
  }

  Future<void> _loadProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileId = prefs.getInt('profile_id')?.toString();
    });
  }

  @override
  void dispose() {
    _discussionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _postDiscussion() async {
  if (_formKey.currentState!.validate()) {
    final prefs = await SharedPreferences.getInstance();
    final storedProfileId = prefs.getInt('profile_id');

    if (storedProfileId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile ID not found. Please login again.')),
      );
      return;
    }

    setState(() {
      isPosting = true;
    });

    final url = Uri.parse('http://127.0.0.1:8000/social/discussions/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': _discussionController.text.trim(),
        'description': _contentController.text.trim(),
        'profile': storedProfileId,
      }),
    );

    setState(() {
      isPosting = false;
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final newDiscussion = decoded['new discussion'] as Map<String, dynamic>?;

      if (newDiscussion != null) {
        print('New Discussion Data from API: $newDiscussion');

        _discussionController.clear();
        _contentController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Discussion posted successfully!')),
        );

        Navigator.pop(context, newDiscussion);
      } else {
        print('Failed to get "new discussion" from response.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to parse discussion data')),
        );
      }
    } else {
      debugPrint('Failed to post discussion: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post discussion: ${response.body}')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Social Network',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 1.5,
                  color: Colors.black45,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const SizedBox(height: 8),
                const Text(
                  'New Discussion',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _discussionController,
                decoration: const InputDecoration(
                  labelText: 'Discussion Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discussion title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discussion content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Center(
                  child: ElevatedButton(
                    onPressed: isPosting ? null : _postDiscussion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isPosting
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
