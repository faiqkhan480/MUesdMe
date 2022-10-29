import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../utils/network.dart';
import '../widgets/input_field.dart';

class WalletSheet extends StatefulWidget {
  const WalletSheet({Key? key}) : super(key: key);

  @override
  State<WalletSheet> createState() => _WalletSheetState();
}

class _WalletSheetState extends State<WalletSheet> {
  Map<String, dynamic>? paymentIntent;

  bool loading = false;
  AuthService get _auth => Get.find<AuthService>();

  TextEditingController price = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: Get.height * 0.40,
        child: Form(
          key: _formKey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.clear)),
                const Spacer(flex: 2,),
                const Text("Wallet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Larsseit',
                    fontWeight: FontWeight.w500,
                  ),),

                // const SizedBox.shrink(),
                const Spacer(flex: 3,),
              ],
            ),

            // const SizedBox(height: 80),
            const Spacer(),
            const Text("Balance",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 16,
                fontFamily: 'Larsseit',
                fontWeight: FontWeight.w500,
              ),),
            const SizedBox(height: 5),
            Text("\$${_auth.currentUser?.wallet}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 30,
                fontFamily: 'Larsseit',
                fontWeight: FontWeight.w600,
              ),),
            const Spacer(),
            // const SizedBox(height: 15),
            InputField(
              controller: price,
              labelText: "Enter Amount",
              inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
              validator: (String? value) => value!.isEmpty ? "Price is required!" : int.parse(value) < 1 ? "Price is grater than 0" : null,
            ),
            const SizedBox(height: 15),
            // const Spacer(),
            _loadingButton(text: "Add Amount", onPressed: makePayment,),
            // TextButton(
            //   onPressed: () => null,
            //   // onPressed:  makePayment(),
            //   style: TextButton.styleFrom(
            //       backgroundColor: AppColors.primaryColor,
            //       foregroundColor: Colors.white,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10)
            //       ),
            //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            //       textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w600)
            //   ),
            //   child: const Text("Add Amount"),
            // ),
            const SizedBox(height: 10),
          ],
        ),)
      ),
    );
  }

  Widget _loadingButton({text, onPressed}) {
    return TextButton(
      onPressed: () => onPressed(),
      // onPressed:  makePayment(),
      style: TextButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w600)
      ),
      child: loading ? const Center(child: CircularProgressIndicator(color: Colors.white),) : Text(text),
    );
  }


  Future<void> makePayment() async {
    if(_formKey.currentState!.validate()) {
      try {
        paymentIntent = await createPaymentIntent(price.text, 'USD');
        if(paymentIntent != null) {
          //Payment Sheet
          await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'MusedByMe')).then((value) => null);

          //now finally display payment sheet
          displayPaymentSheet();
        }
      } catch (e, s) {
        debugPrint('exception:$e$s');
      }
      setState(() => loading = false);
    }
  }

  displayPaymentSheet() async {
    try {
     await Stripe.instance.presentPaymentSheet().then((value) => Get.dialog(Column(
       children: [
         Row(
           children: const [
             Icon(Icons.check_circle, color: Colors.green,),
             Text("Payment Successful")
           ],
         )
       ],
     )));
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      setState(() => loading = true);
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${Constants.stripeSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
      // debugPrint('Payment Intent RES $response');
      // return response;
    } catch (e, s) {
      debugPrint('Intent exception:$e$s');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
