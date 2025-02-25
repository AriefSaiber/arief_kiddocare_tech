import 'package:flutter/material.dart';

class Constants {
  static const Color primaryColor = Color(0xff4FC3F7);
  // static const Color secondaryColor = Color(0xff4FC3F7);
}

class Screen {
  static W(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static H(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
