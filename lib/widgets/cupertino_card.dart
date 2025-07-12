import 'package:flutter/cupertino.dart';

class CupertinoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;

  const CupertinoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor =
        backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Color.fromRGBO(
                  100,
                  100,
                  111,
                  0.2,
                ), // rgba(100, 100, 111, 0.2)
                offset: Offset(0, 7), // 0px 7px
                blurRadius: 29, // 29px blur
                spreadRadius: 0, // 0px spread
              ),
            ],
      ),
      child: child,
    );
  }
}
