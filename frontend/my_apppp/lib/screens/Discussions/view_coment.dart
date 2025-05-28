// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/screens/profile_page/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/screens/Discussions/first_discussion.dart';

class ViewComent extends StatefulWidget {
  final String userName;
  final String userFaculty;
  final String timeAgo;
  final String postText;
  final int interestedCount;
  final int commentCount;
  final String userImage;
  final int discussionId;
  final int userId;
  final int profileId;

  const ViewComent({
    required this.userName,
    required this.userFaculty,
    required this.timeAgo,
    required this.postText,
    required this.interestedCount,
    required this.commentCount,
    required this.userImage,
    required this.discussionId,
    required this.userId,
    required this.profileId,
    super.key,
  });

  @override
  State<ViewComent> createState() => _ViewComentState();
}

class _ViewComentState extends State<ViewComent> {
  List comments = [];
  bool isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    _getUserId();
    fetchComments();
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id')?.toString();
    });
  }

  Future<void> fetchComments() async {
    final url = Uri.parse('http://127.0.0.1:8000/social/comments/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        comments = jsonData['comments'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> postComment(String description) async {
    final url = Uri.parse('http://127.0.0.1:8000/social/comments/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'description': description,
        'discussion': widget.discussionId,
        'profile': widget.profileId,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      _commentController.clear();
      fetchComments();
    } else {
      debugPrint('Failed to post comment');
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to post comment')));
    }
  }

  Future<void> upvoteComment(int commentId) async {
  final url = Uri.parse(
    'http://127.0.0.1:8000/social/comments/$commentId/',
  );
  final response = await http.put(url);

  if (response.statusCode == 200) {
    fetchComments();
  }
}

Future<void> downvoteComment(int commentId) async {
  final url = Uri.parse(
    'http://127.0.0.1:8000/social/comments/$commentId/',
  );
  final response = await http.put(url);

  if (response.statusCode == 200) {
    fetchComments();
  }
}


  Future<void> deleteComment(int commentId) async {
    final url = Uri.parse('http://127.0.0.1:8000/social/comments/$commentId/');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print('Token used in delete: $token');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment deleted successfully')),
        );
        fetchComments();
      } else {
        print('Response code: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete comment: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting comment: $e')));
    }
  }

  Widget buildCommentCard(Map<String, dynamic> comment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              final profileId = comment['profile']['id'];
              if (profileId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: profileId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile not available.")),
                );
              }
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'http://127.0.0.1:8000${comment['profile']['image']}',
              ),
              radius: 25,
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment['profile']['full_name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  comment['profile']['organization'] ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  comment['created_on'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  comment['description'],
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                            'Are you sure you want to delete this comment?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true) {
                    await deleteComment(comment['id']);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_drop_up, size: 18),
                onPressed: () => upvoteComment(comment['id']),
              ),
              Text('${comment['ups']}'),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                onPressed: () => downvoteComment(comment['id']),
              ),
              Text('${comment['downs']}'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        toolbarHeight: 70,
        flexibleSpace: Container(
          color: Colors.white,
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Social Network',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(height: 15, thickness: 1, color: Colors.black),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            FirstDiscussion(
              userName: widget.userName,
              userFaculty: widget.userFaculty,
              timeAgo: widget.timeAgo,
              postText: widget.postText,
              interestedCount: widget.interestedCount,
              commentCount: widget.commentCount,
              userImage: widget.userImage,
              discussionId: widget.discussionId,
              userId: widget.userId,
            ),
            const SizedBox(height: 10),
            buildCommentInputBox(),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children:
                    comments
                        .map((comment) => buildCommentCard(comment))
                        .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCommentInputBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Leave your opinion...',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, size: 25),
            onPressed: () {
              final commentText = _commentController.text.trim();
              if (commentText.isNotEmpty) {
                postComment(commentText);
              }
            },
          ),
        ],
      ),
    );
  }
}
