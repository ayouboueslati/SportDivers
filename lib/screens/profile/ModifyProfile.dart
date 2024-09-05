import 'package:flutter/material.dart';
import 'package:footballproject/Provider/ProfileProvider/EditProfileProvider.dart';
import 'package:footballproject/screens/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/Provider/ProfileProvider/profileProvider.dart';



class EditProfileScreen extends StatefulWidget {
  static String id = 'Edit_Profile_Screen';
  final Map<String, dynamic>? userData;

  const EditProfileScreen({Key? key, this.userData}) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.userData?['firstName'] ?? '');
    _lastNameController = TextEditingController(text: widget.userData?['lastName'] ?? '');
    _emailController = TextEditingController(text: widget.userData?['email'] ?? '');
    _phoneController = TextEditingController(text: widget.userData?['phone'] ?? '');
    _addressController = TextEditingController(text: widget.userData?['address'] ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Modifier le profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildForm(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTextField(_firstNameController, 'Prénom', Icons.person),
          _buildTextField(_lastNameController, 'Nom', Icons.person_outline),
          _buildTextField(_emailController, 'E-mail', Icons.email),
          _buildTextField(_phoneController, 'Téléphone', Icons.phone),
          _buildTextField(_addressController, 'Adresse', Icons.home),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[900],
              padding:const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Enregistrer les modifications',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue[900]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue[900]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    final editProfileProvider = Provider.of<EditProfileProvider>(context, listen: false);

    Map<String, dynamic> updatedData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
    };

    final updatedUser = await editProfileProvider.updateUserProfile(updatedData);

    if (updatedUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${editProfileProvider.error}')),
      );
    }
  }
}