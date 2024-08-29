import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:footballproject/models/session.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/Provider/TrainingSchedule/trainingScheduleProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RateSessionDialog extends StatefulWidget {
  static String id = 'rate_screen';
  final Session session; // Changed from sessionId to Session
  final DateTime sessionDate;

  RateSessionDialog(
      {required this.session,
      required this.sessionDate}); // Updated constructor

  @override
  _RateSessionDialogState createState() => _RateSessionDialogState();
}

class _RateSessionDialogState extends State<RateSessionDialog> {
  double _rating = 3;
  TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Rate Session',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Rate this session:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  labelText: 'Comment',
                  labelStyle: TextStyle(color: Colors.orange),
                  hintText: 'Share your thoughts...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () => _submitRating(context),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRating(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);

    try {
      // Extract session date from the session object

      await sessionProvider.submitRating(
        rating: _rating,
        comment: _commentController.text.isEmpty ? '' : _commentController.text,
        sessionId: widget.session.id,
        context: context,
        sessionDate: widget.sessionDate,
      );

      Fluttertoast.showToast(
        msg: "Rating submitted successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigator.of(context).pop({
      //   'rating': _rating,
      //   'comment': _commentController.text,
      // });
    } catch (e) {
      print('Failed to submit rating. Error: $e');

      Fluttertoast.showToast(
        msg: "Failed to submit rating. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
