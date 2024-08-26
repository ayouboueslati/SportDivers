import 'package:flutter/material.dart';
import 'package:footballproject/Provider/ReportPorivder/ticketProvider.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  static const String id = 'Report_Page';
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _reasonController = TextEditingController();
  final _commentController = TextEditingController();
  String _selectedTarget = 'ADMIN';

  @override
  void dispose() {
    _reasonController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // void _submitReport() {
  //   if (_reasonController.text.isNotEmpty &&
  //       _commentController.text.isNotEmpty) {
  //     final reason = _reasonController.text;
  //     final comment = _commentController.text;

  //     print(
  //         'Submitting report with reason: $reason, comment: $comment, target: $_selectedTarget');

  //     Provider.of<TicketProvider>(context, listen: false)
  //         .createTicket(context, reason, comment, _selectedTarget)
  //         .then((_) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Report submitted successfully'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //       _reasonController.clear();
  //       _commentController.clear();
  //     }).catchError((error) {
  //       print('Failed to submit report: $error');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Failed to submit report: $error'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     });
  //   } else {
  //     print('Please fill in all fields before submitting.');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Please fill in all fields before submitting.'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //   }
  // }

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
                SizedBox(height: 32.0),
                // _buildSubmitButton(),
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
      onChanged: (newValue) {
        setState(() {
          _selectedTarget = newValue!;
        });
      },
      items: <String>['ADMIN', 'clyv28fbj0001u3d4jwdok2zk']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
