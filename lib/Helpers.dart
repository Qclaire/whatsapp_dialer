// import 'package:url_launcher/url_launcher.dart';

import 'package:country_code_picker/country_code_picker.dart';

bool isValidPhoneNumber(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

// _dialNumber(_number)async{
//   var urlToLaunch = _number.length == 10 && _number[0] == "0" ?
//   "http://wa.me/233${_number.substring(1)}" :
//   "http://wa.me/$_number";
//
//   String error;
//
//   if (_number.length < 10) error = "${_number.length} digits; You need at least 10";
//   else if (_number.length == 10 && _number[0] != "0") error = "Invalid number";
//   else if(!await canLaunch(urlToLaunch)) error = "Sorry we couldn't open your number";
//   if(error != null) setState(() { msg = error;});
//   else launch(urlToLaunch);
// }

