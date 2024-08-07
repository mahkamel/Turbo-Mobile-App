import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/services/local/cache_helper.dart';
import 'package:turbo/core/services/local/storage_service.dart';
import 'package:turbo/core/services/networking/api_services/auth_service.dart';
import 'package:turbo/models/attachment.dart';
import 'package:turbo/models/customer_model.dart';

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
          return const Left(
              "Invalid login credentials. Please double-check your email and password.");
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
        customer.attachments =
            CustomerModel.fromJson(response.data).attachments;
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
      );
      if (response.statusCode == 200 && response.data['status']) {
        customer = CustomerModel(
          customerName: customerName,
          customerId: "",
          customerEmail: customerEmail,
          attachments: <Attachment>[],
          token: response.data['token'],
        );
        UserTokenService.saveUserToken(response.data['token']);
        StorageService.saveData(
          "customerData",
          json.encode(customer.toJson()),
        );
        return const Right(true);
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
        phoneNumber: phoneNumber,
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
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout handling if needed
        },
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
      print("otpppp ${e.toString()}");
      return Left(e.message ?? 'Verification failed');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
