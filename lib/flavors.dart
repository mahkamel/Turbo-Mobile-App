import 'main_paths.dart';

enum Flavor {
  dev,
  prod,
  qa,
}

class F {
  static Flavor? appFlavor;

}

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


Future<void> configureApp(Flavor flavor) async {
  await dotenv.load(fileName: ".env");
  switch (flavor) {
    case Flavor.dev:
      FlavorConfig(
        name: "Development",
        baseUrl: getValueFromEnv(AppConstants.devBaseUrl),
        filesBaseUrl: getValueFromEnv(AppConstants.filesBaseUrlDev),
      );
      break;
    case Flavor.qa:
      FlavorConfig(
        name: "QA",
        baseUrl: getValueFromEnv(AppConstants.qaBasUrl),
        filesBaseUrl: getValueFromEnv(AppConstants.filesBaseUrlQA),
      );
      break;
    case Flavor.prod:
      FlavorConfig(
        name: "Production",
        baseUrl: getValueFromEnv(AppConstants.prodBasUrl),
        filesBaseUrl: getValueFromEnv(AppConstants.filesBaseUrlProd),
      );
      break;
  }
}