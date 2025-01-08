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

class MakePayment extends StripeEvent {
  final double amount;
  const MakePayment({required this.amount});
  @override
  List<Object> get props => [];
}

class AddMyCard extends StripeEvent {
  final String cardNumber;
  final int expiryYear;
  final int expiryMonth;
  final String cardCVC;
  const AddMyCard(
      {required this.cardNumber,
      required this.expiryYear,
      required this.expiryMonth,
      required this.cardCVC});
  @override
  List<Object> get props => [cardNumber, expiryYear, expiryMonth, cardCVC];
}

class CardChanged extends StripeEvent {
  final CardFieldInputDetails cardDetails;

  const CardChanged({required this.cardDetails});

  @override
  List<Object> get props => [];
}

class GetAllCards extends StripeEvent {
  const GetAllCards();

  @override
  List<Object> get props => [];
}
