import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stylecase/screens/home.dart';
import 'package:stylecase/theme/app_colors.dart';
import 'package:stylecase/widgets/button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  late ConfirmationResult confirmationResult;
  bool isLoading = false;
  String screen = 'Login';

  FirebaseAuth auth = FirebaseAuth.instance;

  void generateOtp() async {
    setState(() => isLoading = true);
    try {
      if (screen == 'Login') {
        confirmationResult =
            await auth.signInWithPhoneNumber('+91${phoneController.text}');
        setState(() => isLoading = false);
        setState(() => screen = 'OTP');
      } else {
        await confirmationResult.confirm(otpController.text);
        setState(() => isLoading = false);
        Get.to(const Home(), transition: Transition.fade);
      }
    } catch (e) {
      debugPrint("otp error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isPhone
          ? AppBar(
              leading: Image.asset(
                'assets/StyleCase.png',
              ),
              backgroundColor: const Color(AppColors.primary),
              title: const Text('StyleCase'),
              centerTitle: true,
              titleTextStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          : null,
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Center(
              child: AnimatedSwitcher(
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final inAnimation = Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: const Offset(0.0, 0.0))
                        .animate(animation);
                    final outAnimation = Tween<Offset>(
                            begin: const Offset(-1.0, 0.0),
                            end: const Offset(0.0, 0.0))
                        .animate(animation);

                    if (screen != 'Login') {
                      return ClipRect(
                        child: SlideTransition(
                          position: inAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: child,
                          ),
                        ),
                      );
                    } else {
                      return ClipRect(
                        child: SlideTransition(
                          position: outAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: child,
                          ),
                        ),
                      );
                    }
                  },
                  duration: const Duration(milliseconds: 500),
                  child: screen == 'Login'
                      ? LoginCard(
                          phoneController: phoneController,
                          onTap: generateOtp,
                          isLoading: isLoading,
                        )
                      : OtpCard(
                          otpController: otpController,
                          onTap: generateOtp,
                          isLoading: isLoading,
                        )),
            ),
          ),
          if (!context.isPhone)
            Flexible(
              flex: 1,
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: const Color(AppColors.primary),
                child: Image.asset(
                  'assets/StyleCase.png',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OtpCard extends StatelessWidget {
  const OtpCard(
      {super.key,
      required this.otpController,
      required this.onTap,
      required this.isLoading});

  final TextEditingController otpController;
  final Function() onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Verify Your Phone Number",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  controller: otpController,
                  decoration: InputDecoration(
                      counterText: '',
                      label: const Center(
                          child: Text(
                        'Enter OTP',
                        style: TextStyle(fontSize: 14),
                      )),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      alignLabelWithHint: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 18),
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(24))),
                ),
              ),
              Button(
                title: 'Confirm OTP',
                onTap: onTap,
                margin: const EdgeInsets.only(top: 24),
                width: ButtonWidth.full,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  const LoginCard(
      {super.key,
      required this.phoneController,
      required this.onTap,
      required this.isLoading});

  final TextEditingController phoneController;
  final Function() onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Login to Your Account",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  controller: phoneController,
                  decoration: InputDecoration(
                      counterText: '',
                      label: const Center(
                          child: Text(
                        'Enter Your Phone Number',
                        style: TextStyle(fontSize: 14),
                      )),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      alignLabelWithHint: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 18),
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(24))),
                ),
              ),
              Button(
                title: 'Generate OTP',
                onTap: onTap,
                margin: const EdgeInsets.only(top: 24),
                width: ButtonWidth.full,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
