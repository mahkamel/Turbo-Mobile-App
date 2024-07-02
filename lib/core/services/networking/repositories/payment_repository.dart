import 'package:dartz/dartz.dart';
import 'package:turbo/core/services/networking/api_services/payemnt_service.dart';

class PaymentRepository {
  final PaymentService _paymentService;

  PaymentRepository(this._paymentService);

  Future<Either<String, String>> carRequestPayment({
    required String userToken,
    required String requestId,
    required String inspectionId,
    required num paymentAmount,
    required String? savedCardId,
    required String visaCardName,
    required String visaCardNumber,
    required String visaCardExpiryMonth,
    required String visaCardExpiryYear,
    required bool isToSave,
    required String billingFirstName,
    required String billingLastName,
    required String billingCity,
    required String billingPostalCode,
    required String billingAddress,
    required String billingVisaLastNo,
  }) async {
    try {
      final response = await _paymentService.addPayment(
        userToken: userToken,
        isToSave: isToSave,
        visaId: savedCardId,
        visaCardNumber: visaCardNumber,
        visaCardExpiryMonth: visaCardExpiryMonth,
        visaCardExpiryYear: visaCardExpiryYear,
        visaCardName: visaCardName,
        carRequestId: requestId,
        paymentAmount: paymentAmount,
        billingFirstName: billingFirstName,
        billingLastName: billingLastName,
        billingAddress: billingAddress,
        billingCity: billingCity,
        billingPostalCode: billingPostalCode,
        billingVisaLastNo: billingVisaLastNo,
      );
      if (response.statusCode == 200) {
        if (response.data['status']) {
          return const Right("Paid");
        } else {
          return Left(response.data['message']);
        }
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
