part of 'stripe_bloc.dart';

sealed class StripeState extends Equatable {
  const StripeState();
  
  @override
  List<Object> get props => [];
}

class PaymentInitial extends StripeState {
    @override
  List<Object> get props => [];
}

class PaymentLoading extends StripeState {
    @override
  List<Object> get props => [];
}

class PaymentLoaded extends StripeState {
    @override
  List<Object> get props => [];
}

class PaymentSuccess extends StripeState {
    @override
  List<Object> get props => [];
}

class PaymentFailure extends StripeState {
  final String error;
  const PaymentFailure(this.error);
    @override
  List<Object> get props => [];
}