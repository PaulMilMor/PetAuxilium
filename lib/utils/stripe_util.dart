import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pet_auxilium/utils/db_util.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeUtil{
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeUtil.apiBase}/payment_intents';
  static String secret = 'sk_test_51Il7FDClypTttLIqgZ7sM0f9Vkpvdicz2ZJj9chl1kLfND3FBriIZckQiSW2FjEqkk1T99LATiry8E3Afv3sklDX00CL70hye2';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeUtil.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_test_51Il7FDClypTttLIqdWIpj1IZ4V5xcRHCTgV2xXh2sWW6zfNrqSNk5J5fWRyibZ3gqfegPWuF3nBjqxZL05WuFS8u00eWStFyiW",
        merchantId: "Test",
        androidPayMode: 'test'
      )
    );
  }

  static Future<StripeTransactionResponse> payViaCard({String amount, String currency, CreditCard card,int pack}) async{
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card)
      );
      var paymentIntent = await StripeUtil.createPaymentIntent(
        amount,
        currency
      );
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id
        )
      );
      if (response.status == 'succeeded') {
        
        dbUtil().setPatreon(pack);
        return new StripeTransactionResponse(
          message: 'hecho',
          success: true
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Algo Fallo',
          success: false
        );
      }
    } on PlatformException catch(err) {
      return StripeUtil.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Algo Fallo: ${err.toString()}',
        success: false
      );
    }
  }
  static getPlatformExceptionErrorResult( PlatformException
 err) {
    String message = 'Something went wrong';
    print(err.message);
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }
    if (err.message.contains('expiration year is invalid.')){
      message='Tarjeta Expirada';
    }

    return new StripeTransactionResponse(
      message: message,
      success: false
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        StripeUtil.paymentApiUrl,
        body: body,
        headers: StripeUtil.headers
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}