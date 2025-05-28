// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:my_app/screens/Discussions/first_discussion.dart';
import 'package:my_app/screens/Forums/forum_card.dart';
import 'package:my_app/screens/forums_and_discussions/discussions_screen.dart';
import 'package:my_app/screens/forums_and_discussions/forums_screen.dart';
import 'package:my_app/screens/profile_page/edit_profile_screen.dart';
import 'package:my_app/screens/profile_page/interest_screen.dart';
import 'package:my_app/widgets/shared/custom_bottom_navbar.dart';
import 'package:my_app/screens/home_page/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final int? userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _profileFuture;
  int _currentNavIndex = 2;
  int _activeIndex = 0;

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
  void initState() {
    super.initState();
    _profileFuture = fetchProfile();
  }

Future<Map<String, dynamic>> fetchProfile() async {
  int? userId = widget.userId;
  print('Fetching profile for userId: $userId');

  if (userId == null || userId == 0) {
    print('Invalid userId: $userId');
    throw Exception('Invalid userId, cannot fetch profile');
  }

  // 👇 هنا بنجيب الـ viewer ID من SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  int? viewerId = prefs.getInt('user_id');
  print('Viewer ID from SharedPreferences: $viewerId');

  if (viewerId == null || viewerId == 0) {
    print('Invalid viewerId: $viewerId');
    throw Exception('Invalid viewerId, cannot fetch profile');
  }

  final url = 'http://127.0.0.1:8000/accounts/profile/$userId/$viewerId';
  print("User ID being sent: $userId");
  print("Fetching profile from URL: $url");

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data['profile_data'] != null && data['profile_data']['id'] != null) {
      final profileId = data['profile_data']['id'];
      await prefs.setInt('profile_id', profileId);
      print('Saved profileId: $profileId');
    } else {
      print('profile_data or id is null in the response');
    }

    return data;
  } else {
    print('Failed to load profile data. Status code: ${response.statusCode}');
    throw Exception('Failed to load profile data with status code: ${response.statusCode}');
  }
}




  Widget _buildDiscussionsContent(
    List<dynamic> discussions,
    Map<String, dynamic> user,
    Map<String, dynamic> profile,
  ) {
    return Column(
      children:
          discussions.map((discussion) {
            return FirstDiscussion.fromMap(discussion);
          }).toList(),
    );
  }

  Widget _buildForumsContent(List<dynamic> forums) {
  if (forums.isEmpty) {
    return const Center(child: Text('No Forums Yet'));
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: forums.length,
    itemBuilder: (context, index) {
      final forum = forums[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ForumCard.fromMap({
          'cover': forum['cover'] ?? '',
          'title': forum['title'] ?? 'No Title',
          'description': forum['description'] ?? 'No Description',
          'created_on': forum['created_at'] ?? '',
          'members': forum['members'] ?? [],
          'discussions': forum['discussions'] ?? [],
          'profile': forum['profile'] ?? {},
        }),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        flexibleSpace: const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Social Network',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Divider(
                  height: 15,
                  thickness: 1,
                  color: Colors.black,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final user = data['user_data'] ?? {};
            final profile = data['profile_data'] ?? {};
            final discussions = List.from(data['discussions'] ?? []);
            final forums = List.from(data['forum'] ?? []);

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 180,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'http://127.0.0.1:8000${profile['cover'] ?? ''}',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Positioned(
                        bottom: -80,
                        left: 20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: DecorationImage(
                              image: NetworkImage(
                                'http://127.0.0.1:8000${profile['image'] ?? ''}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 100 + 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user['first_name']} ${user['last_name']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (profile['tagline'] != null &&
                                  profile['tagline'].toString().isNotEmpty)
                                Text(profile['tagline'] ?? ''),
                              const SizedBox(height: 4),
                              if (profile['organization'] != null &&
                                  profile['organization'].toString().isNotEmpty)
                                Text(profile['organization'] ?? ''),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 20,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        if (profile['rank'] != null &&
                            profile['rank'].toString().isNotEmpty)
                          Container(
                            width: 130,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 6),
                                Text(
                                  profile['rank'] ?? 'Bronze',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Color(0xFF691E0C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (profile['rank'] != null &&
                            profile['rank'].toString().isNotEmpty)
                          const SizedBox(width: 8),
                        if (profile['interested'] != null ||
                            profile['interesting'] != null)
                          Expanded(
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              dashPattern: const [8, 5],
                              color: Colors.black54,
                              strokeWidth: 1.5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    if (profile['interested'] != null)
                                      Column(
                                        children: [
                                          Text(
                                            '${profile['interested']}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Interested',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),

                                    if (profile['interested'] != null &&
                                        profile['interesting'] != null)
                                      const SizedBox(width: 1),

                                    if (profile['interesting'] != null)
                                      Column(
                                        children: [
                                          Text(
                                            '${profile['interesting']}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Interesting',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F1FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 1.0),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.remove_red_eye, size: 24),
                              SizedBox(width: 10),
                              Text(
                                'Profile Views',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: Text(
                              '${profile['views'] ?? 0} views', 
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 15),

                          const Row(
                            children: [
                              Icon(Icons.forum_outlined, size: 24),
                              SizedBox(width: 10),
                              Text(
                                'Issued Discussions',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: Text(
                              '${profile['discussions_count'] ?? 0} discussions issued', 
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 15),

                          
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InterestScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 80,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Interests',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.white, spreadRadius: 1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    height: 1.5,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: List.generate(
                        25,
                        (index) => Expanded(
                          child: Container(
                            height: 1.5,
                            margin: const EdgeInsets.only(right: 0),
                            color:
                                index.isEven
                                    ? Colors.black
                                    : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() => _activeIndex = 0);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    _activeIndex == 0
                                        ? const Color(
                                          0xFF0080FF,
                                        ).withOpacity(0.1)
                                        : Colors.transparent,
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: Text(
                                'Forums',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _activeIndex == 0
                                          ? const Color(0xFF0080FF)
                                          : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => _activeIndex = 1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    _activeIndex == 1
                                        ? const Color(
                                          0xFF0080FF,
                                        ).withOpacity(0.1)
                                        : Colors.transparent,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: Text(
                                'Discussions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _activeIndex == 1
                                          ? const Color(0xFF0080FF)
                                          : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_activeIndex == 0)
                    _buildForumsContent(forums)
                  else
                    _buildDiscussionsContent(discussions, user, profile),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data found.'));
          }
        },
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (index == 1) {
            _showNewOptions();
          }
        },
      ),
    );
  }
}
