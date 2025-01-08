import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_advance/presentation/common_blocs/stripe/stripe_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});
  final cardController = CardFormEditController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  _buildAppBar(BuildContext context) =>
      AppBar(title: const Text('Payment Screen'), leading: Container());

  _buildBody(BuildContext context) {
    BlocProvider.of<StripeBloc>(context).add(GetAllCards());
    return Center(
      child: SingleChildScrollView(
        child: BlocConsumer<StripeBloc, StripeState>(
          builder: (context, state) {
            return Column(children: [
              if (state is CardsLoadingState) ...{
                const CircularProgressIndicator()
              },
              if (state is CardsLoadedState) ...{
                Column(
                    children: state.cards
                        .map(
                          (card) => Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${card!.brand}',
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '**** **** **** ${card!.last4}',
                                        textAlign: TextAlign.center,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      'MM/YYYY : ${card.expMonth}/${card.expYear}'),
                                ]),
                          ),
                        )
                        .toList())
              },
              Container(
                  margin: const EdgeInsets.all(20),
                  child: CardFormField(
                    style: CardFormStyle(borderRadius: 10),
                    controller: cardController,
                    enablePostalCode: true,
                    onCardChanged: (details) {
                      context
                          .read<StripeBloc>()
                          .add(CardChanged(cardDetails: details!));
                    },
                  )),
              if (cardController.details.complete) ...{
                FilledButton(
                    onPressed: () {
                      context.read<StripeBloc>().add((AddMyCard(
                          cardNumber: cardController.details.number!,
                          expiryYear: cardController.details.expiryYear!,
                          expiryMonth: cardController.details.expiryMonth!,
                          cardCVC: cardController.details.cvc!)));
                    },
                    child: const Text('Add my card'))
              },
              const Text("OR"),
              const SizedBox(
                height: 20,
              ),
              FilledButton(
                  onPressed: () {
                    context
                        .read<StripeBloc>()
                        .add((const MakePayment(amount: 120.0)));
                  },
                  child: const Text('Make a Payment'))
            ]);
          },
          listener: (BuildContext context, StripeState state) {},
        ),
      ),
    );
  }
}
