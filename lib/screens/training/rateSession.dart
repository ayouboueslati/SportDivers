import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sportdivers/models/session.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/TrainingSchedule/trainingScheduleProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RateSessionDialog extends StatefulWidget {
  static String id = 'rate_screen';
  final Session session;
  final DateTime sessionDate;

  RateSessionDialog({required this.session, required this.sessionDate});

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
          child: Center(
            // Added Center here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              // Centered contents
              children: <Widget>[
                const Text(
                  'Évaluer la Séance',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Text(
                //   'Évaluez cette séance :',
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: Colors.black54,
                //   ),
                // ),
                // SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.yellow[600],
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
                      borderSide:
                          BorderSide(color: Colors.blue[900]!, width: 2.0),
                    ),
                    labelText: 'Commentaire',
                    labelStyle: TextStyle(color: Colors.blue[900]),
                    hintText: 'Partagez vos impressions...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              padding:const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () => _submitRating(context),
                            child: const Text(
                              'Soumettre',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Annuler',
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
      await sessionProvider.submitRating(
        rating: _rating,
        comment: _commentController.text.isEmpty ? '' : _commentController.text,
        sessionId: widget.session.id,
        context: context,
        sessionDate: widget.sessionDate,
      );

      Fluttertoast.showToast(
        msg: "Évaluation soumise avec succès !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue[900],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Échec de la soumission de l\'évaluation. Erreur : $e');

      Fluttertoast.showToast(
        msg: "Échec de la soumission de l'évaluation. Veuillez réessayer.",
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
