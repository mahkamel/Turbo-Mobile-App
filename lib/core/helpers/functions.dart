// Functions

import 'package:flutter/services.dart'
    show TextEditingValue, TextInputFormatter, TextSelection;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/flavors.dart';
import 'package:turbo/models/customer_model.dart';

import '../services/local/storage_service.dart';

String getValueFromEnv(String key) => dotenv.env[key] ?? "";

Future<CustomerModel?> getCustomerData() async {
  CustomerModel? customer;
  try {
    final jsonMap = await StorageService.getModelData(
      getValueFromEnv(AppConstants.customerData),
    );

    if (jsonMap != null) {
      customer = CustomerModel.fromJson(jsonMap);
    }
  } catch (err) {
    customer = null;
  }
  return customer;
}

String getCompleteFileUrl(String path) {
  return FlavorConfig.instance.filesBaseUrl + path;
}

class NoLeadingOrTrailingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String trimmed = newValue.text.trim();
    if (trimmed != newValue.text) {
      final TextSelection newSelection = newValue.selection.copyWith(
        baseOffset: trimmed.length,
        extentOffset: trimmed.length,
      );
      return TextEditingValue(
        text: trimmed,
        selection: newSelection,
      );
    }
    return newValue;
  }
}


class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (newText.length > 16) {
      return oldValue;
    }

    String formattedText = '';
    int cursorPosition = newValue.selection.start;

    for (int i = 0; i < newText.length; i += 4) {
      final end = i + 4 < newText.length ? i + 4 : newText.length;
      if (i > 0) {
        formattedText += ' ';
        if (cursorPosition >= i) {
          cursorPosition++;
        }
      }
      formattedText += newText.substring(i, end);
    }

    if (cursorPosition >= formattedText.length) {
      cursorPosition = formattedText.length;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    int cursorPosition = newValue.selection.start;

    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i == 2) {
        formattedText += '/';
        if (cursorPosition > i && newText.length > i) {
          cursorPosition++;
        }
      }
      formattedText += newText[i];
    }

    final int newCursorPosition = cursorPosition >= formattedText.length
        ? formattedText.length
        : cursorPosition;

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

bool validateExpiryDate(String value) {
  if (value.isEmpty) {
    return false;
  }
  List<String> parts = value.split('/');
  if (parts.length != 2) {
    return false;
  }

  try {
    int month = int.parse(parts[0]);
    int year = int.parse(parts[1]);

    if (month < 1 || month > 12) {
      return false;
    }

    int currentYear = DateTime.now().year % 100;
    if (year < currentYear ||
        (year == currentYear && month < DateTime.now().month)) {
      return false;
    }
  } catch (e) {
    return false;
  }

  return true;
}
