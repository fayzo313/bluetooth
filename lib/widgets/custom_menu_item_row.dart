import 'package:bluetooth/constants/colors.dart';
import 'package:bluetooth/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemRow extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const MenuItemRow({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(iconPath, width: 24.w, height: 24.h),
              ),
            ),
            SizedBox(width: 16.w),
            // Title text
            Expanded(
              child: Text(
                title,
                style: TextStyles.headingC.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ),
            // Chevron icon
            const Icon(
              Icons.chevron_right,
              color: AppColors.blackColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
