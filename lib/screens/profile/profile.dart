import 'dart:io';
import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/screens/auth/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'profile_screen';

  const ProfileScreen({Key? key, this.userData}) : super(key: key);

  final Map<String, dynamic>? userData;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage; // Track the selected profile image file
  String? _selectedPaymentMethod;
  String? _selectedDiscountType;

  @override
  void initState() {
    super.initState();
    // Load profile image if URL is provided
    _selectedPaymentMethod = widget.userData?['paymentMethod'] ?? 'N/A';
    _selectedDiscountType = widget.userData?['discountType'] ?? 'N/A';
  }

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
    final userData = widget.userData;

    return Scaffold(
      body: userData == null
          ? Center(
              child: Text('No data available', style: TextStyle(fontSize: 18)))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: GestureDetector(
                        onTap: _selectProfileImage,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : NetworkImage(userData['profilePicture'])
                                  as ImageProvider,
                          child: _profileImage == null
                              ? Icon(Icons.camera_alt,
                                  size: 40, color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoCard(userData),
                    const SizedBox(height: 20),
                    _buildSettingsCard(userData),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade900,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> userData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoRow('First Name', userData['firstName']),
            _buildInfoRow('Last Name', userData['lastName']),
            _buildInfoRow('Phone', userData['phone']?.toString()),
            _buildInfoRow('Address', userData['address']),
            _buildInfoRow('Gender', userData['gender']),
            _buildInfoRow('Birthdate', userData['birthdate']?.substring(0, 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(Map<String, dynamic> userData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoRow('Group', userData['group']?['designation']),
            const SizedBox(height: 10),
            _buildDropdown(
              label: 'Payment Method',
              value: _selectedPaymentMethod,
              items: ['PER_MONTH', 'PER_YEAR'],
              onChanged: (newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue;
                });
              },
            ),
            const SizedBox(height: 10),
            _buildDropdown(
              label: 'Discount Type',
              value: _selectedDiscountType,
              items: ['NONE', 'PERCENTAGE', 'AMOUNT'],
              onChanged: (newValue) {
                setState(() {
                  _selectedDiscountType = newValue;
                });
              },
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Discount', userData['discount']?.toString()),
            _buildInfoRow('Has Access', userData['hasAccess'] ? 'Yes' : 'No'),
            _buildInfoRow('Is Active', userData['isActive'] ? 'Yes' : 'No'),
            _buildInfoRow('Inscription Date',
                userData['inscriptionDate']?.substring(0, 10)),
            _buildInfoRow(
                'Created At', userData['createdAt']?.substring(0, 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _labelStyle()),
          Text(value ?? 'N/A', style: _valueStyle()),
        ],
      ),
    );
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _valueStyle() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.black87,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(label),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _logout(BuildContext context) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.logoutUser();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}
