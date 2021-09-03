import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_learning_project/Screens/Login/login_screen.dart';
import 'package:firebase_learning_project/Screens/Signup/components/background.dart';
import 'package:firebase_learning_project/Screens/Signup/components/or_divider.dart';
import 'package:firebase_learning_project/Screens/Signup/components/social_icon.dart';
import 'package:firebase_learning_project/Screens/Welcome/welcome_screen.dart';
import 'package:firebase_learning_project/comman_widgets.dart/button_unfilled.dart';
import 'package:firebase_learning_project/comman_widgets.dart/dialogs.dart';
import 'package:firebase_learning_project/components/already_have_an_account_acheck.dart';
import 'package:firebase_learning_project/components/rounded_button.dart';
import 'package:firebase_learning_project/components/rounded_input_field.dart';
import 'package:firebase_learning_project/components/rounded_password_field.dart';
import 'package:firebase_learning_project/constants.dart';
import 'package:firebase_learning_project/database/auth_exception_handler.dart';
import 'package:firebase_learning_project/database/auth_result_status.dart';
import 'package:firebase_learning_project/database/authentication.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  AuthService _authService = AuthService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.35,
              ),
              RoundedInputField(
                controller: _nameController,
                hintText: "Your Name",
                validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
              ),
              RoundedInputField(
                controller: _emailController,
                hintText: "Your Email",
                validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter email address';
                        }
                        return null;
                      },
              ),
              RoundedPasswordField(
                controller: _passwordController,
                validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
              ),
              RoundedButton(
                text: "SIGNUP",
                color: kPrimaryColor,
                textColor: kPrimaryLightColor,
                press: () async {
                        if (_formKey.currentState!.validate()) {
                          Dialogs().showLoader(context);
                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                          final status = await _authService.registerWithEmailAndPassword(
                                                  _nameController.text,
                                                  _emailController.text.trim(),
                                                  _passwordController.text.trim(),
                                                  formattedDate);
                          if (status == AuthResultStatus.successful) {
                              // await getUserID();
                              // await userDetails();
                              _firebaseMessaging.getToken().then((value) {
                                  if(value!=null){
                                     print(value.toString());
                                    }
                                    });
                                            Navigator.pop(context);
                                            Dialogs().successDialog(
                                              context,
                                              title: "Success",
                                              discription: "We have sent you verification mail.\n Please verify you mail and login.",
                                              btnOkTxt: "Ok",
                                              okOnTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) { 
                                              return LoginScreen();
                                              },),);
                                              }
                                            );
                                          } else {
                                            Navigator.pop(context);
                                            final errorMsg =
                                                AuthExceptionHandler
                                                    .generateExceptionMessage(
                                                        status);
                                            _showAlertDialog(errorMsg);
                                          }
                        }
                      },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    // press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/twitter.svg",
                    // press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    onTap: () async {
                      final status = await AuthService().signInWithGoogle(context);
                      if (status == AuthResultStatus.successful) {
                              // await getUserID();
                              // await userDetails();
                              _firebaseMessaging.getToken().then((value) {
                                  if(value!=null){
                                     print(value.toString());
                                    }
                                    });
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) { 
                                              return WelcomeScreen();}));
                                          } else {
                                            final errorMsg =
                                                AuthExceptionHandler
                                                    .generateExceptionMessage(
                                                        status);
                                            _showAlertDialog(errorMsg);
                                          }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

    _showAlertDialog(errorMsg) {
    return AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.ERROR,
      title: 'LOGIN FAILED',
      desc: errorMsg,
      btnOk: ButtonWidget(
        buttonText: "Try again",
        onTap: () async {
          Navigator.pop(context);
        },
      ),
    )..show();
  }

}
