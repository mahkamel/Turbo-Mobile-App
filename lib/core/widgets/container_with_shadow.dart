import 'package:flutter/material.dart';

import '../theming/colors.dart';

class DefaultContainerWithInnerShadow extends StatelessWidget {
  const DefaultContainerWithInnerShadow({
    super.key,
    required this.child,
    this.marginRight = 0.0,
    this.marginLeft = 0.0,
    this.marginTop = 0.0,
    this.marginBottom = 0.0,
    this.height = 48,
    this.width,
    this.color,
    this.borderColor = AppColors.greyBorder,
  });
  final Widget child;
  final double marginRight;
  final double marginLeft;
  final double marginTop;
  final double marginBottom;
  final double height;
  final double? width;
  final Color? color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsetsDirectional.only(
        start: marginRight,
        end: marginLeft,
        top: marginTop,
        bottom: marginBottom,
      ),
      // padding: const EdgeInsetsDirectional.only(top: 4),
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black800.withOpacity(0.16),
          ),
          const BoxShadow(
            color:  AppColors.white,
            spreadRadius:-2.0,
            blurRadius: 2.0,
            offset: Offset(1, 1),
          ),
        ]
      ),
      child: child,
    );
  }
}

class DefaultContainerWithShadow extends StatelessWidget {
  const DefaultContainerWithShadow({
    super.key,
    required this.child,
    this.marginStart = 0.0,
    this.marginEnd = 0.0,
    this.marginTop = 0.0,
    this.marginBottom = 0.0,
    this.height = 90,
    this.width,
    this.radius = 4,
    this.color,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.constraints,
    this.isHeightNull = false,
  });
  final Widget child;
  final double marginStart;
  final double marginEnd;
  final double marginTop;
  final double marginBottom;
  final double height;
  final double? width;
  final double radius;
  final Color? color;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final bool isHeightNull;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
        start: marginStart,
        end: marginEnd,
        top: marginTop,
        bottom: marginBottom,
      ),
      padding: padding,
      height: isHeightNull ? null : height,
      width: width ?? double.infinity,
      constraints: constraints,
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 4),
            color: AppColors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: child,
    );
  }
}
