import 'package:flutter/cupertino.dart';

class Validator {
  String? valid_email(String val) {
    if (val.trim().isEmpty) {
      return 'add a correct email';
    }
    if (val.trim().length < 4) {
      return 'add a correct email';
    }
    if (val.trim().length > 20) {
      return 'add a short  email';
    }
    RegExp regexp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (!regexp.hasMatch(val)) {
      return 'add a correct email (exemple@gmail.com)';
    }
    return null;
  }

  String? validUser_password(String val) {
    if (val.trim().isEmpty) {
      return 'enter password';
    }
    return null;
  }

  String? validUser_conferme_password(
      String val, TextEditingController password) {
    if (val.trim().isEmpty) {
      return 'enter password';
    }
    if (val != password.text) return 'Confermer password';
    return null;
  }

  String? valide_phone(String val) {
    if (val.trim().isEmpty) {
      return 'enter phone 1Number';
    }
    if (val.trim().length < 9 && val.trim().length > 10) {
      return "add correct2 phone";
    }
    final phoneRegExp = RegExp(r"[0-9]{10}$");

    if (!phoneRegExp.hasMatch(val)) {
      return "add correct3 phone";
    }
    return null;
  }

  String? validatelastname(String val) {
    if (val.trim().isEmpty) {
      return 'add a correct  name';
    }
    if (val.trim().length < 4) {
      return 'add a correct  name';
    }
    return null;
  }

  String? validatename(String val) {
    if (val.trim().isEmpty) {
      return 'add a correct  name';
    }
    if (val.trim().length < 4) {
      return 'add a correct  name';
    }
    return null;
  }
}
