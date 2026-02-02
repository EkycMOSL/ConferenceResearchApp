import 'package:flutter/material.dart';

///use for font Size
const double size1 = 1;
const double size2 = 2;
const double size3 = 3;
const double size4 = 4;
const double size5 = 5;
const double size6 = 6;
const double size7 = 7;
const double size8 = 8;
const double size9 = 9;
const double size10 = 10;
const double size11 = 11;
const double size12 = 12;
const double size13 = 13;
const double size14 = 14;
const double size15 = 15;
const double size16 = 16;
const double size17 = 17;
const double size24 = 24;
const double size18 = 18;
const double size19 = 19;
const double size20 = 20;
const double size21 = 21;
const double size22 = 21;
const double size23 = 23;
const double size25 = 25;
const double size26 = 26;
const double size27 = 27;
const double size28 = 28;
const double size29 = 29;
const double size30 = 30;
const double size32 = 32;

const double bottomViewSize = 130;
const double bottomViewSizeSmall = 100;
const double buttonSize = 45;
const double buttonSizeView = 90;
const double uploadButtonSize = 55;
const double uploadButtonRadius= 10;
const double tableSelectorHeight = 393;
const double tableHeight = 373;


Size size =
    WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio;



///This method is used to get device viewport width.
get width {
  return size.width;
}

///This method is used to get device viewport height.
get height {
  num statusBar = MediaQueryData.fromView(WidgetsBinding.instance.window).viewPadding.top;
  num screenHeight = size.height - statusBar;
  return screenHeight;
}

///This method is used to set padding responsively
EdgeInsetsGeometry getPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

///This method is used to get padding or margin responsively
EdgeInsetsGeometry getMarginOrPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return EdgeInsets.only(
      left: left ?? 0,
      top: top ?? 0,
      right: right ?? 0,
      bottom: bottom ?? 0
  );
}

EdgeInsetsGeometry padding16 = const EdgeInsets.fromLTRB(16, 16, 16, 16);
EdgeInsetsGeometry padding16pts10 = const EdgeInsets.fromLTRB(16, 10, 10, 16);
EdgeInsetsGeometry paddingOnly2pt5 = const EdgeInsets.only(top: 2.5, bottom: 2.5);
EdgeInsetsGeometry paddingOnly20 = const EdgeInsets.only(top: 20);
EdgeInsetsGeometry padding59LR = const EdgeInsets.fromLTRB(20, 0, 20, 0);
