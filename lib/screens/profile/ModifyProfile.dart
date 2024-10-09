import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/ProfileProvider/EditProfileProvider.dart';
import 'package:sportdivers/components/CustomToast.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';
import 'package:sportdivers/screens/profile/ProfileScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/ProfileProvider/profileProvider.dart';


class EditProfileScreen extends StatefulWidget {
  static String id = 'Edit_Profile_Screen';
  final Map<String, dynamic>? userData;

  const EditProfileScreen({Key? key, this.userData}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage;
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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: DailozColor.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            splashColor: DailozColor.transparent,
            highlightColor: DailozColor.transparent,
            onTap: () => Navigator.pop(context),
            child: Container(
              height: height / 20,
              width: height / 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DailozColor.white,
                boxShadow: [
                  BoxShadow(
                      color: DailozColor.grey.withOpacity(0.3), blurRadius: 5)
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: width / 56),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: DailozColor.black,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Modifier votre profil',
          style: hsBold.copyWith(
            color: DailozColor.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: DailozColor.white,
        elevation: 0,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: DailozColor.appcolor));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(width / 36),
              child: Column(
                children: [
                  SizedBox(height: height / 36),
                  _buildProfileImage(height),
                  SizedBox(height: height / 24),
                  _buildForm(height, width),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _selectProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildProfileImage(double height) {
    return GestureDetector(
      onTap: _selectProfileImage,
      child: Stack(
        children: [
          Container(
            height: height / 7,
            width: height / 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: DailozColor.appcolor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: DailozColor.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : NetworkImage(widget.userData!['profilePicture']) as ImageProvider,
              child: _profileImage == null
                  ? const Icon(Icons.camera_alt, size: 40, color: DailozColor.white)
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: DailozColor.appcolor,
              ),
              child: const Icon(Icons.edit, size: 20, color: DailozColor.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(double height, double width) {
    return Column(
      children: [
        _buildTextField(_firstNameController, 'Prénom', Icons.person),
        SizedBox(height: height / 60),
        _buildTextField(_lastNameController, 'Nom ', Icons.person_outline),
        SizedBox(height: height / 60),
        _buildTextField(_emailController, 'E-mail', Icons.email),
        SizedBox(height: height / 60),
        _buildTextField(_phoneController, 'Téléphone', Icons.phone),
        SizedBox(height: height / 60),
        _buildTextField(_addressController, 'Adresse', Icons.home),
        SizedBox(height: height / 30),
        _buildSaveButton(height, width),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: hsMedium.copyWith(fontSize: 16, color: DailozColor.textgray),
        prefixIcon: Icon(icon, color: DailozColor.appcolor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DailozColor.bggray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: DailozColor.appcolor, width: 2),
        ),
        filled: true,
        fillColor: DailozColor.bggray,
      ),
    );
  }

  Widget _buildSaveButton(double height, double width) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: DailozColor.appcolor,
          foregroundColor: DailozColor.white,
          padding: EdgeInsets.symmetric(vertical: height / 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          'Enregistrer les modifications',
          style: hsSemiBold.copyWith(fontSize: 16),
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

    final updatedUser = await editProfileProvider.updateUserProfile(updatedData, profileImage: _profileImage);

    if (updatedUser != null) {
      showReusableToast(
        context: context,
        message: 'Profil mis à jour avec succès',
        duration: Duration(seconds: 5),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen1(),
        ),
      );
    } else {
      showReusableToast(
        context: context,
        message: 'Échec de la mise à jour du profil: ${editProfileProvider.error}',
        duration: Duration(seconds: 5),
      );
    }
  }
}