import 'package:flutter/material.dart';

class CustomButtonSquare extends StatelessWidget {
  final String buttonName;
  final Color buttonColor;
  final VoidCallback OnTap;
  final double width;
  final Color? textColor;
  final IconData? icon;

  const CustomButtonSquare(
      {Key? key,
      required this.buttonColor,
      required this.buttonName,
      required this.OnTap,
      this.width = 150,
      this.textColor = Colors.black,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 37,
      child: GestureDetector(
        onTap: OnTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: buttonColor,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonName,
                style: TextStyle(fontSize: 15, color: textColor),
              ),
              if (icon != null) SizedBox(width: 10),
              if (icon != null)
                Icon(
                  icon,
                  size: 19,
                )
            ],
          )),
        ),
      ),
    );
  }
}
