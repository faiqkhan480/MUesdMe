import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../navigation/bottom_navigation.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isMale = true;
  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
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
                          controller: emailController,
                          hintText: "First Name",
                          keyboardType: TextInputType.phone,
                          validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                        child: InputField(
                          controller: emailController,
                          hintText: "Last Name",
                          keyboardType: TextInputType.phone,
                          validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  // EMAIL FIELD
                  InputField(
                    controller: emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.phone,
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
                      Expanded(child: DropDownInputField(
                        items: const ["Pakistan", "India", "UAE"],
                        onChanged: handleCountry,
                        hintText: "Country",
                      )),
                      SizedBox(width: 20,),
                      Expanded(
                        child: InputField(
                          controller: dobController,
                          hintText: "DOB",
                          readOnly: true,
                          onTap: handleDate,
                          keyboardType: TextInputType.phone,
                          // validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                          onSubmit: (_) => FocusScope.of(context).nextFocus(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20,),
                  // PASSWORD FIELD
                  InputField(
                    controller: emailController,
                    hintText: "Password",
                    keyboardType: TextInputType.phone,
                    obscureText: true,
                    validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    trailingIcon: const Icon(CupertinoIcons.eye, color: AppColors.progressColor),
                  ),
                  const SizedBox(height: 20,),
                  // CONFIRM PASSWORD FIELD
                  InputField(
                    controller: emailController,
                    hintText: "Confirm Password",
                    keyboardType: TextInputType.phone,
                    obscureText: true,
                    validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    trailingIcon: const Icon(CupertinoIcons.eye, color: AppColors.progressColor),
                  ),
                  const SizedBox(height: 20,),

                  // SUBMIT BUTTON
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

  handleDate() async {
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

  handleCountry(String? val) {
    setState(() {
      selectedCountry = val;
    });
  }

  handleSubmit() {
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const BottomNavigation()));
  }
}
