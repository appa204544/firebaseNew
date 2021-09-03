import 'package:firebase_learning_project/constants.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const ButtonWidget({Key? key, this.buttonText, this.buttonColor, this.textColor, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(100),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: kPrimaryLightColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText!,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: kPrimaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ButtonWidgetLeft extends StatelessWidget {
//   final String buttonText;
//   final Color buttonColor;
//   final Color textColor;
//   final VoidCallback onTap;

//   const ButtonWidgetLeft({
//     Key key,
//     this.buttonText,
//     this.buttonColor,
//     this.textColor,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           side: BorderSide(color: primary4),
//           borderRadius: BorderRadius.circular(100),
//         ),
//         clipBehavior: Clip.antiAlias,
//         elevation: 0,
//         color: buttonColor ?? white1,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 buttonText,
//                 style: Theme.of(context)
//                     .textTheme
//                     .button
//                     .copyWith(color: textColor ?? primary4),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
