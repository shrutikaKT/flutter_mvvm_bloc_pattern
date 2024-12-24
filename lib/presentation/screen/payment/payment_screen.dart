import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_advance/presentation/common_blocs/stripe/stripe_bloc.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  _buildAppBar(BuildContext context) =>
      AppBar(title: const Text('Payment Screen'), leading: Container());

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<StripeBloc, StripeState>(
        builder: (context, state) {
          return FilledButton(onPressed: () {
            context.read<StripeBloc>().add((const MakePayment(clientSecret: '', amount: 120.0)));
          }, child: const Text('Pay Now'));
        },
      ),
    );
  }
}
