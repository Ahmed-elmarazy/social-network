// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/screens/auth/login_screen.dart';
import 'package:my_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  XFile? _coverImage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();

  Future<void> _pickProfileImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _profileImage = pickedImage;
    });
  }

  Future<void> _pickCoverImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _coverImage = pickedImage;
    });
  }

  Future<void> updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final viewerId = prefs.getInt('viewer_id') ?? userId;

    if (userId == null) {
      print('User ID not found');
      return;
    }

    final uri = Uri.parse(
      'http://127.0.0.1:8000/accounts/profile/$userId/$viewerId/',
    );
    final request = http.MultipartRequest('PUT', uri);

    request.fields['tagline'] = taglineController.text;
    request.fields['organization'] = organizationController.text;

    if (_profileImage != null) {
      final bytes = await _profileImage!.readAsBytes();
      final profileImageFile = http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: _profileImage!.name,
      );
      request.files.add(profileImageFile);
    }

    if (_coverImage != null) {
      final bytes = await _coverImage!.readAsBytes();
      final coverImageFile = http.MultipartFile.fromBytes(
        'cover',
        bytes,
        filename: _coverImage!.name,
      );
      request.files.add(coverImageFile);
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Profile updated: $jsonData');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        print('Failed to update profile: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('An error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          toolbarHeight: 70,
          automaticallyImplyLeading: false,
          flexibleSpace: const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffC1C1C1),
                ),
              ),
            ),
            _buildField('Name', nameController),
            const SizedBox(height: 16),
            _buildField('Tagline', taglineController),
            const SizedBox(height: 16),
            _buildField('Organization', organizationController),
            const SizedBox(height: 16),
            _buildUploadButton('Profile picture', _pickProfileImage),
            const SizedBox(height: 16),
            _buildUploadButton('Cover image', _pickCoverImage),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () async {
                  await updateProfile();
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('user_id');

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('hasCompletedOnboarding');
                  await prefs.remove('user_id');
                  await prefs.remove('isLoggedIn');

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const SplashScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Reset App",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.black38, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton(String label, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                label == 'Profile picture'
                    ? (_profileImage == null ? 'Upload image' : 'Change image')
                    : (_coverImage == null ? 'Upload image' : 'Change image'),
                style: const TextStyle(color: Color(0xff858585)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
