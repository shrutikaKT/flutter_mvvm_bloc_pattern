import 'package:flutter_bloc_advance/data/models/stripe_responses.dart';
import '../../configuration/allowed_paths.dart';
import '../../configuration/app_logger.dart';
import '../app_api_exception.dart';
import '../http_utils.dart';

class StripeRepository {
  static final _log = AppLogger.getLogger("StripeRepository");
  StripeRepository();

  Future<PaymentIntentResponse?> createPaymentIntent(
      {required double amount, required String currency}) async {
    _log.debug("BEGIN: create payment intent with : {amount, currency}",
        [amount, currency]);
    if (amount == 0) {
      throw BadRequestException("Amount must be greater than 0");
    }
    final httpResponse = await HttpUtils.postRequest(paymentIntentAPI, {
      "amount": amount,
      "currency": currency,
      "customerId": "cus_RXDEsOcAY6yyhs"
    });
    final response = PaymentIntentResponse.fromJsonString(httpResponse.body);
    _log.debug(
        "END:Payment intent details loaded successfully - response.body: {}",
        [response.toString()]);
    return response;
  }

  Future<String?> saveMyCard(String tokenId) async {
    _log.debug("BEGIN: send the token ", [tokenId]);
    if (tokenId.isEmpty) {
      throw BadRequestException("Token is empty");
    }
    final httpResponse = await HttpUtils.postRequest(
        addMyCardAPI, {"customerId": "cus_RXDEsOcAY6yyhs", "token": tokenId});
    final response = httpResponse.body;
    _log.debug("END:Token id sent successfully - response.body: {}",
        [response.toString()]);
    return response;
  }

  Future<List<CardDetail?>> getMyCards() async {
    String custId = "cus_RXDEsOcAY6yyhs";
    _log.debug("BEGIN: customer Id ", [custId]);
    if (custId.isEmpty) {
      throw BadRequestException("Please provide valid customer ID");
    }
    final httpResponse =
        await HttpUtils.getRequest("$getCardsAPI?customerId=$custId");

    _log.debug(
        "END: Cards list is here - response.body: {}", [httpResponse.body]);

    return CardDetail.fromJsonStringList(httpResponse.body);
  }

  Future<void> removeMyCard(String cardId) async{
    _log.debug("BEGIN: Remove the card id : ", [cardId]);
  if(cardId.isEmpty){
    throw BadRequestException("Plese provide a valid card ID");
  }
  final    httpResponse =
        await HttpUtils.postRequest(removeCardAPI, {"paymentMethodId" : cardId});

  }
}
