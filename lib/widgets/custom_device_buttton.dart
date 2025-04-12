import 'package:bluetooth/constants/colors.dart';
import 'package:bluetooth/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeviceButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isFilled;
  final VoidCallback onPressed;

  const DeviceButton({
    super.key,
    required this.text,
    required this.icon,
    required this.isFilled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isFilled ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border:
              isFilled
                  ? null
                  : Border.all(color: AppColors.primaryColor, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isFilled ? AppColors.whiteColor : AppColors.primaryColor,
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyles.headingC.copyWith(
                color: isFilled ? AppColors.whiteColor : AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
