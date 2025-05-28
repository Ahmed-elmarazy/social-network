// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:my_app/screens/Discussions/first_discussion.dart';
import 'package:my_app/screens/forums_and_discussions/discussions_screen.dart';
import 'package:my_app/screens/profile_page/profile_screen.dart';

class JoinForums extends StatefulWidget {
  final Map<String, dynamic> forumData;

  const JoinForums({super.key, required this.forumData});

  @override
  State<JoinForums> createState() => _JoinForumsState();
}

class _JoinForumsState extends State<JoinForums> {
  bool showJoinButton = true;
  List<Map<String, dynamic>> discussions = [];

  @override
  void initState() {
    super.initState();

    if (widget.forumData.containsKey('discussions') &&
        widget.forumData['discussions'] != null) {
      discussions = List<Map<String, dynamic>>.from(
        widget.forumData['discussions'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final forum = widget.forumData;
    final profile = forum['profile'] ?? {};
    final creator = forum['profile'] ?? {};
    print('Creator data: $creator');

    print('Full name: ${profile['full_name']}');

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      forum['cover'] != null && forum['cover'].isNotEmpty
                          ? Image.network(
                            "http://127.0.0.1:8000/${forum['cover'].replaceFirst(RegExp('^/'), '')}",
                            width: 430,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                                  width: 430,
                                  height: 200,
                                  color: Colors.grey,
                                ),
                          )
                          : Container(
                            width: 430,
                            height: 200,
                            color: Colors.grey,
                          ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final int userId = profile['id'] ?? 0;
                        if (userId != 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileScreen(userId: userId),
                            ),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            (profile['image'] != null &&
                                    profile['image'].isNotEmpty)
                                ? NetworkImage(
                                  "http://127.0.0.1:8000/${profile['image'].replaceFirst(RegExp('^/'), '')}",
                                )
                                : null,
                        child:
                            (profile['image'] == null ||
                                    profile['image'].isEmpty)
                                ? const Icon(Icons.person, size: 20)
                                : null,
                      ),
                    ),

                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile['full_name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          profile['tagline'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    forum['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child:
                      showJoinButton
                          ? ElevatedButton(
                            onPressed:
                                () => setState(() => showJoinButton = false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              "Join",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final newDiscussion =
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const DiscussionsScreen(),
                                              ),
                                            );

                                        if (newDiscussion != null &&
                                            newDiscussion
                                                is Map<String, dynamic>) {
                                          setState(() {
                                            discussions.add(newDiscussion);
                                          });
                                        }
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.add_box,
                                            size: 20,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "New Discussion",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 150),
                              GestureDetector(
                                onTap:
                                    () => setState(() => showJoinButton = true),
                                child: const Icon(
                                  Icons.exit_to_app,
                                  size: 30,
                                  color: Color.fromARGB(255, 239, 102, 102),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    forum['description'] ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              discussions.isEmpty
                  ? const Center(
                    child: Text(
                      'No Discussions Yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : Column(
                    children:
                        discussions.map((discussion) {
                          return Column(
                            children: [
                              FirstDiscussion.fromMap(discussion),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
