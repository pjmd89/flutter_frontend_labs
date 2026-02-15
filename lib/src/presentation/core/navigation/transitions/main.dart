import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSidebarPage extends CustomTransitionPage {
  CustomSidebarPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) : super(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    child: Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 400,
        height: double.infinity,
        child: Material(
          child: child,
        ),
      ),
    ),
  );
}