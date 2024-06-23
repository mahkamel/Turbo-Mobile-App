import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/helpers/constants.dart';
import 'core/helpers/functions.dart';

class FlavorConfig {
  final String name;
  final String baseUrl;
  final String filesBaseUrl;

  static late FlavorConfig _instance;

  factory FlavorConfig({
    required String name,
    required String baseUrl,
    required String filesBaseUrl,
  }) {
    _instance = FlavorConfig._internal(name, baseUrl, filesBaseUrl);
    return _instance;
  }

  FlavorConfig._internal(this.name, this.baseUrl, this.filesBaseUrl);

  static FlavorConfig get instance {
    return _instance;
  }
}

enum Flavor { DEV, QA, PROD }

Future<void> configureApp(Flavor flavor) async {
  await dotenv.load(fileName: ".env");
  switch (flavor) {
    case Flavor.DEV:
      FlavorConfig(
        name: "Development",
        baseUrl: getValueFromEnv(AppConstants.baseUrl),
        filesBaseUrl: getValueFromEnv(AppConstants.filesBaseUrlDev),
      );
      break;
    case Flavor.QA:
      FlavorConfig(
        name: "QA",
        baseUrl: getValueFromEnv(AppConstants.baseUrl),
        filesBaseUrl: getValueFromEnv(AppConstants.filesBaseUrlQA),
      );
      break;
    case Flavor.PROD:
      FlavorConfig(
        name: "Production",
        baseUrl: getValueFromEnv(AppConstants.baseUrl),
        filesBaseUrl: getValueFromEnv(AppConstants.filesBaseUrlProd),
      );
      break;
  }
}
