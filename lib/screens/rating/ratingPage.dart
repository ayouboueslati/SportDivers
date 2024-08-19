import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  static const String id = 'Rating_Page';

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 0;
  String _feedbackCoach = '';
  String _feedbackLogistics = '';
  String _feedbackAdministration = '';

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
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Evaluate The Session',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30,),
                    Text(
                      'How was your experience ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating.floor() ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 40,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your rating: ${_rating.toStringAsFixed(1)}',
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildFeedbackField(
                      label: 'Feedback for Coach',
                      onSave: (value) => _feedbackCoach = value!,
                    ),
                    const SizedBox(height: 20),
                    _buildFeedbackField(
                      label: 'Feedback for Logistics',
                      onSave: (value) => _feedbackLogistics = value!,
                    ),
                    const SizedBox(height: 20),
                    _buildFeedbackField(
                      label: 'Feedback for Administration',
                      onSave: (value) => _feedbackAdministration = value!,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5,
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackField({required String label, required Function(String?) onSave}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle:  TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:  BorderSide(color: Colors.blue[900]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:  BorderSide(color: Colors.blue[900]!),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      maxLines: 2,
      onSaved: onSave,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your feedback!';
        }
        return null;
      },
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you would typically send the feedback data to your backend
      print('Rating: $_rating');
      print('Coach Feedback: $_feedbackCoach');
      print('Logistics Feedback: $_feedbackLogistics');
      print('Administration Feedback: $_feedbackAdministration');

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('THANKS !'),
            content: const Text('Your review has been successfully submitted.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // You might want to navigate back to the main screen here
                },
              ),
            ],
          );
        },
      );
    }
  }
}
