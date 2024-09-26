import 'package:sportdivers/models/sessionTypes.dart';

String translateSessionType(Sessiontypes type) {
  switch (type) {
    case Sessiontypes.FRIENDLY_GAME:
      return 'MATCH AMICAL';
    case Sessiontypes.TRAINING_SESSION:
      return 'SÉANCE D\'ENTRAÎNEMENT';
    case Sessiontypes.TOURNAMENT:
      return 'TOURNOI';
    default:
      return 'TYPE INCONNU';
  }
}