import 'package:flutter/material.dart';

class InforCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  const InforCard({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0)],
      ),
      child: child,
    );
  }
}
