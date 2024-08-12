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
  final num dailyPrice;
  final num weeklyPrice;
  final num monthlyPrice;

  SignupScreenArguments({
    required this.carId,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
  });
}

class PaymentScreenArguments {
  final num paymentAmount;
  final String carRequestId;
  final String carRequestCode;

  PaymentScreenArguments({
    required this.paymentAmount,
    required this.carRequestId,
    required this.carRequestCode,
  });
}


class RequestStatusScreenArguments {
  final String requestId;
  final String requestCode;

  RequestStatusScreenArguments({
    required this.requestId,
    required this.requestCode,
  });
}
