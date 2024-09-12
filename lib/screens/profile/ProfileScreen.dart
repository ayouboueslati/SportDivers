import 'dart:io';
import 'package:flutter/material.dart';
import 'package:footballproject/Menu/MenuPage.dart';
import 'package:footballproject/Provider/ProfileProvider/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/screens/auth/login_screen.dart';
import 'package:footballproject/screens/profile/ModifyProfile.dart';
import 'package:intl/intl.dart';

class ProfileScreen1 extends StatefulWidget {
  static String id = 'profile_screen';

  const ProfileScreen1({Key? key}) : super(key: key);

  @override
  _ProfileScreen1State createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
    });
  }

  void _fetchUserData() async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final token = authProvider.token;

    if (token != null) {
      await profileProvider.fetchUserData(token);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            //Navigator.pop(context);
            Navigator.pushReplacementNamed(context, HomePage.id);
          },
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (profileProvider.userData == null) {
            return Center(
              child: Text('Aucune donnée disponible',
                  style: TextStyle(fontSize: 18, color: Colors.black87)),
            );
          } else {
            final userData = profileProvider.userData!['userData'];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildProfileImage(userData),
                    const SizedBox(height: 24),
                    _buildInfoCard(userData),
                    const SizedBox(height: 30),
                    _buildModifyProfileButton(context, userData),
                    const SizedBox(height: 15),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileImage(Map<String, dynamic> userData) {
    return Center(
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
                  : (userData['profilePicture'] != null && userData['profilePicture'].isNotEmpty
                  ? NetworkImage(userData['profilePicture']) as ImageProvider
                  : AssetImage('assets/default_profile_image.png')),
              child: (_profileImage == null && (userData['profilePicture'] == null || userData['profilePicture'].isEmpty))
                  ? Icon(Icons.person, size: 40, color: Colors.white70)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Informations personnelles',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900])),
              Divider(thickness: 2, color: Colors.blue[200]),
              _buildInfoRow(Icons.person, 'Nom et Prénom',
                  '${userData['lastName']} ${userData['firstName']}'),
              _buildInfoRow(Icons.alternate_email, 'E-mail', userData['email']),
              _buildInfoRow(Icons.phone, 'Téléphone', userData['phone']),
              _buildInfoRow(Icons.location_on, 'Adresse', userData['address']),
              _buildInfoRow(Icons.cake, 'Date de naissance',
                  _formatDate(userData['birthdate'])),
              _buildInfoRow(Icons.calendar_today, 'Date d\'inscription',
                  _formatDate(userData['inscriptionDate'])),
              _buildInfoRow(Icons.sports_soccer, 'Catégorie',
                  userData['group']['category']['designation']),
              _buildInfoRow(Icons.group, 'Groupe',
                  userData['group']['designation']),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Non renseigné';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Date invalide';
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700], size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _labelStyle()),
                SizedBox(height: 4),
                Text(value ?? 'Non renseigné', style: _valueStyle()),
              ],
            ),
          ),
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

  Widget _buildModifyProfileButton(BuildContext context, Map<String, dynamic> userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfileScreen(userData: userData),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mode_edit_outline_outlined, size: 24),
              SizedBox(width: 8),
              Text(
                'Modifier Votre Profil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          _logout(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 24),
              SizedBox(width: 8),
              Text(
                'Déconnexion',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.logoutUser();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}