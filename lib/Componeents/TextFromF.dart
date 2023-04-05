
import 'package:flutter/material.dart';
import 'package:test_apk/constant.dart';

// ignore: must_be_immutable
class TextFromF extends StatefulWidget {
  TextInputType? keybord;
  Icon? icon;
  String? inputtext;

  TextEditingController? mycontroller;
  bool isPasword;
  bool? readOnly;
  bool isconfermePassword;

  String? Function(String?)? validator;

  TextFromF(
      {Key? key,
      this.keybord,
      required this.readOnly,
      this.inputtext,
      this.icon,
      this.mycontroller,
      required this.isPasword,
      required this.isconfermePassword,
      this.validator})
      : super(key: key);

  @override
  State<TextFromF> createState() => _TextFromFState();
}

class _TextFromFState extends State<TextFromF> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      readOnly: widget.readOnly == true ? true : false,
      controller: widget.mycontroller,
      keyboardType: widget.keybord,
      validator: widget.validator,
      style: const TextStyle(
        color: Colors.black,
        fontFamily: 'OpenSans',
      ),
      decoration: InputDecoration(
        //   filled: true,
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: secondColor)),

        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(width: 1, color: secondColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(width: 1, color: secondColor),
        ),
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(width: 1, color: secondColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(width: 1, color: secondColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide:
                BorderSide(width: 1, color: secondColor.withOpacity(0.5))),

        prefixIcon: Padding(
          padding: const EdgeInsets.all(0.0),
          child: widget.icon,
        ),
        suffixIcon: widget.isPasword == true
            ? Icon(
                Icons.visibility,
                color: secondColor,
              )
            : null,
        //   prefix: Image(image: AssetImage("images/user.png")),
        hintText: widget.inputtext,
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}
