import 'package:conferance_application/config/constant/apiendpoints.dart';
import 'package:flutter/material.dart';

class ConstantStatic{
  // Environment flags
  static bool isUat = false;
  static bool isDarkMode = false;
  static bool isByPassMobileOtp = false;
  static bool isByPassEmailOtp = false;
  static bool isFromUSEquity = false;

  // Dynamic widget screens
  static Widget? pageName;
  static Widget? landingPageName;
  static Widget? loginPageName;

  // API URLs (auto computed)
  static String get baseUrl =>
      isUat ? ApiEndpoints.uatbaseUrl : ApiEndpoints.pilotEndPoint;

}