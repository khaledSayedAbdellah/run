import 'package:flutter_map_booking/Model/user_trip.dart';
import 'package:flutter_map_booking/localization/app_localization.dart';

localize(context, key) {
  return AppLocalizations.of(context).translate(key);
}

String selectedTaxiType = "0";

int currentTripID = 0;

UserTrip CURRENT_TRIP = UserTrip();
