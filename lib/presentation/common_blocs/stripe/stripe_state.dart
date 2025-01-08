part of 'stripe_bloc.dart';

class StripeState extends Equatable {
  const StripeState();

  @override
  List<Object> get props => [];
}

class PaymentInitializeState extends StripeState {
  @override
  List<Object> get props => [];
}

class PaymentLoadingState extends StripeState {
  @override
  List<Object> get props => [];
}

class PaymentLoadedState extends StripeState {
  @override
  List<Object> get props => [];
}

class PaymentSuccessState extends StripeState {
  @override
  List<Object> get props => [];
}

class PaymentFailureState extends StripeState {
  final String error;
  const PaymentFailureState(this.error);
  @override
  List<Object> get props => [];
}

class AddingCardState extends StripeState {
  @override
  List<Object> get props => [];
}

class CardAddedState extends StripeState {
  @override
  List<Object> get props => [];
}

class AddingCardFailedState extends StripeState {
  final String error;
  const AddingCardFailedState(this.error);
  @override
  List<Object> get props => [];
}

class CardFormInitialState extends StripeState {
  @override
  List<Object> get props => [];
}

class CardFormValidState extends StripeState {
  @override
  List<Object> get props => [];
}

class CardFormInvalidState extends StripeState {
  @override
  List<Object> get props => [];
}

class AllCardInitiatedState extends StripeState {
  @override
  List<Object> get props => [];
}

class CardsLoadingState extends StripeState {
  @override
  List<Object> get props => [];
}

class CardsLoadedState extends StripeState {
  final List<CardDetail?> cards;
  const CardsLoadedState({required this.cards});
  @override
  List<Object> get props => [cards];
}

class CardsLoadingFailed extends StripeState {
  @override
  List<Object> get props => [];
}
