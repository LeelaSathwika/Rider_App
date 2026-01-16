import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

// ==========================================
// 1. THE EXACT SHARP BLUE TICK (18x18)
// ==========================================
class ExactBlueTick extends StatelessWidget {
  final double size;
  const ExactBlueTick({super.key, this.size = 18}); 

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1, 
      child: CustomPaint(
        size: Size(size, size), 
        painter: _TickPainter(),
      ),
    );
  }
}

class _TickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8 
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter; 

    final path = Path();
    path.moveTo(size.width * 0.05, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.85);
    path.lineTo(size.width * 0.95, size.height * 0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// 2. SHARED LOGO HEADER
// ==========================================
Widget buildLogoHeader({bool showBack = false, VoidCallback? onBack}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
    child: SizedBox(
      height: 40, // Fixed height for consistency
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showBack)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: onBack,
              ),
            ),
          // Logo centered
          RichText(
            text: TextSpan(
              style: GoogleFonts.playfairDisplay(
                fontSize: 28, 
                fontWeight: FontWeight.bold, 
                letterSpacing: 1.2,
                color: const Color(0xFF2E3E5C), // Default color
              ),
              children: [
                const TextSpan(text: 'NEXO'),
                TextSpan(
                  text: 'RYD', 
                  style: TextStyle(color: AppColors.primaryBlue)
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// ==========================================
// 3. SHARED PRIMARY BUTTON
// ==========================================
Widget buildPrimaryButton({required String text, required VoidCallback onPressed}) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 18, 
          fontWeight: FontWeight.bold
        ),
      ),
    ),
  );
}

// ==========================================
// 4. SHARED FOOTER LINKS
// ==========================================
Widget buildFooterLinks() {
  return Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(fontSize: 12, color: AppColors.textGray, height: 1.5),
        children: [
          TextSpan(text: "By continuing, you agree to our "),
          TextSpan(
            text: "Terms of Service", 
            style: TextStyle(
              color: AppColors.primaryBlue, 
              decoration: TextDecoration.underline
            )
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Privacy Policy", 
            style: TextStyle(
              color: AppColors.primaryBlue, 
              decoration: TextDecoration.underline
            )
          ),
        ],
      ),
    ),
  );
}