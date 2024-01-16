import 'package:flutter/material.dart';

class CustomCueNavigationIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const CustomCueNavigationIcon(
      {Key? key,
      required this.icon,
      required this.onPressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.all(20),
        elevation: 4,
        shadowColor: Colors.black,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(icon, size: 30),
      ),
    );
  }
}
