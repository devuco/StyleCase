import 'package:flutter/material.dart';
import 'package:stylecase/theme/app_colors.dart';

enum ButtonWidth { full, fit }

class Button extends StatelessWidget {
  final String title;
  final Function() onTap;
  final EdgeInsets? margin;
  final ButtonWidth? width;
  final bool isLoading;

  const Button(
      {super.key,
      required this.title,
      required this.onTap,
      this.margin,
      this.width,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width == ButtonWidth.full ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        margin: margin,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(AppColors.primary)),
        child: !isLoading
            ? Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5),
              )
            : const Center(
                child: SizedBox(
                  height: 17,
                  width: 17,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
      ),
    );
  }
}
