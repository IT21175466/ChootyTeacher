import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

class PhoneValidationProvider extends ChangeNotifier {
  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;

  selectCountry(BuildContext context) async {
    countryCode = await countryPicker.showPicker(context: context);
    notifyListeners();
  }
}
