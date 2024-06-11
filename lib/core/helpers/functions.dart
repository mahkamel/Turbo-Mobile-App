// Functions

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:turbo/core/helpers/constants.dart';
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
