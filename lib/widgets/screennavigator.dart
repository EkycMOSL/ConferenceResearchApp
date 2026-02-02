import 'package:flutter/material.dart';

class ScreenNavigator {
  final BuildContext cx;
  ScreenNavigator({
    required this.cx,
  });
  navigate(Widget page, Tween<Offset> tween) {
    Future.delayed(const Duration(milliseconds: 50),(){
      Navigator.pushReplacement(
        cx,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return page;
          },
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // create CurveTween
            const Curve curve = Curves.ease;
            final CurveTween curveTween = CurveTween(curve: curve);
            // chain Tween with CurveTween
            final Animatable<Offset> chainedTween = tween.chain(curveTween);
            final Animation<Offset> offsetAnimation =
            animation.drive(chainedTween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    });

  }
}

class NavigatorTween {
  static Tween<Offset> bottomToTop() {
    const Offset begin = Offset(0.0, 1.0);
    const Offset end = Offset(0.0, 0.0);
    return Tween(begin: begin, end: end);
  }

  static Tween<Offset> topToBottom() {
    const Offset begin = Offset(0.0, -1.0);
    const Offset end = Offset(0.0, 0.0);
    return Tween(begin: begin, end: end);
  }

  static Tween<Offset> leftToRight() {
    const Offset begin = Offset(-1.0, 0.0);
    const Offset end = Offset(0.0, 0.0);
    return Tween(begin: begin, end: end);
  }

  static Tween<Offset> rightToLeft() {
    const Offset begin = Offset(1.0, 0.0);
    const Offset end = Offset(0.0, 0.0);
    return Tween(begin: begin, end: end);
  }
}