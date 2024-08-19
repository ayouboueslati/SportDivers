import 'package:flutter/material.dart';
import 'package:footballproject/Provider/ReportPorivder/ticketProvider.dart';
import 'package:provider/provider.dart';

class ReportSheet extends StatefulWidget {
  @override
  _ReportSheetState createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  final _reasonController = TextEditingController();
  final _commentController = TextEditingController();
  String _selectedTarget = 'ADMIN';

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

      print('Submitting report with reason: $reason, comment: $comment, target: $_selectedTarget');

      Provider.of<TicketProvider>(context, listen: false)
          .createTicket(context, reason, comment, _selectedTarget)
          .then((_) {
        Navigator.of(context).pop();
      }).catchError((error) {
        print('Failed to submit report: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $error')),
        );
      });
    } else {
      print('Please fill in all fields before submitting.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields before submitting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submit a Report',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Reason',
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Comment',
            ),
          ),
          SizedBox(height: 8.0),
          DropdownButton<String>(
            value: _selectedTarget,
            onChanged: (newValue) {
              setState(() {
                _selectedTarget = newValue!;
              });
            },
            items: <String>[
              'ADMIN',
              'clyv28fbj0001u3d4jwdok2zk'
            ] // Add other user IDs as needed
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _submitReport,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
