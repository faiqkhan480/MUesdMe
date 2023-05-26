import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../components/custom_header.dart';
import '../../controllers/market_controller.dart';
import '../../models/listing.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/input_field.dart';
import '../../widgets/loader.dart';
import '../../widgets/text_widget.dart';

class UploadListingScreen extends StatefulWidget {
  const UploadListingScreen({Key? key}) : super(key: key);

  @override
  State<UploadListingScreen> createState() => _UploadListingScreenState();
}

class _UploadListingScreenState extends State<UploadListingScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  bool loader = false;
  String? _type = "Selling"; //Licensing
  // String? selectedCountry;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthService get _authService => Get.find<AuthService>();
  ApiService get _apiService => Get.find<ApiService>();
  MarketController get _controller => Get.find<MarketController>();
  Listing? get _listing => _controller.uploadItem();
  bool get _loading => _controller.fetching();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setValues();
  }

  void setValues() {
    if(_controller.selectedItem.value?.userId == _authService.currentUser?.userId) {
      setState(() {
        title.text = _controller.selectedItem.value?.title ?? "";
        description.text = _controller.selectedItem.value?.description ?? "";
        price.text = (_controller.selectedItem.value?.price  ?? "").toString();
        _type = _controller.selectedItem.value?.type  ?? "Selling";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomHeader(title: "Upload",
            buttonColor: AppColors.primaryColor,
            showBottom: false,
            showSearch: false,
            showSave: false,
            showRecentWatches: false,
          ),

          Flexible(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextWidget("Choose type of item", color: AppColors.secondaryColor, size: 18, weight: FontWeight.w700),
                      ),
                      // TYPE SELECTION
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: RadioListTile<String>(
                            value: "Selling",
                            groupValue: _type,
                            activeColor: AppColors.primaryColor,
                            onChanged: (String? value) => setState(() => _type = value),
                            title: const Text("Selling"),
                          )),

                          Expanded(child: RadioListTile<String>(
                            value: "Licensing",
                            groupValue: _type,
                            activeColor: AppColors.primaryColor,
                            onChanged: (String? value) => setState(() => _type = value),
                            title: const Text("\t\Licensing"),
                          )),
                        ],
                      ),
                      // PRICE FIELD
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: InputField(
                          controller: price,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),],
                          labelText: "Price",
                          validator: (String? value) => value!.isEmpty ? "Price is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),

                      // TITLE FIELD
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: InputField(
                          controller: title,
                          labelText: "Title",
                          keyboardType: TextInputType.text,
                          validator: (String? value) => value!.isEmpty ? "Title is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),

                      // DESCRIPTION FIELD
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                        child: InputField(
                          controller: description,
                          labelText: "Description",
                          minLines: 5,
                          keyboardType: TextInputType.text,
                          validator: (String? value) => value!.isEmpty ? "Description is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),

                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if(_controller.selectedItem.value?.userId == _authService.currentUser?.userId)
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () => _controller.uploadFile(_controller.selectedItem.value!.category!),
                                      style: TextButton.styleFrom(
                                          backgroundColor: AppColors.secondaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                          textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
                                      ),
                                      child: const Text("Upload Files"),
                                    ),

                                    if(_loading)
                                      const SizedBox(
                                        height: 50,
                                        child: Loader(),
                                      ),
                                  ],
                                ),
                              ),

                            if(_listing != null && _listing!.files!.isNotEmpty)...[
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextWidget("Items", color: AppColors.secondaryColor, size: 18, weight: FontWeight.w700),
                              ),
                              ...List.generate(_listing!.files!.length, (index) => Padding(padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                child: TextWidget("${_listing?.files?.elementAt(index).filePath}",
                                    color: AppColors.secondaryColor, size: 15, weight: FontWeight.w400),
                              ), )
                            ]

                            else if(_controller.selectedItem.value?.files != null && _controller.selectedItem.value!.files!.isNotEmpty)
                              ...List.generate(_controller.selectedItem.value!.files!.length, (index) => Padding(padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                child: TextWidget("${_controller.selectedItem.value!.files?.elementAt(index).filePath}",
                                    color: AppColors.secondaryColor, size: 15, weight: FontWeight.w400),
                              ), )
                          ],
                        );
                      }),
                    ],
                  )
              )
          ),),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: loader ? const SizedBox(
          height: 50,
          child: Loader(),
        ) :
        TextButton(
          onPressed:
          _controller.selectedItem.value?.userId == _authService.currentUser?.userId ?
          handleUpdate :
          handleSubmit,
          style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
          ),
          child: Text(_controller.selectedItem.value?.userId == _authService.currentUser?.userId ? "Update" : "Submit"),
        ),
      ),
    );
  }

  Future<void> handleSubmit() async {
    if(!loader && _formKey.currentState!.validate()) {
      try {
        setState(() => loader = true);
        Listing? payload = _listing?.copyWith(
          type: _type,
          userId: _authService.currentUser?.userId,
          category: Get.arguments,
          description: description.text,
          title: title.text,
          price: double.tryParse(price.text),
        );
        bool res = await _apiService.uploadListing(payload);
        setState(() => loader = false);
        if(res) {
          _controller.uploadItem = Rxn<Listing?>();
          Get.back();
        }
      }
      catch(e) {
        debugPrint("$e");
        setState(() => loader = false);
      }
    }
  }

  Future<void> handleUpdate() async {
    if(!loader && _formKey.currentState!.validate()) {
      try {
        setState(() => loader = true);
        Listing? payload = Listing(
          type: _type,
          userId: _authService.currentUser?.userId,
          category: Get.arguments,
          description: description.text,
          title: title.text,
          price: double.tryParse(price.text),
          itemId: _controller.selectedItem.value!.itemId!,
          status: _controller.selectedItem.value?.status,
          mainFile: _controller.selectedItem.value?.mainFile,
          orderId: _controller.selectedItem.value?.orderId,
          quantity: _controller.selectedItem.value?.quantity,
          files: _listing?.files ?? _controller.selectedItem.value?.files,
          userDetails: _controller.selectedItem.value?.userDetails
        );
        // Listing? payload = _listing?.copyWith(
        //   type: _type,
        //   userId: _authService.currentUser?.userId,
        //   category: Get.arguments,
        //   description: description.text,
        //   title: title.text,
        //   price: double.tryParse(price.text),
        //   itemId: _controller.selectedItem.value!.itemId!,
        // );
        debugPrint("::::::::::::::${payload.toJson()}");
        var res = await _apiService.updateListing(payload);
        setState(() => loader = false);
        if(res != null) {
          _controller.updateItem(payload!);
          Get.back();
          Get.snackbar("Success!", res ?? "",
              backgroundColor: AppColors.successColor,
              colorText: Colors.white
          );
        }
      }
      catch(e) {
        debugPrint("$e");
        setState(() => loader = false);
      }
    }
  }
}

