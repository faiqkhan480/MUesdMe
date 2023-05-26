import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool passSecure = true;
  bool confirmPassSecure = true;
  bool loader = false;
  Gender? _gender = Gender.male;
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
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: Get.height * 0.15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // NAMES FIELD
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            controller: firstName,
                            labelText: "First Name",
                            keyboardType: TextInputType.text,
                            validator: (String? value) => value!.isEmpty ? "First name is required!" : null,
                            onSubmit: (_) => FocusScope.of(context).nextFocus(),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: InputField(
                            controller: lastName,
                            labelText: "Last Name",
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
                      labelText: "User Name",
                      keyboardType: TextInputType.text,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s')),],
                      validator: (String? value) => value!.isEmpty ? "User name is required!" : null,
                      onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    const SizedBox(height: 20,),
                    // EMAIL FIELD
                    InputField(
                      controller: email,
                      labelText: "Email",
                      keyboardType: TextInputType.text,
                      validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                      onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    const SizedBox(height: 10,),
                    // GENDER SELECTION
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: RadioListTile(
                          value: Gender.male,
                          groupValue: _gender,
                          activeColor: AppColors.primaryColor,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          title: const Text("Male"),
                        )),

                        Expanded(child: RadioListTile(
                          value: Gender.female,
                          groupValue: _gender,
                          activeColor: AppColors.primaryColor,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          title: const Text("\t\tFemale"),
                        )),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    // Date Of Birth Fields
                    InputField(
                      controller: dobController,
                      labelText: "Date of Birth",
                      readOnly: true,
                      onTap: handleDate,
                      keyboardType: TextInputType.text,
                      validator: (String? value) => value!.isEmpty ? "Birth Date is required!" : null,
                      onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    ),

                    const SizedBox(height: 20,),
                    // PASSWORD FIELD
                    InputField(
                      controller: password,
                      labelText: "Password",
                      keyboardType: TextInputType.text,
                      obscureText: passSecure,
                      validator: (String? value) => value!.isEmpty ? "Password is required!" : null,
                      onSubmit: (_) => FocusScope.of(context).nextFocus(),
                      trailingIcon: IconButton(
                          onPressed: () => setState(() => passSecure = !passSecure),
                          icon: Icon(passSecure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: AppColors.primaryColor)),
                    ),
                    const SizedBox(height: 20,),
                    // CONFIRM PASSWORD FIELD
                    InputField(
                      controller: confirmPassword,
                      labelText: "Confirm Password",
                      keyboardType: TextInputType.text,
                      obscureText: confirmPassSecure,
                      validator: (String? value) => value!.isEmpty ? "Confirm Password is required!" : value != password.text ? "Confirm password is not matched!" : null,
                      onSubmit: (_) => FocusScope.of(context).nextFocus(),
                      trailingIcon: IconButton(
                          onPressed: () => setState(() => confirmPassSecure = !confirmPassSecure),
                          icon: Icon(confirmPassSecure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: AppColors.primaryColor)),
                    ),
                    const SizedBox(height: 20,),

                    // COUNTRY FIELDS
                    InputField(
                      controller: country,
                      labelText: "Country",
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

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                    ElevatedButton(
                      onPressed: googleSignIn,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          elevation: 8,
                          shadowColor: AppColors.shadowColor.withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w800)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.iconsGoogle, height: 38,),
                          const Text("\tGoogle"),
                        ],
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TextWidget("Already have an account?", size: 18, weight: FontWeight.normal),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryColor,
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

            Positioned(
              top: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    boxShadow: [BoxShadow(
                        color: AppColors.grayScale, // AppColors.shadow,
                        blurRadius: 4
                    )]
                ),
                width: Get.width,
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  children: const [
                    TextWidget("Create Your Account\n", color: AppColors.secondaryColor, size: 22, weight: FontWeight.w700),
                    TextWidget("Create your account to get all the features in this", color: AppColors.lightGrey),
                  ],
                ),
              ),
            ),
          ],
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
      await _sndSubmitReq(
          firstName.text, // FIRST NAME
          lastName.text, // LAST NAME
          userName.text, // USER NAME
          email.text, // EMAIL CONTROLLER
          _gender == Gender.male ? "Male" : "Female", // GENDER
          country.text, // COUNTRY
          dobController.text, // DATE OF BIRTH
          password.text, // PASSWORD
          0,
      );
    }
  }

  Future<void> googleSignIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(clientId: "760964256580-6pk2o061js4tmkc870ev2oab275v1aj4.apps.googleusercontent.com",).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var res = await FirebaseAuth.instance.signInWithCredential(credential);

    if(res.user != null) {
      await _sndSubmitReq(
        res.user!.displayName!.split(" ").first, // FIRST NAME
        res.user!.displayName!.split(" ").last, // LAST NAME
        res.user!.uid, // USER NAME
        res.user!.email!, // EMAIL CONTROLLER
        "", // GENDER
        "", // COUNTRY
        null, // DATE OF BIRTH
        "", // PASSWORD
        1,
      );
    }
  }

  _sndSubmitReq(String firstName, String lastName, String userName, String email, String gender, String country, String? dob, String password, int isSocial) async {
    try {
      setState(() => loader = true);
      bool res = await _authService.registerUser(
          firstName, // FIRST NAME
          lastName, // LAST NAME
          userName, // USER NAME
          email, // EMAIL CONTROLLER
          gender, // GENDER
          country, // COUNTRY
          dob, // DATE OF BIRTH
          password, // PASSWORD
          isSocial // PASSWORD
      );
      setState(() => loader = false);
      if(res) {
        Get.offAllNamed(AppRoutes.ROOT);
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

enum Gender { male, female }
