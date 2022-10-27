import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';

class WalletSheet extends StatefulWidget {
  const WalletSheet({Key? key}) : super(key: key);

  @override
  State<WalletSheet> createState() => _WalletSheetState();
}

class _WalletSheetState extends State<WalletSheet> {

  AuthService get _auth => Get.find<AuthService>();

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

            const SizedBox(height: 80),

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

            // SvgPicture.asset(Assets.iconsCoin),

            // const SizedBox(height: 20),
            const Spacer(),
            TextButton(
              onPressed: () async {
                // final paymentMethod = await Stripe.instance.createPaymentMethod(params: PaymentMethodParams.payPal(paymentMethodData: paymentMethodData));
              },
              style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w600)
              ),
              child: const Text("Add Amount"),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
