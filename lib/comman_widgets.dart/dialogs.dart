import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_learning_project/comman_widgets.dart/button_unfilled.dart';
import 'package:firebase_learning_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dialogs {
  showLoader(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SpinKitSquareCircle(
          size: 60,
          color: kPrimaryColor,
        );
      },
    );
  }

  noInternetDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      // dismissOnBackKeyPress: (sp.getBool(SpUtil.internetStatus)) ? false : true,
      dismissOnTouchOutside: false,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.ERROR,
      title: 'No internet connection available',
      desc: "Please check your internet connection and try again!",
    )..show();
  }

  infoDialog(BuildContext context,
      {String? title,
      String? discription,
      String? btnOkTxt,
      String? btnCancelTxt,
      void Function()? okOnTap,
      void Function()? cancelOnTap}) {
    return AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.INFO,
      title: title,
      desc: discription,
      btnOk: ButtonWidget(buttonText: btnOkTxt, onTap: okOnTap),
      btnCancel: (btnCancelTxt != "")
          ? ButtonWidget(
              buttonText: btnCancelTxt,
              onTap: cancelOnTap,
            )
          : Container(),
    )..show();
  }

  successDialog(BuildContext context,
      {String? title,
      String? discription,
      String? btnOkTxt,
      void Function()? okOnTap,}) {
    return AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.SUCCES,
      title: title,
      desc: discription,
      btnOk: ButtonWidget(buttonText: btnOkTxt, onTap: okOnTap),
    )..show();
  }
}
