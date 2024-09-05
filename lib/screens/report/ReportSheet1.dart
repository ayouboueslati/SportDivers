import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/Provider/ReportPorivder/ticketProvider.dart';


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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rapport soumis avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        _reasonController.clear();
        _commentController.clear();
        setState(() {
          _selectedTarget = 'ADMIN';
          _selectedPerson = null;
          _userList.clear();
        });
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
        SnackBar(
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            'Réclamation',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Détails du Rapport',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                ),
                const SizedBox(height: 24.0),
                _buildTextField(
                  controller: _reasonController,
                  label: 'Raison',
                  hint: 'Entrez la raison de votre rapport',
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  controller: _commentController,
                  label: 'Commentaire',
                  hint: 'Fournissez des détails supplémentaires',
                  maxLines: 5,
                ),
                const SizedBox(height: 16.0),
                _buildDropdown(),
                if (_selectedTarget != 'ADMIN') ...[
                  SizedBox(height: 16.0),
                  _buildPersonDropdown(),
                ],
                const SizedBox(height: 60),
                Center(
                 child:  _buildSubmitButton(),
                ),
              ],
            ),
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
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[900]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTarget,
      decoration: InputDecoration(
        labelText: 'Cible',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[900]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: _onTargetChanged,
      items: <String>['ADMIN', 'COACH', 'STUDENT']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value == 'ADMIN' ? 'Admin' :
          value == 'COACH' ? 'Coach' :
          value == 'STUDENT' ? 'Adhérent' : 'Inconnu'),
        );
      }).toList(),
    );
  }

  Widget _buildPersonDropdown() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_userList.isEmpty) {
      return Text('Aucune personne disponible pour la cible sélectionnée.');
    }

    return DropdownButtonFormField<String>(
      value: _selectedPerson,
      decoration: InputDecoration(
        labelText: 'Personne',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[900]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPerson = newValue;
        });
      },
      items: _userList.map<DropdownMenuItem<String>>((user) {
        return DropdownMenuItem<String>(
          value: user['name'],
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
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitReport,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[900],
        padding:const EdgeInsets.symmetric(vertical: 13.0,horizontal: 30.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Envoyer',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
