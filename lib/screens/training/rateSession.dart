import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sportdivers/models/session.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/TrainingSchedule/trainingScheduleProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

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
          color: DailozColor.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Évaluer la Séance',
                  style: hsBold.copyWith(
                    fontSize: 22,
                    color: DailozColor.black,
                  ),
                ),
                const SizedBox(height: 16),
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
                  style: hsRegular,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: DailozColor.appcolor, width: 2.0),
                    ),
                    labelText: 'Commentaire',
                    labelStyle: hsMedium.copyWith(color: DailozColor.appcolor),
                    hintText: 'Partagez vos impressions...',
                    hintStyle: hsLight.copyWith(color: DailozColor.grey),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _isLoading
                        ? Center(child: CircularProgressIndicator(color: DailozColor.appcolor))
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DailozColor.appcolor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () => _submitRating(context),
                      child: Text(
                        'Soumettre',
                        style: hsMedium.copyWith(
                          color: DailozColor.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Annuler',
                        style: hsRegular.copyWith(
                          color: DailozColor.grey,
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

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

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
        backgroundColor: DailozColor.appcolor,
        textColor: DailozColor.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Échec de la soumission de l\'évaluation. Erreur : $e');

      Fluttertoast.showToast(
        msg: "Échec de la soumission de l'évaluation. Veuillez réessayer.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: DailozColor.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}