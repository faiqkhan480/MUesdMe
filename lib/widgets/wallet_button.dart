import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:musedme/widgets/text_widget.dart';

class WalletButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? val;
  const WalletButton({Key? key, this.onTap, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Ionicons.ios_wallet_outline, color: Colors.white),
          TextWidget("\t\$ ${numFormat(val ?? 0)}", size: 16, weight: FontWeight.w400, color: Colors.white),
          // TextWidget("\t\$ ${numFormat(val ?? 0)}", size: 16, weight: FontWeight.w400, color: Colors.white),
        ],
      ),
    );
  }

  String numFormat(double val) {
    if (val > 999 && val < 99999) {
      return "${(val / 1000).toStringAsFixed(1)} K";
    } else if (val > 99999 && val < 999999) {
      return "${(val / 1000).toStringAsFixed(0)} K";
    } else if (val > 999999 && val < 999999999) {
      return "${(val / 1000000).toStringAsFixed(1)} M";
    } else if (val > 999999999) {
      return "${(val / 1000000000).toStringAsFixed(1)} B";
    } else {
      return val.toString();
    }
  }
}
