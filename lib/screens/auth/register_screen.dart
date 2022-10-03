import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets.dart';
import '../../utils/constants.dart';
import '../../widgets/input_field.dart';
import '../../widgets/text_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController dobController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isMale = true;
  bool passSecure = true;
  bool confirmPassSecure = true;
  bool loader = false;
  // String? selectedCountry;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = Get.find<AuthService>();
  // final ApiService _apiService = Get.find<ApiService>();
  // final AuthService _authService = getIt<AuthService>();

  static String countryCodeToEmoji(String countryCode) {
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const TextWidget("Create Your Account\n", color: AppColors.secondaryColor, size: 22, weight: FontWeight.w700),
                  const TextWidget("Create your account to get all the features in this", color: AppColors.lightGrey),
                  const SizedBox(height: 50,),
                  // NAMES FIELD
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          controller: firstName,
                          hintText: "First Name",
                          keyboardType: TextInputType.text,
                          validator: (String? value) => value!.isEmpty ? "First name is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                        child: InputField(
                          controller: lastName,
                          hintText: "Last Name",
                          keyboardType: TextInputType.text,
                          validator: (String? value) => value!.isEmpty ? "Last name is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  // USER NAME FIELD
                  InputField(
                    controller: userName,
                    hintText: "User Name",
                    keyboardType: TextInputType.text,
                    inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s')),],
                    validator: (String? value) => value!.isEmpty ? "User name is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 20,),
                  // EMAIL FIELD
                  InputField(
                    controller: email,
                    hintText: "Email",
                    keyboardType: TextInputType.text,
                    validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 20,),
                  // GENDER SELECTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => setState(() => isMale = true),
                          style: TextButton.styleFrom(
                              backgroundColor: isMale ? AppColors.secondaryColor : Colors.white,
                              foregroundColor: !isMale ? AppColors.secondaryColor : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: AppColors.lightGrey)
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                              textStyle: const TextStyle(fontSize: 20, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w500)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.male_rounded, size: 20),
                              Text("\t\tMale"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: TextButton(
                          onPressed: () => setState(() => isMale = false),
                          style: TextButton.styleFrom(
                              backgroundColor: !isMale ? AppColors.secondaryColor : Colors.white,
                              foregroundColor: isMale ? AppColors.secondaryColor : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: AppColors.lightGrey)
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: Constants.fontFamily, fontWeight: FontWeight.w500)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.female_rounded, size: 20),
                              Text("\t\tFemale"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  // DOB & COUNTRY FIELDS
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          controller: country,
                          hintText: "Country",
                          readOnly: true,
                          onTap: handleCountry,
                          trailingIcon: country.text.isNotEmpty ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(countryCodeToEmoji(country.text),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ) : null,
                          keyboardType: TextInputType.text,
                          validator: (String? value) => value!.isEmpty ? "Country is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: InputField(
                          controller: dobController,
                          hintText: "DOB",
                          readOnly: true,
                          onTap: handleDate,
                          keyboardType: TextInputType.text,
                          validator: (String? value) => value!.isEmpty ? "Birth Date is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20,),
                  // PASSWORD FIELD
                  InputField(
                    controller: password,
                    hintText: "Password",
                    keyboardType: TextInputType.text,
                    obscureText: passSecure,
                    validator: (String? value) => value!.isEmpty ? "Password is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    trailingIcon: IconButton(
                        onPressed: () => setState(() => passSecure = !passSecure),
                        icon: Icon(passSecure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: AppColors.progressColor)),
                  ),
                  const SizedBox(height: 20,),
                  // CONFIRM PASSWORD FIELD
                  InputField(
                    controller: confirmPassword,
                    hintText: "Confirm Password",
                    keyboardType: TextInputType.text,
                    obscureText: confirmPassSecure,
                    validator: (String? value) => value!.isEmpty ? "Confirm Password is required!" : value != password.text ? "Confirm password is not matched!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    trailingIcon: IconButton(
                        onPressed: () => setState(() => confirmPassSecure = !confirmPassSecure),
                        icon: Icon(confirmPassSecure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: AppColors.progressColor)),
                  ),
                  const SizedBox(height: 20,),

                  // SUBMIT BUTTON
                  if(loader)
                    SizedBox(
                        height: 55,
                        child: Lottie.asset(Assets.loader))
                  else
                    SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: handleSubmit,
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                          textStyle: const TextStyle(fontSize: 18, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w800)
                      ),
                      child: const Text("Register"),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextWidget("Already have an account?", size: 18, weight: FontWeight.normal),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.progressColor,
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: Constants.fontFamily,
                                fontSize: 16
                            )
                        ),
                        child: const Text("Sign In"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleDate() async {
    DateTime? res = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1980),
        lastDate: DateTime.now()
    );
    if(res != null) {
      setState(() {
        selectedDate = res;
        dobController.text = DateFormat("dd-MMM-yyyy").format(res);
      });
    }
  }

  void handleCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false, // optional. Shows phone code before the country name.
      onSelect: (Country c) {
        setState(() {
          country.text = c.countryCode;
        });
      },
    );
  }

  Future<void> handleSubmit() async {
    if(!loader && _formKey.currentState!.validate()) {
      try {
        setState(() => loader = true);
        bool res = await _authService.registerUser(
          firstName.text, // FIRST NAME
          lastName.text, // LAST NAME
          userName.text, // USER NAME
          email.text, // EMAIL CONTROLLER
          isMale ? "Male" : "Female", // GENDER
          country.text, // COUNTRY
          dobController.text, // DATE OF BIRTH
          password.text // PASSWORD
        );
        setState(() => loader = false);
        if(res) {
          Get.offAndToNamed(AppRoutes.ROOT);
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
