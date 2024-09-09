import 'package:turbo/blocs/orders/order_cubit.dart';
import 'package:turbo/models/get_cars_by_brands.dart';

import '../../models/car_details_model.dart';

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
  final List<CarColor> carColor;

  SignupScreenArguments({
    required this.carId,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.carColor,
  });
}

class PaymentScreenArguments {
  final num paymentAmount;
  final String carRequestId;
  final String carRequestCode;
  final OrderCubit? orderCubit;

  PaymentScreenArguments({
    required this.paymentAmount,
    required this.carRequestId,
    required this.carRequestCode,
     this.orderCubit,
  });
}

class RequestStatusScreenArguments {
  final String requestId;
  final String requestCode;
  final OrderCubit orderCubit;

  RequestStatusScreenArguments({
    required this.requestId,
    required this.requestCode,
    required this.orderCubit,
  });
}
