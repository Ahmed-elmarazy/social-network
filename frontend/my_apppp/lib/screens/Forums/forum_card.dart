// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/screens/Forums/join_forums.dart';
import 'package:my_app/screens/profile_page/profile_screen.dart';

const String baseUrl = "http://127.0.0.1:8000/";

class ForumCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String createdOn;
  final int membersCount;
  final List<dynamic> members;
  final String actionText;
  final List<dynamic> discussions;
  final Map<String, dynamic> profile;

  const ForumCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.createdOn,
    required this.membersCount,
    required this.members,
    required this.actionText,
    required this.discussions,
    required this.profile,
  });

  factory ForumCard.fromMap(Map<String, dynamic> map) {
    return ForumCard(
      image: map['cover'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdOn: map['created_on'] ?? '',
      membersCount: (map['members'] as List?)?.length ?? 0,
      members: map['members'] ?? [],
      actionText: 'Join',
      discussions: map['discussions'] ?? [],
      profile: map['profile'] ?? {},
    );
  }

  Widget _buildAvatar(String imagePath, {VoidCallback? onTap}) {
    final fullImageUrl = "$baseUrl/${imagePath.replaceFirst(RegExp('^/'), '')}";
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white,
        child: ClipOval(
          child: imagePath.isNotEmpty
              ? Image.network(
                  fullImageUrl,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, size: 20),
                )
              : const Icon(Icons.person, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullImageUrl = "$baseUrl/${image.replaceFirst(RegExp('^/'), '')}";
    final String ownerName = profile['full_name'] ?? 'Unknown';
    final String ownerImage = profile['image'] ?? '';
    final int ownerId = profile['id'] ?? 0;

    return Container(
      margin: const EdgeInsets.all(8),
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF000000), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                fullImageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(height: 150, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      _buildAvatar(ownerImage, onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(userId: ownerId),
                          ),
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        ownerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(
                    createdOn,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: List.from(members.take(3)).asMap().entries.map(
                            (entry) {
                              int index = entry.key;
                              var member = entry.value;
                              return Positioned(
                                left: index * 18.0,
                                child: _buildAvatar(member['image'] ?? ''),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        membersCount > 3 ? "+ ${membersCount - 3} more" : "",
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                              print('Discussions: ${discussions.length}');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JoinForums(
                                forumData: {
                                  'cover': image,
                                  'title': title,
                                  'description': description,
                                  'members': members,
                                  'discussions': discussions,
                                  'profile': profile,
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0080FF),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          actionText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
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
