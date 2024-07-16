import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'CardPicture.dart'; // Import your CardPicture widget here

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage; // Track the selected profile image file

  void _selectProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _selectProfileImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : AssetImage('assets/images/cr7.jpg')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ronaldo',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // const Text(
                            //   'ST',
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 16,
                            //   ),
                            // ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                IconTextRow(
                                  icon: Icons.check_circle,
                                  iconColor: Colors.green,
                                  text: 'Matches played',
                                  textStyle:
                                      TextStyle(fontSize: screenWidth * 0.05),
                                  count: 11,
                                ),
                                const SizedBox(height: 10),
                                IconTextRow(
                                  icon: Icons.cancel,
                                  iconColor: Colors.red,
                                  text: 'Absent',
                                  textStyle:
                                      TextStyle(fontSize: screenWidth * 0.05),
                                  count: 6,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('Matches', '100'),
                              _buildStatItem('Goals', '45'),
                              _buildStatItem('Assists', '30'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Player Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          _buildInfoItem('Position', 'Forward'),
                          _buildInfoItem('Coach', 'John Smith'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _logout(context);
                      Navigator.pushNamed(context, '/login'); // Use named route
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    print('User logged out');
  }

  Widget _buildStatItem(String label, String value) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: Colors.white70),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class IconTextRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final int count;
  final TextStyle? textStyle;

  const IconTextRow({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.count,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
