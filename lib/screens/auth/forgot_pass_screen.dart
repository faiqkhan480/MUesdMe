import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/input_field.dart';
import '../../widgets/loader.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loader = false;

  bool showCode = false;
  bool updateForm = false;

  String buttonText = "Send Request";

  final AuthService _authService = Get.find<AuthService>();

  bool secure = true;
  bool confirmSecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            color: AppColors.secondaryColor,
            icon: const Icon(Icons.arrow_back)),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // EMAIL FIELD
                InputField(
                  controller: emailController,
                  labelText: "Email",
                  enabled: !showCode,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) => value!.isEmpty ? "Email is required!" : null,
                  onSubmit: (_) => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: 20,),

                if(showCode && !updateForm)...[
                  // CODE FIELD
                  InputField(
                    controller: codeController,
                    labelText: "Code",
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    validator: (String? value) => value!.isEmpty ? "Code is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 20,),
                ],

                if(updateForm)...[
                  // PASSWORD FIELD
                  InputField(
                    controller: passController,
                    labelText: "Password",
                    keyboardType: TextInputType.text,
                    obscureText: secure,
                    validator: (String? value) => value!.isEmpty ? "Password is required!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    trailingIcon: IconButton(
                        onPressed: () => setState(() => secure = !secure),
                        icon: Icon(secure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: AppColors.primaryColor)),
                  ),
                  const SizedBox(height: 20,),
                  // CONFIRM PASSWORD FIELD
                  InputField(
                    controller: confirmPassController,
                    labelText: "Confirm Password",
                    keyboardType: TextInputType.text,
                    obscureText: confirmSecure,
                    validator: (String? value) => value!.isEmpty ? "Confirm Password is required!" : value != passController.text ? "Confirm password is not matched!" : null,
                    onSubmit: (_) => FocusScope.of(context).nextFocus(),
                    trailingIcon: IconButton(
                        onPressed: () => setState(() => confirmSecure = !confirmSecure),
                        icon: Icon(confirmSecure ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: AppColors.primaryColor)),
                  ),
                  const SizedBox(height: 20,),
                ],

                // SUBMIT BUTTON
                if(loader)
                  const SizedBox(
                      height: 55,
                      child: Loader())
                else
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _handleSubmit,
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                          textStyle: const TextStyle(fontSize: 18, fontFamily: Constants.fontFamily, fontWeight: FontWeight.w800)
                      ),
                      child: Text(buttonText),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleSubmit() {
    if(!loader && _formKey.currentState!.validate()) {
      if(!showCode) {
        _sndForgotRequest();
      }
      else if(showCode && !updateForm){
        _verifyCode();
      }
      else if(updateForm) {
        _updatePass();
      }
    }
  }

  // SEND FORGOT PASS REQUEST
  _sndForgotRequest() async {
    try {
      setState(() => loader = true);
      bool res = await _authService.forgotPass(emailController.text);
      if(res) {
        setState(() {
          buttonText = "Submit";
          showCode = true;
        });
      }
      setState(() => loader = false);
    }
    catch(e) {
      debugPrint("$e");
      setState(() => loader = false);
    }
  }

  // VERIFY CODE RECEIVED FORM SERVER
  _verifyCode() async {
    try {
      setState(() => loader = true);
      bool res = await _authService.verifyPassCode(emailController.text, codeController.text);
      if(res) {
        setState(() => updateForm = true);
      }
      setState(() => loader = false);
    }
    catch(e) {
      debugPrint("$e");
      setState(() => loader = false);
    }
  }

  _updatePass() async {
    try {
      setState(() => loader = true);
      bool res = await _authService.updatePassword(emailController.text, passController.text);
      if(res) {
        setState(() => updateForm = true);
      }
      setState(() => loader = false);
    }
    catch(e) {
      debugPrint("$e");
      setState(() => loader = false);
    }
  }
}
