// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:my_app/screens/Discussions/view_coment.dart';
import 'package:my_app/screens/profile_page/profile_screen.dart';

class FirstDiscussion extends StatelessWidget {
  final String userName;
  final String userFaculty;
  final String timeAgo;
  final String postText;
  final int interestedCount;
  final int commentCount;
  final String userImage;
  final int discussionId;
  final int userId;
  

  const FirstDiscussion({
    required this.userName,
    required this.userFaculty,
    required this.timeAgo,
    required this.postText,
    required this.interestedCount,
    required this.commentCount,
    required this.userImage,
    required this.discussionId,
    required this.userId,
    super.key,
  });

factory FirstDiscussion.fromMap(Map<String, dynamic> discussion) {
  final profile = discussion['profile'] ?? {};
  return FirstDiscussion(
    userName: profile['full_name']?.toString() ?? 'Unknown',
    userFaculty: profile['tagline']?.toString() ?? '',
    timeAgo: discussion['created_on']?.toString() ?? '',
    postText: discussion['description']?.toString() ?? '',
    interestedCount: discussion['interested_count'] ?? 0,
    commentCount: discussion['comments_count'] ?? 0,
    userImage: profile['image']?.toString() ?? '',
    discussionId: discussion['id'] ?? 0,
    userId: profile['id'] ?? 0,
  );
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: Color(0xFF000000), width: 1),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (userId > 0) {
                              print('Opening profile for userId: $userId');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ProfileScreen(userId: userId),
                                ),
                              );
                            } else {
                              print('Invalid userId: $userId');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("User profile not available."),
                                ),
                              );
                            }
                          },

                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                userImage.isNotEmpty
                                    ? NetworkImage(
                                      "http://127.0.0.1:8000$userImage",
                                    )
                                    : const AssetImage(
                                          "assets/images/default_avatar.png",
                                        )
                                        as ImageProvider,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userFaculty,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  timeAgo,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  postText,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
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
                              index.isEven ? Colors.black : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "$interestedCount",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Interested",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "$commentCount",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Comment",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ViewComent(
                        userName: userName,
                        userFaculty: userFaculty,
                        timeAgo: timeAgo,
                        postText: postText,
                        interestedCount: interestedCount,
                        commentCount: commentCount,
                        userImage: userImage,
                        discussionId: discussionId,
                        userId: userId,
                        profileId: userId,
                      ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(150, 40),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              "View Comments",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1.5,
          color: Colors.black38,
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
