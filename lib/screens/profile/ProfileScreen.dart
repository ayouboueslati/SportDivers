import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/ProfileProvider/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/screens/auth/login_screen.dart';
import 'package:sportdivers/screens/auth/reset_password/resetPasswordWebView.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';
import 'package:sportdivers/screens/profile/ModifyProfile.dart';
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
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final token = authProvider.token;

    if (token != null) {
      await profileProvider.fetchUserData(token);
    }
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
          'Profil',
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
            return  Center(
                child: CircularProgressIndicator(color: Colors.blue[800]));
          } else if (profileProvider.userData == null) {
            return Center(
              child: Text('Aucune donnée disponible',
                  style: hsMedium.copyWith(
                      fontSize: 18, color: DailozColor.black)),
            );
          } else {
            final userData = profileProvider.userData!['userData'];
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(width / 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildProfileImage(userData, height),
                    SizedBox(height: height / 24),
                    _buildInfoCard(userData, height, width),
                    SizedBox(height: height / 30),
                    _buildModifyProfileButton(context, userData, height, width),
                    SizedBox(height: height / 60),
                    _buildChangePwdButton(context, userData, height, width),
                    SizedBox(height: height / 60),
                    _buildLogoutButton(context, height, width),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileImage(Map<String, dynamic> userData, double height) {
    return Center(
      child: Container(
        height: height / 7,
        width: height / 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue[800]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: DailozColor.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundImage: _profileImage != null
              ? FileImage(_profileImage!)
              : (userData['profilePicture'] != null &&
                      userData['profilePicture'].isNotEmpty
                  ? NetworkImage(userData['profilePicture']) as ImageProvider
                  : AssetImage('assets/default_profile_image.png')),
          child: (_profileImage == null &&
                  (userData['profilePicture'] == null ||
                      userData['profilePicture'].isEmpty))
              ? const Icon(Icons.person, size: 40, color: DailozColor.white)
              : null,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      Map<String, dynamic> userData, double height, double width) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(width / 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Informations Personnelles',
                style: hsSemiBold.copyWith(
                    fontSize: 18, color: Colors.blue[800])),
            const Divider(thickness: 1, color: DailozColor.bggray),
            _buildInfoRow(Icons.person, 'Nom',
                '${userData['lastName']} ${userData['firstName']}'),
            _buildInfoRow(Icons.email, 'E-mail', userData['email']),
            _buildInfoRow(Icons.phone, 'Téléphone', userData['phone']),
            _buildInfoRow(Icons.location_on, 'Adresse', userData['address']),
            _buildInfoRow(
                Icons.cake, 'Date de naissance', _formatDate(userData['birthdate'])),
            _buildInfoRow(Icons.calendar_today, 'Date d\'inscription',
                _formatDate(userData['inscriptionDate'])),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: hsMedium.copyWith(
                        fontSize: 14, color: DailozColor.textgray)),
                Text(value ?? 'Non fourni',
                    style: hsMedium.copyWith(
                        fontSize: 16, color: DailozColor.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModifyProfileButton(BuildContext context,
      Map<String, dynamic> userData, double height, double width) {
    return SizedBox(
      width: double.infinity,
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
          backgroundColor: Colors.blue[800],
          foregroundColor: DailozColor.white,
          padding: EdgeInsets.symmetric(vertical: height / 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit, size: 20),
            SizedBox(width: width / 36),
            Text(
              'Modifier votre profil',
              style: hsSemiBold.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePwdButton(BuildContext context,
      Map<String, dynamic> userData, double height, double width) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(token: authProvider.token ?? ''),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          foregroundColor: DailozColor.white,
          padding: EdgeInsets.symmetric(vertical: height / 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_rounded, size: 20),
            SizedBox(width: width / 36),
            Text(
              'Changer votre mot de passe',
              style: hsSemiBold.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, double height, double width) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _logout(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: DailozColor.white,
          foregroundColor: Colors.blue[800],
          padding: EdgeInsets.symmetric(vertical: height / 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:  BorderSide(color: Colors.blue[800]!),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 20),
            SizedBox(width: width / 36),
            Text(
              'Déconnexion',
              style: hsSemiBold.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Non fourni';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'Date invalide';
    }
  }

  void _logout(BuildContext context) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    await authProvider.logoutUser();
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}
