import 'package:turbo/core/helpers/extentions.dart';

class AppRegex {
  static bool isEmailValid(String email) {
    return RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(
            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
        .hasMatch(password);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    return RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(phoneNumber);
  }

  static bool hasLowerCase(String password) {
    return RegExp(r'^(?=.*[a-z])').hasMatch(password);
  }

  static bool hasUpperCase(String password) {
    return RegExp(r'^(?=.*[A-Z])').hasMatch(password);
  }

  static bool hasNumber(String password) {
    return RegExp(r'^(?=.*?[0-9])').hasMatch(password);
  }

  static bool hasSpecialCharacter(String password) {
    return RegExp(r'^(?=.*?[#?!@$%^&*-])').hasMatch(password);
  }

  static bool hasMinLength(String password) {
    return RegExp(r'^(?=.{8,})').hasMatch(password);
  }

  static bool isValidCardNumberBasedOnType(String cardNumber, String cardType) {
    cardNumber = cardNumber.removeWhiteSpaces();
    Map<String, String> cardPatterns = {
      'visa': r'^4[0-9]{12}(?:[0-9]{3})?$',
      'mastercard':
          r'^5[1-5][0-9]{14}|^(222[1-9]|22[3-9]\\d|2[3-6]\\d{2}|27[0-1]\\d|2720)[0-9]{12}$',
      'amex': r'^3[47][0-9]{13}$',
    };

    String? pattern = cardPatterns[cardType.toLowerCase()];
    if (pattern != null) {
      return RegExp(pattern).hasMatch(cardNumber);
    }
    return false;
  }

  static bool isValidCardNumber(String cardNumber) {
    cardNumber = cardNumber.removeWhiteSpaces();
    Map<String, String> cardPatterns = {
      'visa': r'^4[0-9]{12}(?:[0-9]{3})?$',
      'mastercard':
          r'^5[1-5][0-9]{14}|^(222[1-9]|22[3-9]\\d|2[3-6]\\d{2}|27[0-1]\\d|2720)[0-9]{12}$',
      'amex': r'^3[47][0-9]{13}$',
      'other': r'^[0-9]{16}$',
    };

    String? cardType = _detectCardType(cardNumber);
    if (cardType != null) {
      String? pattern = cardPatterns[cardType.toLowerCase()];
      if (pattern != null) {
        return RegExp(pattern).hasMatch(cardNumber);
      }
    }
    return false;
  }

  static String? _detectCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      return 'visa';
    } else if (RegExp(r'^5[1-5]').hasMatch(cardNumber)) {
      return 'mastercard';
    } else if (RegExp(r'^3[47]').hasMatch(cardNumber)) {
      return 'amex';
    }
    return 'other';
  }
}
