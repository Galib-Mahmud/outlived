import 'package:flutter/material.dart';


class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const trackWidth = 48.0;
    const trackHeight = 18.0;
    const thumbSize = 28.0;
    const trackColor = Color(0xFF6B7280);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: trackWidth + (thumbSize - trackHeight), // extra space for overflow
        height: thumbSize, // height = thumb size so it doesn't clip
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Track — vertically centered
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: trackWidth,
                height: trackHeight,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(trackHeight / 2),
                ),
              ),
            ),
            // Thumb — bigger, overflows track top & bottom
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? trackWidth - thumbSize : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: trackColor,
                    width: 3.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}