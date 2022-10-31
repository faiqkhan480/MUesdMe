import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../components/custom_header.dart';
import '../../models/listing.dart';
import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/loader.dart';
import '../../widgets/text_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool loading = true;
  bool fetching = false;
  final List<Listing?> _orders = [];

  final ApiService _service = Get.find<ApiService>();

  getAllOrders() async {
    List<Listing?> res = await _service.getOrders();
    if(res.isNotEmpty) {
      setState(() {
        if(_orders.isEmpty) {
          _orders.addAll(res);
        }
        else {
          _orders.clear();
          _orders.addAll(res);
        }
      });
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomHeader(title: "My Orders",
                buttonColor: AppColors.primaryColor,
                showBottom: false,
                showSearch: false,
                showSave: false,
                showRecentWatches: false,
              ),

              if(loading)
                const Loader(),

              Flexible(child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                itemCount: _orders.length,
                itemBuilder: (context, index) => Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.grayScale))
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: _orders.elementAt(index)?.category == "Video" ?
                    Container(
                        decoration: BoxDecoration(color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        alignment: Alignment.center,
                        height:50, width: 50,
                        child: const Icon(Feather.film, color: Colors.white)):
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "${Constants.LISTING_URL}${_orders.elementAt(index)?.mainFile}",
                        loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : const Center(child: Loader()),
                        errorBuilder: (context, error, stackTrace) => Container(
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryColor,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Feather.image, color: Colors.white)),
                        fit: BoxFit.cover, height:50, width: 50,),
                      // child: Image.network(nft, fit: boxFit, alignment: alignment),
                    ),
                    title: TextWidget(_orders.elementAt(index)?.title ?? ""),
                    subtitle: Text("${_orders.elementAt(index)?.type}\n${_orders.elementAt(index)?.price}"),
                    isThreeLine: true,
                    trailing: SizedBox(
                      height: 40,
                      width: 108,
                      child: SmallButton(
                        title: "Resend Link",
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        color: AppColors.secondaryColor,
                        onPressed: () => onTap(index),
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),

          if(fetching)
            ClipRRect(
            child: Container(
              color: AppColors.secondaryColor.withOpacity(0.3),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: const Center(
                  child: Loader(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onTap(int index) async {
    setState(() => fetching = true );
    var res = await _service.resendLink(_orders.elementAt(index)?.orderId);
    setState(() => fetching = false);
  }
}
