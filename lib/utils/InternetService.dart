import 'dart:async';
import 'package:conferance_application/config/constant/assetspath.dart';
import 'package:conferance_application/config/constant/colorsutils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
class InternetService {
  static final InternetService _instance = InternetService._internal();
  factory InternetService() => _instance;
  InternetService._internal();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final GlobalKey<NavigatorState> _navigatorKey =
  GlobalKey<NavigatorState>();

  bool _isDialogShowing = false;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// Call this in main()
  void initialize() {
    _subscription =
        Connectivity().onConnectivityChanged.listen((results) {
          if (results.contains(ConnectivityResult.none)) {
            if (!_isDialogShowing) {
              _showNoInternetSheet();
            }
          } else {
            if (_isDialogShowing) {
              _hideNoInternetSheet();
            }
          }
        });
  }

  void _showNoInternetSheet() {
    if (_navigatorKey.currentContext == null) return;
    _isDialogShowing = true;
    _buildBottomSheet();
  }

  void _hideNoInternetSheet() {
    if (_navigatorKey.currentContext == null) return;

    try {
      Navigator.of(
        _navigatorKey.currentContext!,
        rootNavigator: true,
      ).pop();
    } catch (_) {}

    _isDialogShowing = false;
  }

  void _buildBottomSheet() {
    showModalBottomSheet(
      context: _navigatorKey.currentContext!,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: colorwhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                SizedBox(height: 28),

                /// Lottie animation
                SizedBox(
                  height: 150.h,
                  child: Lottie.asset(
                    AssetsPath.noInternetConnection,
                    repeat: true,
                    animate: true,
                    frameRate: FrameRate.max,
                  ),
                ),

                SizedBox(height: 24),

                /// Title
                Text(
                  "You're offline",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 8),

                /// Description
                Text(
                  "Check your internet connection\nand try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 28),

                /// Retry button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result =
                      await Connectivity().checkConnectivity();
                      if (!result
                          .contains(ConnectivityResult.none)) {
                        _hideNoInternetSheet();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF4A4E9C),
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Try again',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}
