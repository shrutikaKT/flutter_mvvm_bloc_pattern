part of 'stripe_bloc.dart';

sealed class StripeEvent extends Equatable {
  const StripeEvent();

  @override
  List<Object> get props => [];
}

class ConfirmPayment extends StripeEvent {
  final String paymentMethod;
  const ConfirmPayment(this.paymentMethod);

  @override
  List<Object> get props => [];
}

class AddCard extends StripeEvent {
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cvc;

  const AddCard(
      {required this.cardNumber,
      required this.expiryMonth,
      required this.expiryYear,
      required this.cvc});

  @override
  List<Object> get props => [cardNumber, expiryMonth, expiryYear, cvc];
}

class MakePayment extends StripeEvent {
  final String clientSecret;
  final double amount;
  const MakePayment({required this.clientSecret, required this.amount});
  @override
  List<Object> get props => [];
}
