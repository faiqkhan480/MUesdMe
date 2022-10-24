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

  DateTime selectedDate = DateTime.now();
  bool passSecure = true;
  bool confirmPassSecure = true;
  bool loader = false;
  String? _type = "Selling"; //Licensing
  // String? selectedCountry;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthService get _authService => Get.find<AuthService>();
  ApiService get _apiService => Get.find<ApiService>();
  MarketController get _controller => Get.find<MarketController>();
  Listing? get _listing => _controller.uploadItem();

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
                          Radio<String>(
                            value: "Selling",
                            groupValue: _type,
                            activeColor: AppColors.secondaryColor,
                            onChanged: (String? value) {
                              setState(() {
                                _type = value;
                              });
                            },
                          ),
                          const Text("\t\tSelling"),

                          Radio<String>(
                            value: "Licensing",
                            groupValue: _type,
                            activeColor: AppColors.secondaryColor,
                            onChanged: (String? value) {
                              setState(() {
                                _type = value;
                              });
                            },
                          ),
                          const Text("\t\tLicensing"),
                          // Expanded(
                          //   child: TextButton(
                          //     onPressed: () => setState(() => isMale = true),
                          //     style: TextButton.styleFrom(
                          //         backgroundColor: isMale ? AppColors.secondaryColor : Colors.white,
                          //         foregroundColor: !isMale ? AppColors.secondaryColor : Colors.white,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //           side: const BorderSide(color: AppColors.lightGrey)
                          //         ),
                          //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                          //         textStyle: const TextStyle(fontSize: 20, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w500)
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: const [
                          //         Icon(Icons.male_rounded, size: 20),
                          //         Text("\t\tMale"),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(width: 10,),
                          // Expanded(
                          //   child: TextButton(
                          //     onPressed: () => setState(() => isMale = false),
                          //     style: TextButton.styleFrom(
                          //         backgroundColor: !isMale ? AppColors.secondaryColor : Colors.white,
                          //         foregroundColor: isMale ? AppColors.secondaryColor : Colors.white,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(12),
                          //           side: const BorderSide(color: AppColors.lightGrey)
                          //         ),
                          //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                          //         textStyle: const TextStyle(
                          //             fontSize: 20,
                          //             fontFamily: Constants.fontFamily, fontWeight: FontWeight.w500)
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: const [
                          //         Icon(Icons.female_rounded, size: 20),
                          //         Text("\t\tFemale"),
                          //       ],
                          //     ),
                          //   ),
                          // ),
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
                          validator: (String? value) => value!.isEmpty ? "User name is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
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
          onPressed: handleSubmit,
          style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily)
          ),
          child: const Text("Submit"),
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
          price: double.tryParse(price.text)
        );
        bool res = await _apiService.uploadListing(payload);
        setState(() => loader = false);
        if(res) {
          Get.back();
          // Get.offAllNamed(AppRoutes.ROOT);
          // if(!mounted) return;
          // Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const BottomNavigation()));
        }
      }
      catch(e) {
        debugPrint("$e");
        setState(() => loader = false);
      }
    }
  }
}

