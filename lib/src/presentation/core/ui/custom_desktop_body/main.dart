import 'package:flutter/material.dart';

class CustomDesktopBody extends StatelessWidget {
  final Widget? header;
  final Widget? childWidget;
  final Widget? footer;
  final VoidCallback? onRefresh;
  
  const CustomDesktopBody({
    super.key,
    this.header,
    this.childWidget,
    this.footer,
    this.onRefresh,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 0,
            child: header ?? const SizedBox(),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: childWidget ?? const SizedBox(),
            ),
          ),
          Flexible(
            flex: 0,
            child: footer ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
