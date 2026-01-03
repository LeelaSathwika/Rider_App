
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BulletText extends StatelessWidget {
  final String text;
  const BulletText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          size: 18,
          color: Color(0xFF3B82F6), // Figma blue
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class BulletText extends StatelessWidget {
//   final String text;
//   final Color color;
//
//   const BulletText({
//     super.key,
//     required this.text,
//     this.color = const Color(0xFF2F80ED),
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(Icons.check, size: 18, color: color),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(fontSize: 15, height: 1.4),
//           ),
//         ),
//       ],
//     );
//   }
// }