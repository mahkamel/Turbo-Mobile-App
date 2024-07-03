import 'package:turbo/models/get_cars_by_brands.dart';

class CardDetailsScreenArguments {
  final Car car;

  CardDetailsScreenArguments({
    required this.car,
  });
}

class LoginScreenArguments {
  final String carId;
  final num dailyPrice;
  final num weeklyPrice;
  final num monthlyPrice;

  LoginScreenArguments({
    required this.carId,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
  });
}

class SignupScreenArguments {
  final String carId;
  final bool isFromLogin;
  final num dailyPrice;
  final num weeklyPrice;
  final num monthlyPrice;

  SignupScreenArguments({
    required this.carId,
    required this.isFromLogin,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
  });
}

class PaymentScreenArguments {
  final num value;
  final String carRequestId;

  PaymentScreenArguments({
    required this.value,
    required this.carRequestId,
  });
}
