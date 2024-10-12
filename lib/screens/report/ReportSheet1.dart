import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/UserProvider/userProvider.dart';
import 'package:sportdivers/components/CustomToast.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';
import 'package:sportdivers/screens/report/fetchTicket.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/ReportPorivder/ticketProvider.dart';

class ReportPage extends StatefulWidget {
  static const String id = 'Report_Page';

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _reasonController = TextEditingController();
  final _commentController = TextEditingController();
  String? _selectedTarget;
  String? _selectedPerson;
  List<Map<String, dynamic>> _userList = []; // Updated type
  bool isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_reasonController.text.isNotEmpty &&
        _commentController.text.isNotEmpty &&
        _selectedTarget != null) {
      final reason = _reasonController.text;
      final comment = _commentController.text;

      Provider.of<TicketsProvider>(context, listen: false)
          .submitReport(
        reason: reason,
        comment: comment,
        target: _selectedTarget!,
        person: _selectedTarget == 'ADMIN' ? '' : (_selectedPerson ?? ''),
      )
          .then((_) {
        showReusableToast(
          context: context,
          message: 'Rapport soumis avec succès',
          duration: Duration(seconds: 5),
        );
        _reasonController.clear();
        _commentController.clear();
        setState(() {
          _selectedTarget = 'ADMIN';
          _selectedPerson = null;
          _userList.clear();
        });

        // Navigate to another page after success
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TicketsScreen()), // Replace with your destination
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de la soumission du rapport : $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs avant de soumettre.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onTargetChanged(String? newValue) {
    setState(() {
      _selectedTarget = newValue;
      _selectedPerson = null; // Clear selected person when target changes
      _userList.clear(); // Clear user list when target changes
    });
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final ticketsProvider =
        Provider.of<TicketsProvider>(context, listen: false);
    if (_selectedTarget == 'STUDENT' || _selectedTarget == 'TEACHER') {
      setState(() {
        isLoading = true;
      });
      try {
        final userType = _selectedTarget == 'STUDENT' ? 'Student' : 'Coach';
        await ticketsProvider.fetchUserList(userType);
        setState(() {
          _userList = ticketsProvider.userList;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de la récupération des utilisateurs : $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            splashColor: DailozColor.transparent,
            highlightColor: DailozColor.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: height / 20,
              width: height / 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: DailozColor.white,
                  boxShadow: const [
                    BoxShadow(color: DailozColor.textgray, blurRadius: 5)
                  ]),
              child: Padding(
                padding: EdgeInsets.only(left: width / 56),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: DailozColor.black,
                ),
              ),
            ),
          ),
        ),
        title: Text("Réclamation", style: hsSemiBold.copyWith(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Détails du Rapport",
                  style: hsSemiBold.copyWith(
                      fontSize: 20, color: Colors.blue[800])),
              SizedBox(height: height / 36),
              _buildTextField(
                controller: _reasonController,
                label: 'Raison',
                hint: 'Entrez la raison de votre rapport',
              ),
              SizedBox(height: height / 36),
              _buildTextField(
                controller: _commentController,
                label: 'Commentaire',
                hint: 'Fournissez des détails supplémentaires',
                maxLines: 5,
              ),
              SizedBox(height: height / 36),
              _buildDropdown(),
              if (_selectedTarget != 'ADMIN') ...[
                SizedBox(height: height / 36),
                _buildPersonDropdown(),
              ],
              SizedBox(height: height / 26),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: hsSemiBold.copyWith(fontSize: 17, color: Colors.blue[800])
        ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: hsMedium.copyWith(fontSize: 16, color:Colors.black),
          decoration: InputDecoration(
              hintStyle:
                  hsMedium.copyWith(fontSize: 16, color: DailozColor.textgray),
              hintText: hint,
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: DailozColor.greyy))),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cible",
            style:
                hsSemiBold.copyWith(fontSize: 14, color: Colors.blue[800])),
        DropdownButtonFormField<String>(
          value: _selectedTarget,
          style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black),
          decoration: InputDecoration(
              hintStyle:
                  hsMedium.copyWith(fontSize: 16, color: DailozColor.textgray),
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: DailozColor.greyy))),
          onChanged: _onTargetChanged,
          items: <String>['ADMIN', 'TEACHER', 'STUDENT']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value == 'ADMIN'
                  ? 'Admin'
                  : value == 'TEACHER'
                      ? 'Coach'
                      : value == 'STUDENT'
                          ? 'Adhérent'
                          : 'Inconnu'),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPersonDropdown() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_userList.isEmpty) {
      return Text('Aucune personne disponible pour la cible sélectionnée.');
    }

    // Get the current user
    final currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;

    // Filter out the current user from the list
    final filteredUserList = _userList.where((user) => user['id'] != currentUser?.id).toList();

    if (filteredUserList.isEmpty) {
      return Text('Aucune autre personne disponible pour la cible sélectionnée.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Personne",
            style: hsSemiBold.copyWith(fontSize: 14, color: Colors.blue[800])),
        DropdownButtonFormField<String>(
          value: _selectedPerson,
          style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black),
          decoration: InputDecoration(
              hintStyle: hsMedium.copyWith(fontSize: 16, color: DailozColor.textgray),
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: DailozColor.greyy))),
          onChanged: (String? newValue) {
            setState(() {
              _selectedPerson = newValue;
            });
          },
          items: filteredUserList.map<DropdownMenuItem<String>>((user) {
            return DropdownMenuItem<String>(
              value: user['id'],
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user['profilePicture'] ?? ''),
                    radius: 16,
                  ),
                  SizedBox(width: 8),
                  Text(user['name'] ?? 'Inconnu'),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  Widget _buildSubmitButton() {
    return InkWell(
      splashColor: DailozColor.transparent,
      highlightColor: DailozColor.transparent,
      onTap: _submitReport,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
            color: DailozColor.appcolor,
            borderRadius: BorderRadius.circular(14)),
        child: Center(
          child: Text(
            "Envoyer",
            style: hsSemiBold.copyWith(fontSize: 16, color: DailozColor.white),
          ),
        ),
      ),
    );
  }
}
