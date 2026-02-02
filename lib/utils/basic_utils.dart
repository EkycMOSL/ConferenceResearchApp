import 'dart:convert';
import 'dart:io';
import 'package:conferance_application/config/constant/stringsutils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

RegExp nameRex = RegExp(r"^[a-zA-Z]{1,}(?: [a-zA-Z]+){0,4}$");
final RegExp phoneRegex = RegExp(r"^\d{10}");
RegExp emailRex =  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
bool isBankImageSelectedForUpload = false;

String getDeviceType() {
  return Platform.isIOS ? iOS : android;
}

String getAppName() {
  return Platform.isIOS ? appNameIos : appNameAndroid;
}

Future<bool> hasInternetConnection() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}

List<TextInputFormatter> nameInputFilters() {
  return [
    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
    FilteringTextInputFormatter.deny(
      RegExp(r'^ +'), //users can't type SPACE at 1st position
    ),
  ];
}
List<TextInputFormatter> nameNumberInputFilters() {
  return [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]'))];
}
List<TextInputFormatter> mobileNumberInputFilters() {
  return [
    FilteringTextInputFormatter.digitsOnly,
    FilteringTextInputFormatter.deny(
      RegExp(r'^0+'), //users can't type 0 at 1st position
    )
  ];
}
/*
Future<UserData> getUserData() async {
  late InitApiResponse initApiResponse;
  Map<String, dynamic> userMap = jsonDecode(
      await LocalStorage.getString(LocalStorageKeyName.userData) ?? "");
  initApiResponse = InitApiResponse.fromJson(userMap);
  return initApiResponse.data?.firstOrNull ?? UserData();
}
*/


Future<String?> getDeviceId() async {
  final _deviceUuidPlugin = MobileDeviceIdentifier();
  String uuid = 'Unknown';
  try {
    uuid = await _deviceUuidPlugin.getDeviceId() ?? 'Unknown uuid version';
  } on PlatformException {
    uuid = 'Failed to get uuid version.';
  }
  return uuid;
}

Future<String?> getIp() async {
  String deviceIpAddress = "";
  try {
    /// Initialize Ip Address
    var ipAddress = IpAddress(type: RequestType.text);

    /// Get the IpAddress based on requestType.
    dynamic data = await ipAddress.getIpAddress();
    deviceIpAddress = data.toString();
  } on IpAddressException catch (exception) {
    /// Handle the exception.
    deviceIpAddress = "";
  }
  return deviceIpAddress;
}

