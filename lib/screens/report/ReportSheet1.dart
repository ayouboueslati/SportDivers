import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/Provider/ReportPorivder/ticketProvider.dart';
import 'package:footballproject/models/studentProfile.dart';
import 'package:footballproject/models/teacherProfile.dart';

class ReportPage extends StatefulWidget {
  static const String id = 'Report_Page';

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _reasonController = TextEditingController();
  final _commentController = TextEditingController();
  String _selectedTarget = 'ADMIN';
  String? _selectedPerson;
  List<StudentProfile> _students = [];
  List<TeacherProfile> _teachers = [];

  @override
  void dispose() {
    _reasonController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_reasonController.text.isNotEmpty &&
        _commentController.text.isNotEmpty) {
      final reason = _reasonController.text;
      final comment = _commentController.text;

      Provider.of<TicketsProvider>(context, listen: false)
          .submitReport(
        reason: reason,
        comment: comment,
        target: _selectedTarget,
        person: _selectedPerson ?? '',
      )
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _reasonController.clear();
        _commentController.clear();
        setState(() {
          _selectedTarget = 'ADMIN';
          _selectedPerson = null;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields before submitting.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onTargetChanged(String? newValue) {
    setState(() {
      _selectedTarget = newValue!;
      _selectedPerson = null; // Clear selected person when target changes
    });
    _fetchPersons();
  }

  Future<void> _fetchPersons() async {
    final ticketsProvider =
        Provider.of<TicketsProvider>(context, listen: false);
    try {
      if (_selectedTarget == 'STUDENT') {
        _students = await ticketsProvider.fetchStudents();
        print('Fetched Students Data: $_students');
      } else if (_selectedTarget == 'TEACHER') {
        _teachers = await ticketsProvider.fetchTeachers();
        print('Fetched Teachers Data: $_teachers');
      }
      setState(() {}); // Update the UI
    } catch (e) {
      debugPrint('Error fetching persons: $e');
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
            'Submit a Report',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                ),
                SizedBox(height: 24.0),
                _buildTextField(
                  controller: _reasonController,
                  label: 'Reason',
                  hint: 'Enter the reason for your report',
                ),
                SizedBox(height: 16.0),
                _buildTextField(
                  controller: _commentController,
                  label: 'Comment',
                  hint: 'Provide additional details',
                  maxLines: 5,
                ),
                SizedBox(height: 16.0),
                _buildDropdown(),
                if (_selectedTarget != 'ADMIN') ...[
                  SizedBox(height: 16.0),
                  _buildPersonDropdown(),
                ],
                SizedBox(height: 32.0),
                _buildSubmitButton(),
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
        labelText: 'Target',
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
      items: <String>['ADMIN', 'TEACHER', 'STUDENT']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildPersonDropdown() {
    final List<String> persons = _selectedTarget == 'STUDENT'
        ? _students.map((e) => e.firstName).toList()
        : _teachers.map((e) => e.firstName).toList();

    // Ensure that _selectedPerson is one of the values in the list
    if (_selectedPerson != null && !persons.contains(_selectedPerson)) {
      _selectedPerson = null; // Reset if it's not in the list
    }

    if (persons.isEmpty) {
      return Text('No persons available for the selected target.');
    }
    print('Persons List: $persons');
    print('Selected Person: $_selectedPerson');

    return DropdownButtonFormField<String>(
      value: _selectedPerson,
      decoration: InputDecoration(
        labelText: 'Person',
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
      onChanged: (newValue) {
        setState(() {
          _selectedPerson = newValue;
        });
      },
      items: persons.isNotEmpty
          ? persons.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()
          : [], // Return an empty list if no persons
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitReport,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: Colors.blue[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text('Submit Report'),
      ),
    );
  }
}
