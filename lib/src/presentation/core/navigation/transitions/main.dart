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
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    child: Scaffold(
      body: Row(
        children: [
          Expanded(child: Container()), // Espacio para el contenido principal
          SizedBox(
            width: 400, // Ancho de la barra lateral
            child: Material(
              child: child,
            ),
          ),
        ],
      ),
    ),
  );
}