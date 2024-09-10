// Functions

import 'package:flutter/services.dart'
    show TextEditingValue, TextInputFormatter, TextRange, TextSelection;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/flavors.dart';
import 'package:turbo/models/customer_model.dart';
import 'dart:math' as math;
import '../../models/attachment.dart';
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

String formatNotificationDate(String notificationDate) {
  DateTime now = DateTime.now();
  DateTime parsedDate = DateTime.parse(notificationDate);
  Duration difference = now.difference(parsedDate);

  if (difference.inMinutes <= 0) {
    return 'Just now';
  } else if (difference.inMinutes <= 59) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours <= 23) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    return DateFormat('yyyy-MM-dd | hh:mm a').format(parsedDate);
  }
}

Attachment? findAttachmentFile({
  required String type,
  required List<Attachment> attachments,
}) {
  try {
    return attachments.firstWhere((item) => item.fileType == type);
  } catch (e) {
    return null;
  }
}

String formatDateTime(DateTime dateTime, {String? locale}) {
  final DateFormat formatter = DateFormat(
    'E MMM d HH:MM a',
    locale,
  );

  return formatter.format(dateTime);
}

String formatDate(DateTime dateTime, {String? locale}) {
  final DateFormat formatter = DateFormat(
    'E, MMM d, yyyy',
    locale,
  );

  return formatter.format(dateTime);
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final RegExp regExp = RegExp(r'^\d*\.?\d{0,}$');

    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }

    return oldValue;
  }
}
