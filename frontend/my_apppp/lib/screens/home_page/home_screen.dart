// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:my_app/screens/Discussions/first_discussion.dart';
import 'package:my_app/screens/Forums/forum_card.dart';
import 'package:my_app/screens/forums_and_discussions/forums_screen.dart';
import 'package:my_app/screens/forums_and_discussions/discussions_screen.dart';
import 'package:my_app/screens/profile_page/profile_screen.dart';
import 'package:my_app/widgets/shared/custom_bottom_navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int userId = 0;
  bool isUserIdLoaded = false;

  final List<Widget> _tabs = [
    _HomeContent(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
  ];
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('user_id');

    if (storedUserId != null && storedUserId != 0) {
      setState(() {
        userId = storedUserId;
        isUserIdLoaded = true;
      });
    } else {
      await fetchUserId();
    }
  }

  Future<void> fetchUserId() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/getUserId/'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('User ID Response: $data');
        setState(() {
          userId = data['user_id'];
          isUserIdLoaded = true;
        });
      } else {
        throw Exception('Failed to load user ID');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _loadUserId();
  }

  void _showNewOptions() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder:
          (_) => Material(
            type: MaterialType.transparency,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 90),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForumScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forum',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 15,
                          thickness: 1,
                          color: Colors.black38,
                          indent: 20,
                          endIndent: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DiscussionsScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Discussion',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _tabs[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) async {
          if (index == 1) {
            _showNewOptions();
          } else if (index == 2) {
            if (isUserIdLoaded && userId != 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(userId: userId),
                ),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('User ID not loaded yet')));
              await fetchUserId();
              if (isUserIdLoaded && userId != 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(userId: userId),
                  ),
                );
              }
            }
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Social Network",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              dashPattern: const [20, 10],
              color: Colors.black38,
              strokeWidth: 1.5,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    "Hello, Ahmed.",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const HomeForumSection(),
            const HomeDiscussionSection(),
          ],
        ),
      ),
    );
  }
}

class HomeForumSection extends StatefulWidget {
  const HomeForumSection({super.key});

  @override
  State<HomeForumSection> createState() => _HomeForumSectionState();
}

class _HomeForumSectionState extends State<HomeForumSection> {
  List<dynamic> forums = [];
  bool isLoading = true;
  bool showMore = false;

  

  @override
  void initState() {
    super.initState();
    fetchForums();
  }
  

  Future<void> fetchForums() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/social/forums/'),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          forums = jsonData['forums'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load forums');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final displayedForums = showMore ? forums : forums.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Forums",
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ...List.generate(displayedForums.length, (index) {
          final forum = displayedForums[index];
          print('Forum data: $forum');
          return ForumCard.fromMap(forum );
        }),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () async {
                
              setState(() {
                showMore = !showMore;
                
              });
             
            },
            child: Text(
              showMore ? "View Less" : "View More",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Divider(
          height: 1,
          thickness: 1.5,
          color: Colors.black38,
          indent: 20,
          endIndent: 20,
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }
}

class HomeDiscussionSection extends StatefulWidget {
  const HomeDiscussionSection({super.key});

  @override
  State<HomeDiscussionSection> createState() => _HomeDiscussionSectionState();
}

class _HomeDiscussionSectionState extends State<HomeDiscussionSection> {
  List<dynamic> discussions = [];
  bool isLoading = true;
  bool showMore = false;

  @override
  void initState() {
    super.initState();
    fetchDiscussions();
  }

  Future<void> fetchDiscussions() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/social/discussions/'),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          discussions = jsonData['discussions'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load discussions');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Discussions",
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...List.generate(discussions.length, (index) {
          final d = discussions[index];
          final profile = d['profile'];
          final description =
              d['description']?.toString() ?? 'No description available';
          final createdOn = d['created_on']?.toString() ?? 'Unknown date';
          final interestedCount = d['interested_count'] ?? 0;
          final commentCount = d['comments_count'] ?? 0;
          final userName =
              profile != null
                  ? (profile['full_name']?.toString() ?? 'Unknown User')
                  : 'Unknown User';
          final userTagline =
              profile != null
                  ? (profile['tagline']?.toString() ?? 'No tagline')
                  : 'No tagline';
          final userImage =
              profile != null ? (profile['image']?.toString() ?? '') : '';
          final discussionId =
              d['id'] is int
                  ? d['id']
                  : int.tryParse(d['id']?.toString() ?? '') ?? 0;
          final userId =
              profile != null
                  ? (profile['id'] is int
                      ? profile['id']
                      : int.tryParse(profile['id']?.toString() ?? '') ?? 0)
                  : 0;

          print('User ID for discussion $index: $userId');

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                print("Opening profile for userId: $userId");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(userId: userId),
                  ),
                );
              },
              child: FirstDiscussion(
                userName: userName,
                userFaculty: userTagline,
                timeAgo: createdOn,
                postText: description,
                interestedCount: interestedCount,
                commentCount: commentCount,
                userImage: userImage,
                discussionId: discussionId,
                userId: userId,
              ),
            ),
          );
        }),
      ],
    );
  }
}
