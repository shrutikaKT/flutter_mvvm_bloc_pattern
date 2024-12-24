import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../configuration/app_logger.dart';
part 'stripe_event.dart';
part 'stripe_state.dart';

class StripeBloc extends Bloc<StripeEvent, StripeState> {
  static final _log = AppLogger.getLogger("StripeBloc");
  StripeBloc() : super(PaymentInitial()) {
    on<StripeEvent>((event, emit) {});
    on<MakePayment>(openPaymentWindow);
  }

  FutureOr<void> openPaymentWindow(
      MakePayment event, Emitter<StripeState> emit) async* {
    emit(PaymentInitial());
    try {
      emit(PaymentLoading());
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: event.clientSecret,
          merchantDisplayName: 'Your App Name',
        ),
      );
      emit(PaymentLoaded());
      try {
        await Stripe.instance.presentPaymentSheet();
        emit(PaymentSuccess());
      } catch (e) {
        emit(PaymentFailure(e.toString()));
      }
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
