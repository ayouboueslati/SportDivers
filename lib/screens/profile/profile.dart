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
  File? _profileImage;
  String? _selectedPaymentMethod;
  String? _selectedDiscountType;

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.grey.withOpacity(0.3),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: userData == null
          ? Center(
              child: Text('Aucune donnée disponible',
                  style: TextStyle(fontSize: 18, color: Colors.black87)),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildProfileImage(userData),
                    const SizedBox(height: 24),
                    _buildInfoCard(userData),
                    const SizedBox(height: 24),
                    _buildSettingsCard(userData),
                    const SizedBox(height: 36),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileImage(Map<String, dynamic> userData) {
    return Center(
      child: GestureDetector(
        onTap: _selectProfileImage,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue[900]!, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : NetworkImage(userData['profilePicture']) as ImageProvider,
                child: _profileImage == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.white70)
                    : null,
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue[900],
                child: Icon(Icons.edit, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> userData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('informations personnelles',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900])),
            Divider(thickness: 2, color: Colors.blue[200]),
            _buildInfoRow('Prenom', userData['firstName']),
            _buildInfoRow('Nom', userData['lastName']),
            _buildInfoRow('Numéro de téléphone', userData['phone']?.toString()),
            _buildInfoRow('Addresse', userData['address']),
            _buildInfoRow('Genre', userData['gender']),
            _buildInfoRow(
                'date de naissance', userData['birthdate']?.substring(0, 10)),
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
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Paramètres du compte',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900])),
            Divider(thickness: 2, color: Colors.blue[200]),
            _buildInfoRow('Groupe', userData['group']?['designation']),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Mode de paiement',
              value: _selectedPaymentMethod,
              items: ['PER_MONTH', 'PER_YEAR'],
              onChanged: (newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Type de remise',
              value: _selectedDiscountType,
              items: ['NONE', 'PERCENTAGE', 'AMOUNT'],
              onChanged: (newValue) {
                setState(() {
                  _selectedDiscountType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Réduction', userData['discount']?.toString()),
            _buildInfoRow('A Accès', userData['hasAccess'] ? 'Oui' : 'Non'),
            _buildInfoRow('Is Active', userData['isActive'] ? 'Oui' : 'Non'),
            _buildInfoRow('Date d inscription',
                userData['inscriptionDate']?.substring(0, 10)),
            _buildInfoRow('Créé le', userData['createdAt']?.substring(0, 10)),
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
    return TextStyle(
      fontSize: 16,
      color: Colors.blue[700],
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _valueStyle() {
    return TextStyle(
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
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[300]!),
          ),
          child: DropdownButton<String>(
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
            style: _valueStyle(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _logout(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Déconnexion',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.logoutUser();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}
