import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_header.dart';
import '../../models/listing.dart';
import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/loader.dart';
import '../../widgets/text_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool loading = true;
  final List<Listing?> _orders = [];

  final ApiService _service = Get.find<ApiService>();

  getAllOrders() async {
    List<Listing?> res = await _service.fetchListing();
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
      body: Column(
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

          Flexible(child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(_orders.length, (index) => Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.grayScale))
                ),
                child: ListTile(

                  title: TextWidget(_orders.elementAt(index)?.title ?? ""),
                ),
              )),
            ),
          )),
        ],
      ),
    );
  }
}
