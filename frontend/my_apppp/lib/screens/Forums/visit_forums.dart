// import 'package:flutter/material.dart';
// import 'package:my_app/screens/Discussions/first_discussion.dart';
// import 'package:my_app/screens/forums_and_discussions/discussions_screen.dart';
// import 'package:my_app/screens/home_page/home_screen.dart';

// class VisitForums extends StatefulWidget {
//   const VisitForums({super.key});

//   @override
//   State<VisitForums> createState() => _VisitForumsState();
// }

// class _VisitForumsState extends State<VisitForums> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const HomeScreen(),
//               ),
//             );
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//         toolbarHeight: 70,
//         automaticallyImplyLeading: false,
//         flexibleSpace: const Align(
//           alignment: Alignment.bottomCenter,
//           child: Padding(
//             padding: EdgeInsets.only(top: 10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Social Network',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 Divider(
//                   height: 15,
//                   thickness: 1,
//                   color: Colors.black,
//                   indent: 0,
//                   endIndent: 0,
//                 ),
//                 SizedBox(height: 8),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//               Center(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Image.asset(
//                     'assets/images/OIP.jpg',
//                     width: 430,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: const Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundImage: AssetImage('assets/images/Ahmed.jpg'),
//                     ),
//                     SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Ahmed Saad",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 1),
//                         Text(
//                           "  FCAI",
//                           style: TextStyle(fontSize: 14, color: Colors.black54),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   alignment: Alignment.centerLeft,
//                   child: const Text(
//                     "UI/UX Designer",
//                     style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child:  Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(
//                                   color: Colors.blue,
//                                   width: 1.0,
//                                 ),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 10),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               const DiscussionsScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: const Row(
//                                       children: [
//                                         Icon(Icons.add_box,
//                                             size: 20, color: Colors.blue),
//                                         SizedBox(width: 4),
//                                         Text(
//                                           "New Discussion",
//                                           style: TextStyle(
//                                             color: Colors.blue,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(width: 4),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 200),
//                             GestureDetector(
                          
//                               child: const Icon(
//                                 Icons.exit_to_app,
//                                 size: 30,
//                                 color: Color.fromARGB(255, 239, 102, 102),
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   alignment: Alignment.centerLeft,
//                   child: const Text(
//                     "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//                     style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const FirstDiscussion(
//                 userName: "Ahmed Saad",
//                 userFaculty: "FCAI",
//                 timeAgo: "3 days ago",
//                 postText:
//                     "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
//                 interestedCount: 34,
//                 commentCount: 8,
//                 userImage: "",
//               ),
//               const SizedBox(height: 20),
           
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
