import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SsoOptionsWidget extends StatelessWidget {
  final Function(String provider) onSsoLogin;
  final bool isLoading;

  const SsoOptionsWidget({
    Key? key,
    required this.onSsoLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // SSO Options
        Column(
          children: [
            // Google Workspace SSO
            _buildSsoButton(
              context: context,
              provider: 'Google Workspace',
              iconName: 'account_circle',
              onTap: () => onSsoLogin('google'),
              backgroundColor: Colors.white,
              textColor: AppTheme.lightTheme.colorScheme.onSurface,
              borderColor: AppTheme.lightTheme.colorScheme.outline,
            ),

            SizedBox(height: 2.h),

            // Microsoft 365 SSO
            _buildSsoButton(
              context: context,
              provider: 'Microsoft 365',
              iconName: 'business',
              onTap: () => onSsoLogin('microsoft'),
              backgroundColor: Color(0xFF0078D4),
              textColor: Colors.white,
              borderColor: Color(0xFF0078D4),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSsoButton({
    required BuildContext context,
    required String provider,
    required String iconName,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: textColor,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Continue with $provider',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
