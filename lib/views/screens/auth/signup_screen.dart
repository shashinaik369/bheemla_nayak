import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/controllers/auth_controller.dart';
import 'package:tiktok_tutorial/views/screens/auth/login_screen.dart';
import 'package:tiktok_tutorial/views/widgets/text_input_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create your\naccount",
                style: TextStyle(
                  color: Color(0xfff8f7ff),
                  fontSize: 32,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/images/profilep.png'),
                    // backgroundImage: NetworkImage(
                    //     'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                    backgroundColor: Colors.black,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 73,
                    child: IconButton(
                      onPressed: () => authController.pickImage(),
                      icon: const Icon(
                        Iconsax.add_circle5,
                        color: Colors.redAccent,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 321,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.50),
                  color: Color(0xfff8f7ff),
                ),
                child: Center(
                  child: TextInputField(
                    controller: _usernameController,
                    hintText: 'Username',
                    icon: Iconsax.user,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 321,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.50),
                  color: Color(0xfff8f7ff),
                ),
                child: Center(
                  child: TextInputField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Iconsax.game,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 321,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.50),
                  color: Color(0xfff8f7ff),
                ),
                child: Center(
                  child: TextInputField(
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Iconsax.lock,
                    isObscure: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 321,
                height: 76,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(39),
                  color: Color(0xff1adda8),
                ),
                child: InkWell(
                  onTap: () => authController.registerUser(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    authController.profilePhoto,
                  ),
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: buttonColor,
                        decoration: TextDecoration.underline,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
