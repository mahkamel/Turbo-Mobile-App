import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helpers/enums.dart';
import '../helpers/functions.dart';
import '../theming/colors.dart';
import '../theming/fonts.dart';

class EmailTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final double marginTop;
  final double marginLeft;
  final double marginRight;
  final double marginBottom;

  // final double validatePadding;
  final String hint;
  final String label;
  final String validateText;
  final bool enabled;
  final bool isWithIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final Function(String value)? onSubmit;
  final Function(String value)? onChange;
  final Function()? onTap;
  final TextCapitalization textCapitalization;
  final TextFieldValidation fieldValidation;
  final Iterable<String>? autofill;
  final Function(PointerDownEvent)? onTapOutside;
  final InputBorder? border;

  const EmailTextField({
    super.key,
    this.focusNode,
    this.marginTop = 0,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    this.autofill,
    this.border,
    this.hint = "example@email.com",
    this.textInputAction = TextInputAction.next,
    // this.validatePadding = 20,
    this.enabled = true,
    this.isWithIcon = true,
    required this.controller,
    this.validateText = 'This email is invalid',
    required this.onSubmit,
    this.textInputType = TextInputType.emailAddress,
    this.onChange,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    required this.fieldValidation,
    this.label = "Email",
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsetsDirectional.only(
              end: marginRight,
              start: marginLeft,
              top: marginTop,
              bottom: marginBottom,
            ),
            padding: const EdgeInsetsDirectional.only(top: 4),
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              minLines: null,
              focusNode: focusNode,
              onChanged: onChange,
              onTapOutside: (pointerDownEvent) {
                onTapOutside;
                FocusManager.instance.primaryFocus?.unfocus();
              },
              autocorrect: false,
              textCapitalization: textCapitalization,
              textInputAction: textInputAction,
              onFieldSubmitted: onSubmit,
              autofillHints: autofill,
              style: AppFonts.ibm14LightBlack400,
              controller: enabled ? controller : TextEditingController(),
              keyboardType: textInputType,
              decoration: InputDecoration(
                prefixIcon: isWithIcon
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SvgPicture.asset(
                          'assets/images/sms.svg',
                          width: 24,
                          height: 24,
                        ),
                      )
                    : null,
                labelText: label,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: AppFonts.ibm14LightBlack400,
                hintText: hint,
                hintStyle: AppFonts.ibm14LightBlack400,
                contentPadding: const EdgeInsetsDirectional.only(
                  start: 16,
                  end: 12,
                ),
                border: border ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.black,
                      ),
                    ),
                focusedBorder: border ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.black,
                      ),
                    ),
                fillColor: AppColors.white,
                enabled: enabled,
                filled: true,
                enabledBorder: (fieldValidation == TextFieldValidation.notValid)
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.errorRed,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : border ??
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.black,
                          ),
                        ),
              ),
            ),
          ),
          if (fieldValidation == TextFieldValidation.notValid)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
                end: 20,
                top: 8,
              ),
              child: Text(
                validateText,
                style: AppFonts.ibm14ErrorRed400,
              ),
            ),
        ],
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextFieldValidation fieldValidation;
  final bool enabled;
  final bool signup;
  final double marginRight;
  final double marginLeft;
  final double marginTop;
  final double marginBottom;
  final String? validateText;
  final String? hintText;
  final Function() onIconPress;
  final Function()? onTextFieldTap;
  final FocusNode? focusNode;
  final String label;
  final double validatePadding;
  final double hintTextSize;
  final bool isObscureText;
  final Function(String value) onSubmit;
  final Function(String value) onChange;
  final Iterable<String>? autofill;
  final IconData suffixIcon;
  final Color suffixIconColor;
  final Function(PointerDownEvent)? onTapOutside;
  final TextInputAction textInputAction;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.fieldValidation,
    required this.onIconPress,
    required this.suffixIcon,
    this.suffixIconColor = AppColors.black,
    this.isObscureText = true,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginTop = 0,
    this.marginBottom = 0,
    this.validateText,
    this.validatePadding = 20,
    this.hintTextSize = 16,
    this.signup = false,
    this.onTextFieldTap,
    this.focusNode,
    this.hintText,
    this.autofill,
    this.label = "Password",
    this.onTapOutside,
    required this.onSubmit,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTextFieldTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsetsDirectional.only(
              start: marginRight,
              end: marginLeft,
              top: marginTop,
              bottom: marginBottom,
            ),
            // padding: const EdgeInsetsDirectional.only(top: 4),
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              focusNode: focusNode,
              onChanged: onChange,
              onTapOutside: (pointerDownEvent) {
                onTapOutside;
                FocusManager.instance.primaryFocus?.unfocus();
              },
              textInputAction: TextInputAction.done,
              obscuringCharacter: '●',
              onFieldSubmitted: onSubmit,
              obscureText: isObscureText,
              autofillHints: autofill,
              style: AppFonts.ibm15LightBlack400,
              controller: enabled ? controller : TextEditingController(),
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: AppFonts.ibm15LightBlack400,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 4),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      suffixIcon,
                      color: AppColors.secondary,
                    ),
                    onPressed: onIconPress,
                    color: AppColors.secondary,
                  ),
                ),
                hintText: hintText ?? "Password",
                hintStyle: AppFonts.ibm15subTextGrey400,
                contentPadding: const EdgeInsetsDirectional.only(
                  start: 16,
                  // end: 16,
                  top: 14,
                  bottom: 12,
                ),
                border: (fieldValidation == TextFieldValidation.notValid)
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.errorRed,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: AppColors.subTextGrey,
                        ),
                      ),
                focusedBorder: (fieldValidation == TextFieldValidation.notValid)
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.subTextGrey,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: AppColors.subTextGrey,
                        ),
                      ),
                fillColor: AppColors.white,
                enabled: enabled,
                filled: false,
                enabledBorder: (fieldValidation == TextFieldValidation.notValid)
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.errorRed,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: AppColors.subTextGrey,
                        ),
                      ),
              ),
            ),
          ),
          if (fieldValidation == TextFieldValidation.notValid &&
              validateText != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: validatePadding,
                  top: 8,
                ),
                child: Text(
                  validateText ?? '',
                  style: AppFonts.ibm14ErrorRed400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final double marginTop;
  final double marginLeft;
  final double marginRight;
  final double marginBottom;
  final double validatePadding;
  final double paddingTop;
  final String hint;
  final String? label;
  final TextFieldValidation validationState;
  final String validateText;
  final bool enabled;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController textEditingController;
  final Function(String value)? onSubmit;
  final Function(String value)? onChange;
  final Function(PointerDownEvent)? onTapOutside;
  final Function()? onTap;
  final Widget? icon;
  final Widget? prefixIcon;
  final double? height;
  final double? width;
  final Color fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool enableInteractiveSelection;
  final bool isWithValidationMsg;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final EdgeInsetsDirectional? contentPadding;
  final double radius;
  final int? maxLines;

  // ignore: prefer_const_constructors_in_immutables
  CustomTextField({
    super.key,
    this.marginTop = 0,
    this.marginBottom = 0,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.hint = "name",
    this.textInputAction = TextInputAction.next,
    required this.validationState,
    this.validatePadding = 20,
    this.enabled = true,
    required this.textEditingController,
    this.validateText = '',
    required this.onSubmit,
    this.onTapOutside,
    this.textInputType = TextInputType.text,
    this.onChange,
    this.onTap,
    this.border,
    this.prefixIcon,
    this.icon,
    this.contentPadding,
    this.height = 48,
    this.radius = 0.0,
    this.width,
    this.maxLines,
    this.inputFormatters,
    this.fillColor = AppColors.white,
    this.focusNode,
    this.hintStyle,
    this.isWithValidationMsg = true,
    this.enableInteractiveSelection = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.label,
    this.paddingTop = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: marginTop,
        bottom: marginBottom,
        start: marginLeft,
        end: marginRight,
      ),
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              height: height,
              width: width ?? double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
              ),
              child: TextFormField(
                expands: maxLines != null ? false : true,
                maxLines: maxLines,
                minLines: maxLines,
                enableInteractiveSelection: enableInteractiveSelection,
                onTap: onTap,
                focusNode: focusNode,
                showCursor: focusNode?.hasFocus,
                inputFormatters: inputFormatters,
                onChanged: onChange,
                keyboardType: textInputType,
                textInputAction: textInputAction,
                onFieldSubmitted: onSubmit,
                style: AppFonts.ibm14LightBlack400.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                controller: textEditingController,
                onTapOutside: (pointerDownEvent) {
                  if (onTapOutside != null) {
                    onTapOutside!(pointerDownEvent);
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: AppFonts.ibm15LightBlack400,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: icon,
                  prefixIcon: prefixIcon,
                  prefixIconConstraints: const BoxConstraints(),
                  hintText: hint,
                  hintStyle: hintStyle ?? AppFonts.ibm15subTextGrey400,
                  contentPadding: contentPadding ??
                      EdgeInsetsDirectional.only(
                        start: prefixIcon != null ? 86 : 16,
                        end: 12,
                        top: 14,
                        bottom: 12,
                      ),
                  border: border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radius),
                        borderSide: BorderSide(
                          color: AppColors.black.withOpacity(0.5),
                        ),
                      ),
                  focusedBorder:
                      (validationState == TextFieldValidation.notValid)
                          ? OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.errorRed,
                              ),
                              borderRadius: BorderRadius.circular(radius),
                            )
                          : border ??
                              OutlineInputBorder(
                                borderRadius: BorderRadius.circular(radius),
                                borderSide: const BorderSide(
                                  color: AppColors.black,
                                ),
                              ),
                  fillColor: enabled ? fillColor : AppColors.borderGrey,
                  enabled: enabled,
                  filled: enabled ? false : true,
                  disabledBorder:
                      (validationState == TextFieldValidation.notValid)
                          ? OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.errorRed,
                              ),
                              borderRadius: BorderRadius.circular(radius),
                            )
                          : border ??
                              OutlineInputBorder(
                                borderRadius: BorderRadius.circular(radius),
                                borderSide: BorderSide(
                                  color: AppColors.black.withOpacity(0.5),
                                ),
                              ),
                  enabledBorder:
                      (validationState == TextFieldValidation.notValid)
                          ? OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.errorRed,
                              ),
                              borderRadius: BorderRadius.circular(radius),
                            )
                          : border ??
                              OutlineInputBorder(
                                borderRadius: BorderRadius.circular(radius),
                                borderSide: BorderSide(
                                  color: AppColors.black.withOpacity(0.5),
                                ),
                              ),
                ),
              ),
            ),
            if ((validationState == TextFieldValidation.notValid) &&
                isWithValidationMsg)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 8,
                  start: validatePadding,
                ),
                child: Text(
                  validateText.isNotEmpty
                      ? validateText
                      : "This field cannot be empty",
                  style: AppFonts.ibm14ErrorRed400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget codeTextField({
  required final TextEditingController controller,
  required final Function(String value) onChange,
  required final FocusNode node,
  final double height = 48,
  final double width = 48,
  final int maxNumbers = 1,
  final String hint = '',
  final Function(PointerDownEvent)? onTapOutside,
  final isText = false,
  final isMoney = false,
  final Function(String value)? onSubmit,
  required BuildContext context,
}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    height: height,
    width: width,
    decoration: const BoxDecoration(shape: BoxShape.circle),
    // padding: EdgeInsets.all(8),
    child: TextFormField(
      focusNode: node,
      autofocus: isMoney ? false : true,
      showCursor: true,
      // maxLength: 1,
      onTapOutside: onTapOutside ??
          (pointerDownEvent) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
      textAlign: TextAlign.center,
      inputFormatters: !isText
          ? isMoney
              ? [
                  DecimalTextInputFormatter(decimalRange: 2),
                ]
              : [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(maxNumbers)
                ]
          : null,
      textInputAction: TextInputAction.next,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      style: AppFonts.ibm16LightBlack600.copyWith(fontWeight: FontWeight.w700),
      controller: controller,
      keyboardType: isText
          ? isMoney
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text
          : TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.ibm14LightBlack400,
        // isDense: true,
        contentPadding: const EdgeInsetsDirectional.only(bottom: 24, start: 4),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.codeFieldBorder,
          ),
          borderRadius: isMoney == false
              ? BorderRadius.circular(60)
              : BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.black,
          ),
          borderRadius: isMoney == false
              ? BorderRadius.circular(60)
              : BorderRadius.circular(4),
        ),
        enabled: true,
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.codeFieldBorder,
          ),
          borderRadius: isMoney == false
              ? BorderRadius.circular(60)
              : BorderRadius.circular(4),
        ),
      ),
    ),
  );
}
