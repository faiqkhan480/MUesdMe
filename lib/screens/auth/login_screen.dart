import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:musedme/routes/app_routes.dart';
import 'package:musedme/screens/auth/register_screen.dart';
import 'package:musedme/utils/app_colors.dart';

import '../../services/auth_service.dart';
import '../../utils/assets.dart';
import '../../utils/constants.dart';
import '../../widgets/input_field.dart';
import '../../widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = Get.find<AuthService>();

  bool loader = false;
  bool secure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(kDebugMode) {
      emailController.text = "faiq@yopmail.com";
      passwordController.text = "123456";
    }
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
                  // Image.asset(Assets.iconsLogo, fit: BoxFit.cover,), // PNG LOGO
                  SvgPicture.asset(Assets.logoSvg, fit: BoxFit.cover,), // SVG LOGO
                  const SizedBox(height: 50,),
                  // EMAIL FIELD
                  InputField(
                    controller: emailController,
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 20,),
                  // PASSWORD FIELD
                  InputField(
                    controller: passwordController,
                    labelText: "Password",
                    keyboardType: TextInputType.text,
                    obscureText: secure,
                    validator: (String? value) => value!.isEmpty ? "Password is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    trailingIcon: IconButton(
                        onPressed: () => setState(() => secure = !secure),
                        icon: Icon(secure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: AppColors.primaryColor)),
                  ),
                  const SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => null,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: Constants.fontFamily,
                          fontSize: 16
                        )
                      ),
                      child: const Text("Forgot Password?"),
                    ),
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
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 50,),

                  const TextWidget("Or sign in with", size: 18,),

                  const SizedBox(height: 20,),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     // Expanded(
                  //     //   child:
                  //       ElevatedButton(
                  //         onPressed: () => null,
                  //         style: ElevatedButton.styleFrom(
                  //             backgroundColor: Colors.white,
                  //             foregroundColor: AppColors.secondaryColor,
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(12)
                  //             ),
                  //             elevation: 8,
                  //             shadowColor: AppColors.shadowColor.withOpacity(0.4),
                  //             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  //             textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w800)
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             SvgPicture.asset(Assets.iconsGoogle, height: 38,),
                  //             const Text("\tGoogle"),
                  //           ],
                  //         ),
                  //       ),
                  //     // ),
                  //     // const SizedBox(width: 20,),
                  //     // Expanded(
                  //     //   child: ElevatedButton(
                  //     //     onPressed: () => null,
                  //     //     style: ElevatedButton.styleFrom(
                  //     //         backgroundColor: Colors.white,
                  //     //         foregroundColor: AppColors.secondaryColor,
                  //     //         shape: RoundedRectangleBorder(
                  //     //             borderRadius: BorderRadius.circular(12)
                  //     //         ),
                  //     //         elevation: 8,
                  //     //         shadowColor: AppColors.shadowColor.withOpacity(0.4),
                  //     //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //     //         textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w800)
                  //     //     ),
                  //     //     child: Row(
                  //     //       mainAxisAlignment: MainAxisAlignment.center,
                  //     //       children: [
                  //     //         SvgPicture.asset(Assets.iconsFacebook, height: 38,),
                  //     //         const Text("\tFacebook "),
                  //     //       ],
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextWidget("Don't have an account?", size: 18, weight: FontWeight.normal),
                      TextButton(
                        onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => const RegisterScreen())),
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: Constants.fontFamily,
                                fontSize: 16
                            )
                        ),
                        child: const Text("Sign Up"),
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

  Future<void> handleSubmit() async {
    if(!loader && _formKey.currentState!.validate()) {
      try {
        setState(() => loader = true);
        bool res = await _authService.loginUser(emailController.text, passwordController.text);
        setState(() => loader = false);
        if(res) {
          Get.offAndToNamed(AppRoutes.ROOT);
        }
      }
      catch(e) {
        debugPrint("$e");
        setState(() => loader = false);
      }
    }
  }
}
