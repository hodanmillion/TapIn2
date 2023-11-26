import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/components/my_button.dart';
import 'package:myapp/components/my_text_field.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/utils/colors.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;

  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                Image.asset(
                  'images/logo2.png',
                  // Replace with the actual path to your logo image
                  width: 100,
                  height: 100,
                ),
                // logo
                //Icon(
                //Icons.message,
                //size:100,
                //color: Colors.red[800],

                // ),
                const SizedBox(height: 50), //empty space

                SvgPicture.asset(
                  'images/login_logo.svg', // Replace with the actual path to your logo image
                ),
                const SizedBox(height: 20),

                //email
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false),
                //pass
                const SizedBox(height: 10),

                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true),
                const SizedBox(height: 25),

                //sign in button
                MyButton(onTap: signIn, text: "Sign In"),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: AppColors.primaryColor, letterSpacing: .5),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Sign Up!',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              letterSpacing: .5),
                        ),
                      ),
                    )
                  ],
                ),
                // IconButton(
                //   onPressed: () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => const PhoneVerification()));
                //   },
                //   icon: const Icon(Icons.phone),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
