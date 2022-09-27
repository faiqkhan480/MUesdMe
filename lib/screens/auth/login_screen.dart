import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:musedme/navigation/bottom_navigation.dart';
import 'package:musedme/screens/auth/register_screen.dart';
import 'package:musedme/utils/app_colors.dart';

import '../../services/auth_service.dart';
import '../../utils/assets.dart';
import '../../utils/constants.dart';
import '../../utils/di_setup.dart';
import '../../widgets/button_widget.dart';
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

  final AuthService _authService = getIt<AuthService>();

  bool loader = false;
  bool secure = true;

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
                  Image.asset(Assets.iconsLogo, fit: BoxFit.cover,),
                  const SizedBox(height: 50,),
                  // EMAIL FIELD
                  InputField(
                    controller: emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 20,),
                  // PASSWORD FIELD
                  InputField(
                    controller: passwordController,
                    hintText: "Password",
                    keyboardType: TextInputType.text,
                    obscureText: secure,
                    validator: (String? value) => value!.isEmpty ? "Password is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    trailingIcon: IconButton(
                        onPressed: () => setState(() => secure = !secure),
                        icon: Icon(secure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: AppColors.progressColor)),
                  ),
                  const SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => null,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.progressColor,
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

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.secondaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              elevation: 8,
                              shadowColor: AppColors.shadowColor.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.secondaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              elevation: 8,
                              shadowColor: AppColors.shadowColor.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              textStyle: const TextStyle(fontSize: 15, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w800)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(Assets.iconsFacebook, height: 38,),
                              const Text("\tFacebook "),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextWidget("Don't have an account?", size: 18, weight: FontWeight.normal),
                      TextButton(
                        onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => const RegisterScreen())),
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.progressColor,
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
      }
      catch(e) {
        debugPrint("$e");
        setState(() => loader = false);
      }
    }
    // Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const BottomNavigation()));
  }
}
