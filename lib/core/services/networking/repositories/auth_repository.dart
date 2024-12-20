import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turbo/core/services/local/storage_service.dart';
import 'package:turbo/core/services/networking/api_services/auth_service.dart';
import 'package:turbo/main_paths.dart';
import 'package:turbo/models/attachment.dart';

import '../../../../models/notifications_model.dart';
import '../../local/token_service.dart';

class AuthRepository {
  final AuthServices _authServices;
  int selectedCityIndex = 0;
  int selectedBranchIndex = 0;
  String selectedBranchId = "";
  String selectedCityId = "";

  AuthRepository(
    this._authServices,
  );

  CustomerModel customer = CustomerModel.empty();

  void setCustomerData(CustomerModel? cachedCustomer) {
    if (cachedCustomer != null) {
      customer = cachedCustomer;
      UserTokenService.saveUserToken(customer.token);
      UserTokenService.userTokenFirstTime();
    }
  }

  Future<Either<String, CustomerModel>> customerLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authServices.customerLogin(
        email: email,
        password: password,
      );
      if (response.statusCode == 200) {
        if (response.data['status']) {
          CustomerModel customer = CustomerModel.fromJson(response.data);
          UserTokenService.saveUserToken(customer.token);
          return Right(customer);
        } else {
          if (response.data.containsKey('data')) {
            return const Left("reset");
          } else {
            return const Left(
                "Invalid login credentials. Please double-check your email and password.");
          }
        }
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, CustomerModel>> refreshCustomerData() async {
    try {
      final response = await _authServices.refreshCustomerData();
      if (response.statusCode == 200 && response.data['status']) {
        customer = CustomerModel.fromJson(response.data);
        return Right(customer);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> signupInfoStep({
    required String customerName,
    required String customerEmail,
    required String customerAddress,
    required String customerTelephone,
    required String customerPassword,
    required String customerCountry,
    required String customerCountryCode,
    required int customerType,
    required String customerNationalId,
    required String customerNationalIDExpiryDate,
    required String? customerDriverLicenseNumber,
    required String? customerDriverLicenseNumberExpiryDate,
  }) async {
    try {
      final response = await _authServices.signupInfoStep(
        customerName: customerName,
        customerAddress: customerAddress,
        customerCountry: customerCountry,
        customerCountryCode: customerCountryCode,
        customerEmail: customerEmail,
        customerPassword: customerPassword,
        customerTelephone: customerTelephone,
        customerType: customerType,
        fcmToken: AppConstants.fcmToken,
        customerNationalId: customerNationalId,
        customerNationalIDExpiryDate: customerNationalIDExpiryDate,
        customerDriverLicenseNumber: customerDriverLicenseNumber,
        customerDriverLicenseNumberExpiryDate:
            customerDriverLicenseNumberExpiryDate,
      );
      if (response.statusCode == 200) {
        if (response.data['status']) {
          customer = CustomerModel(
            customerAddress: customerAddress,
            customerTelephone: customerTelephone,
            customerNationalId: customerNationalId,
            customerName: customerName,
            customerId: response.data['id'],
            customerEmail: customerEmail,
            attachments: <Attachment>[],
            customerType: customerType,
            token: response.data['token'],
          );
          UserTokenService.saveUserToken(response.data['token']);
          StorageService.saveData(
            "customerData",
            json.encode(customer.toJson()),
          );
          return const Right(true);
        } else {
          return const Left("reset");
        }
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<UserNotificationModel>>> getNotifications() async {
    try {
      final response = await _authServices.getNotifications();
      if (response.statusCode == 200) {
        if (response.data['status']) {
          List<UserNotificationModel> notifications =
              (response.data['data'] as List)
                  .map(
                    (e) => UserNotificationModel.fromJson(e),
                  )
                  .toList();
          return Right(notifications);
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

  void setSelectedCityIdToCache(String id) {
    CacheHelper.setData(key: "SelectedCityId", value: id);
  }

  void setSelectedBranchIdToCache(String id) {
    CacheHelper.setData(key: "SelectedBranchId", value: id);
  }

  Future<Either<String, List<UserNotificationModel>>>
      setNotificationsSeen() async {
    try {
      final response = await _authServices.setSeenNotifications();
      if (response.statusCode == 200 && response.data['status']) {
        List<dynamic> data = response.data['data'];
        final List<UserNotificationModel> notifications =
            data.map((n) => UserNotificationModel.fromJson(n)).toList();
        return Right(notifications);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('setNotificationsSeen Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, List<UserNotificationModel>>> setNotificationsRead(
    String notificationId,
  ) async {
    try {
      final response = await _authServices.setReadNotification(notificationId);
      if (response.statusCode == 200 && response.data['status']) {
        List<dynamic> data = response.data['data'];
        final List<UserNotificationModel> notifications =
            data.map((n) => UserNotificationModel.fromJson(n)).toList();
        return Right(notifications);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('setReadNotification Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> setNotificationToken(
      String token, String authToken) async {
    try {
      final response =
          await _authServices.setNotificationsToken(token, authToken);
      if (response.statusCode == 200 && response.data['status']) {
        return const Right(true);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('setNotificationToken Error -- $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> disableNotificationToken(String token) async {
    try {
      final response = await _authServices.disableNotificationsToken(
        customerToken: customer.token,
        notificationToken: token,
      );
      if (response.statusCode == 200 && response.data['status']) {
        return const Right(true);
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      debugPrint('disableNotificationToken Error -- $e');
      return Left(e.toString());
    }
  }

  Future<void> clearCustomerData() async {
    customer = CustomerModel.empty();
    UserTokenService.deleteUserToken();
    StorageService.deleteAllData();
    await disableNotificationToken(AppConstants.fcmToken);
  }

  Future<Either<String, bool>> checkUserExistence({
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final response = await _authServices.checkUserExistence(
        email: email,
        phoneNumber: phoneNumber,
      );
      if (response.statusCode == 200) {
        if (response.data['status'] == false) {
          return const Right(true);
        } else {
          if (response.data['data'] == false) {
            return const Left("reset");
          }
          return const Left(
            "User with this information already exists. Please login to access your account.",
          );
        }
      } else {
        return Left(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Either<String, String>> sendOTP(String phoneNumber) async {
    try {
      final completer = Completer<Either<String, String>>();

      await _auth.verifyPhoneNumber(
        phoneNumber: "+201099027885",
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          completer.complete(const Right('Auto-verified'));
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(Left(e.message ?? 'Verification failed'));
        },
        codeSent: (String verificationId, int? resendToken) {
          completer.complete(Right(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      return await completer.future;
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, UserCredential>> verifyOTP({
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Verification failed');
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> forgetPassword({
    required String email,
  }) async {
    try {
      final response = await _authServices.forgetPassword(email);
      if (response.data['status'] == false) {
        return Left(response.data['message']);
      } else {
        return const Right("otp");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Map<String, String>>> checkOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _authServices.checkOTP(email, otp);
      if (response.data['status'] == false) {
        return Left(response.data['message']);
      } else {
        return Right(
            {"msg": response.data['message'], "id": response.data['data']});
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> changePassword({
    required String id,
    required String newPassword,
  }) async {
    try {
      final response = await _authServices.changePassword(id, newPassword);
      if (response.data['status'] == false) {
        return Left(response.data['message']);
      } else {
        return Right(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> editCustomer(
      {String? customerName, String? customerAddress, File? image}) async {
    try {
      final response = await _authServices.editCustomer(
          customerName, customerAddress, image);
      if (response.data['status'] == false) {
        return Left(response.data['message']);
      } else {
        final Map<String, dynamic> data = response.data['data'];
        customer.customerName = data['customerName'];
        customer.customerAddress = data['customerAddress'];
        customer.customerImageProfilePath = data['customerImageProfilePath'];
        StorageService.saveData(
          "customerData",
          json.encode(customer.toJson()),
        );
        return Right(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> deleteCustomer() async {
    try {
      final response = await _authServices.deleteCustomer();
      if (response.data['status'] == false) {
        return Left(response.data['message']);
      } else {
        return Right(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> resetCustomer(String customerEmail) async {
    try {
      final response = await _authServices.resetCustomer(customerEmail);
      if (response.data['status'] == false) {
        return Left(response.data['message']);
      } else {
        return Right(response.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
