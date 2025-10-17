import 'package:flutter/material.dart';
import 'package:labs/src/presentation/core/ui/loading/main.dart';

class CustomFloatingAppBar extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final List<Widget> actions;
  final double height;

  const CustomFloatingAppBar({
    super.key,
    this.leading,
    required this.title,
    this.actions = const [],
    this.height = 95.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Card(
              margin: const EdgeInsetsDirectional.all(0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (leading != null) leading!,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: title,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Loading(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
