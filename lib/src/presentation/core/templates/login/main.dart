import 'package:flutter/material.dart';
import '../../ui/loading/main.dart';

class LoginTemplate extends StatelessWidget {
  const LoginTemplate({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          const Expanded(
            flex: 0,
            child: Loading()
          ),
          Expanded(
            flex: 1,
            child: child
          )
        ],
      ),
    );
  }
}