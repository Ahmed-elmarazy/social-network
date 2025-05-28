// // ignore_for_file: unused_local_variable

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:my_app/screens/Discussions/first_discussion.dart';
// import 'package:my_app/screens/Discussions/second_discussion.dart';
// import 'package:my_app/screens/Forums/forum_card.dart';
// import 'package:my_app/screens/forums_and_discussions/discussions_screen.dart';
// import 'package:my_app/screens/forums_and_discussions/forums_screen.dart';
// import 'package:my_app/screens/profile_page/edit_profile_screen.dart';
// import 'package:my_app/screens/profile_page/interest_screen.dart';
// import 'package:my_app/widgets/shared/custom_bottom_navbar.dart';
// import 'package:my_app/screens/home_page/home_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   int _activeIndex = 0;
//   int _currentNavIndex = 2;

//   void _showNewOptions() {
//     showDialog(
//       context: context,
//       barrierColor: Colors.transparent,
//       builder: (_) => Material(
//         type: MaterialType.transparency,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 90),
//             child: Material(
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 width: 160,
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => const ForumScreen()),
//                         );
//                       },
//                       child: const Text(
//                         'Forum',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     const Divider(
//                       height: 15,
//                       thickness: 1,
//                       color: Colors.black38,
//                       indent: 20,
//                       endIndent: 20,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => const DiscussionsScreen()),
//                         );
//                       },
//                       child: const Text(
//                         'Discussion',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenwidth = MediaQuery.of(context).size.width;
//     final screenheight = MediaQuery.of(context).size.height;
//     final isMobile = screenwidth < 600;

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back),
//         ),
//         toolbarHeight: 60,
//         automaticallyImplyLeading: false,
//         flexibleSpace: const Align(
//           alignment: Alignment.bottomCenter,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Social Network',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 12),
//             ],
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Container(
//                   height: 180,
//                   margin: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                     image: const DecorationImage(
//                       image: AssetImage('assets/images/Ahmed.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: -80,
//                   left: 20,
//                   child: Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 3),
//                       image: const DecorationImage(
//                         image: AssetImage('assets/images/Ahmed.jpg'),
//                         fit: BoxFit.cover,
//                         filterQuality: FilterQuality.high,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
//               child: Stack(
//                 children: [
//                   const Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(width: 100 + 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Ahmed Saad',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               'Just chillin\'',
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               'FCAI',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 0,
//                     right: 0,
//                     child: IconButton(
//                       icon: const Icon(Icons.edit, size: 20),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                            MaterialPageRoute(
//                             builder: (context) => const  EditProfileScreen() ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(         //////////
//               padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 130, 
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: const Color(0xFFA14E39),
//                         width: 1.5,
//                       ),
//                     ),
//                     child: const Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Your Metal',
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: Colors.grey,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                         SizedBox(height: 6),
//                         Text(
//                           'Bronze',
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Color(0xFF691E0C),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: DottedBorder(
//                       borderType: BorderType.RRect,
//                       radius: const Radius.circular(12),
//                       dashPattern: const [8, 5],
//                       color: Colors.black54,
//                       strokeWidth: 1.5,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 7, horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Column(
//                               children: [
//                                 Text(
//                                   '192',
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Interested',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(width: 1),
//                             Column(
//                               children: [
//                                 Text(
//                                   '23',
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Interesting',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),////////////////
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE2F1FF),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: Colors.black,
//                     width: 1.0,
//                   ),
//                 ),
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(Icons.remove_red_eye, size: 24),
//                         SizedBox(width: 10),
//                         Text(
//                           'Profile Views',
//                           style: TextStyle(
//                               fontSize: 22, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     const Padding(
//                       padding: EdgeInsets.only(left: 32),
//                       child: Text(
//                         '20 views in the last 30 days',
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     const Row(
//                       children: [
//                         Icon(Icons.forum_outlined, size: 24),
//                         SizedBox(width: 10),
//                         Text(
//                           'Issued Discussions',
//                           style: TextStyle(
//                               fontSize: 22, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     const Padding(
//                       padding: EdgeInsets.only(left: 32),
//                       child: Text(
//                         '20 discussions issued in the last 30 days',
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     const Row(
//                       children: [
//                         Icon(Icons.chat_bubble, size: 24),
//                         SizedBox(width: 10),
//                         Text(
//                           'Interactions',
//                           style: TextStyle(
//                               fontSize: 22, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 32),
//                       child: Text(
//                         '10 of your Discussions have been interacted with in the last 30 days',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => const InterestScreen()),
//                         );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 14, horizontal: 80),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                   child: const Text(
//                     'Interests',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   right: -4,
//                   top: -4,
//                   child: Container(
//                     width: 12,
//                     height: 12,
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white,
//                           spreadRadius: 1,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),
//             Container(
//               height: 1.5,
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: List.generate(
//                   25,
//                   (index) => Expanded(
//                     child: Container(
//                       height: 1.5,
//                       margin: const EdgeInsets.only(right: 0),
//                       color: index.isEven ? Colors.black : Colors.transparent,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black,
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         setState(() => _activeIndex = 0);
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: _activeIndex == 0
//                               ? const Color(0xFF0080FF).withOpacity(0.1)
//                               : Colors.transparent,
//                           border: Border(
//                             right: BorderSide(
//                               color: Colors.grey[300]!,
//                               width: 1.5,
//                             ),
//                           ),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 12),
//                         child: Text(
//                           'Forums',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: _activeIndex == 0
//                                 ? const Color(0xFF0080FF)
//                                 : Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() => _activeIndex = 1);
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: _activeIndex == 1
//                               ? const Color(0xFF0080FF).withOpacity(0.1)
//                               : Colors.transparent,
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 12),
//                         child: Text(
//                           'Discussions',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: _activeIndex == 1
//                                 ? const Color(0xFF0080FF)
//                                 : Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             if (_activeIndex == 0)
//               _buildForumsContent()
//             else
//               _buildDiscussionsContent(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNav(
//         currentIndex: _currentNavIndex,
//         onTap: (index) {
//           setState(() {
//             _currentNavIndex = index;
//           });
//           if (index == 0) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const HomeScreen()),
//             );
//           } else if (index == 1) {
//             _showNewOptions();
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildForumsContent() {
//     return  Column(
//       children: [
//         SizedBox(height: 20),
//         ForumCard(
//           image: "assets/images/OIP (1).jpg",
//           title: "UI/UX Designers",
//           actionText: "Join",
//           margin: EdgeInsets.only(bottom: 12),
//         ),
//         SizedBox(height: 20),
//         ForumCard(
//           image: "assets/images/OIP.jpg",
//           title: "Solo Travelers",
//           actionText: "Visit",
//           margin: EdgeInsets.only(bottom: 12),
//         ),
//         SizedBox(height: 40),
//       ],
//     );
//   }

//   Widget _buildDiscussionsContent() {
//     return const Column(
//       children: [
//         SizedBox(height: 20),
//         FirstDiscussion(
//           userName: "Ahmed Saad",
//           userFaculty: "FCAI",
//           timeAgo: "3 days ago",
//           postText:
//               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//           interestedCount: 34,
//           commentCount: 8,
//         ),
//         SizedBox(height: 20),
//         SecondDiscussion(
//           userName: "Ahmed Saad",
//           userFaculty: "FCAI",
//           timeAgo: "3 days ago",
//           postText:
//               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//           interestedCount: 34,
//           commentCount: 8,
//         ),
//         SizedBox(height: 40),
//       ],
//     );
//   }
// }
 