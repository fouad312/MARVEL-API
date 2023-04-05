

import 'package:flutter/material.dart';
import 'package:test_apk/Athentification/Validateur.dart';
import 'package:test_apk/Componeents/TextFromF.dart';
import 'package:test_apk/constant.dart';

// ignore: must_be_immutable
class SignUp extends StatefulWidget {
  GlobalKey<FormState>? keySIgnup;
  SignUp({Key? key, this.keySIgnup}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

TextEditingController firstName = TextEditingController();
TextEditingController lastName = TextEditingController();

//

class _SignUpState extends State<SignUp> {
  // speciality doctors

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool getlocation = false;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.keySIgnup,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            100.h,
            TextFromF(
              mycontroller: firstName,
              isPasword: false,
              icon: Icon(
                Icons.person,
                color: secondColor,
              ),
              readOnly: false,
              isconfermePassword: false,
              inputtext: "First Name",
              validator: (val) => Validator().validatename(val!),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFromF(
              mycontroller: lastName,
              isPasword: false,
              icon: Icon(
                Icons.person,
                color: secondColor,
              ),
              readOnly: false,
              isconfermePassword: false,
              inputtext: "Last Name",
              validator: (val) => Validator().validatelastname(val!),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
