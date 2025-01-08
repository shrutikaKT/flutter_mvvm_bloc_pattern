import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_advance/data/models/stripe_responses.dart';
import 'package:flutter_bloc_advance/data/repository/stripe_repository.dart';
import 'package:flutter_bloc_advance/utils/app_constants.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../configuration/app_logger.dart';
part 'stripe_event.dart';
part 'stripe_state.dart';

class StripeBloc extends Bloc<StripeEvent, StripeState> {
  static final _log = AppLogger.getLogger("StripeBloc");
  final StripeRepository _stripeRepository;
  StripeBloc({required StripeRepository stripeRepository})
      : _stripeRepository = stripeRepository,
        super(
          PaymentInitializeState(),
        ) {
    on<StripeEvent>((event, emit) {});
    on<MakePayment>(_doPayment);
    on<AddMyCard>(_addCard);
    on<CardChanged>(_validateForm);
    on<GetAllCards>(
      (event, emit) async {
        _log.debug("Calling API for cards");
        emit(AllCardInitiatedState());
        emit(CardsLoadingState());
        try {
          List<CardDetail?> list = await _stripeRepository.getMyCards();
          emit(CardsLoadedState(cards: list));
          _log.debug("API response loaded :", [list]);
        } catch (error) {
          _log.error("Error while loading cards API :", [error]);
          emit(CardsLoadingFailed());
        }
      },
    );
  }

  FutureOr<void> _doPayment(
      MakePayment event, Emitter<StripeState> emit) async {
    _log.debug("Payment Initialised");
    emit(PaymentInitializeState());
    try {
      _log.debug("Payment Intent API calling");
      emit(PaymentLoadingState());
      PaymentIntentResponse? intentResponse = await _stripeRepository
          .createPaymentIntent(amount: event.amount, currency: 'usd');
      _log.debug("Payment Intent API Response : {}", [intentResponse!]);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intentResponse.clientSecret,
          merchantDisplayName: AppConstants.appName,
          customerId: intentResponse.customer,
          customerEphemeralKeySecret: intentResponse.ephemeralKeySecret,
          allowsDelayedPaymentMethods: true,
        ),
      );
      _log.debug("Payment sheet initiated");
      PaymentSheetPaymentOption? paymentSheetResponse = await Stripe.instance
          .presentPaymentSheet(options: const PaymentSheetPresentOptions());
      _log.debug("Payment sheet presented & here is response : {}",
          [paymentSheetResponse]);
      emit(PaymentSuccessState());
    } on StripeException {
      _log.error("Stripe Error");
      emit(const PaymentFailureState("Stripe Exception"));
    } catch (e) {
      if (e is StripeError) {
        _log.error("Stripe Error: {}", [e.message]);
        emit(PaymentFailureState(e.message));
      }
      _log.error("Error while making payment: {}", [e]);
      emit(PaymentFailureState(e.toString()));
    }
  }

  Future<void> _addCard(AddMyCard event, Emitter<StripeState> emit) async {
    _log.debug("Add Card details : {}",
        [event.cardNumber, event.expiryYear, event.expiryMonth, event.cardCVC]);
    try {
      emit(AddingCardState());
      // add card details
      await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
          number: event.cardNumber,
          expirationYear: event.expiryYear,
          expirationMonth: event.expiryMonth,
          cvc: event.cardCVC));
      // create an token for backend
      TokenData tokenData = await Stripe.instance.createToken(
        const CreateTokenParams.card(params: CardTokenParams()),
      );
      _log.debug("token id : {}", [tokenData.id]);
      // call the API by providing token
      _stripeRepository.saveMyCard(tokenData.id);
      emit(CardAddedState());
    } catch (error) {
      _log.error("Error while adding card: {}", [error]);
      if (error is StripeError) {
        emit(AddingCardFailedState(error.message));
      }
      emit(AddingCardFailedState(error.toString()));
    }
  }

  Future<void> _validateForm(
      CardChanged event, Emitter<StripeState> emit) async {
    if (event.cardDetails.complete) {
      _log.debug("Card Details are valid");
      emit(CardFormValidState());
    } else {
      _log.debug("Card Details are not valid");
      emit(CardFormInvalidState());
    }
  }
}
