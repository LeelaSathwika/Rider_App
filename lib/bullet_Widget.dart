

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BulletText extends StatelessWidget {
  final String text;
  final Color color;

  const BulletText({
    super.key,
    required this.text,
    this.color = const Color(0xFF2F80ED),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, size: 18, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ),
      ],
    );
  }
}