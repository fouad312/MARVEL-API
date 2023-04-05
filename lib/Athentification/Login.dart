// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_apk/Athentification/SIgnUp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;

import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:sms_autofill/sms_autofill.dart';
import 'package:test_apk/Screans/HomePage.dart';
import 'package:test_apk/constant.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  bool? signIn;
  Login({Key? key, this.signIn}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final keydoctorSignup = GlobalKey<FormState>();
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  String countryDial = "+213";
  String verID = " ";

  int screenState = 0;
  String otpPin = "";

  ///////////////////////////////
  ///verifyPhone Number
  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        showSnackBarText("Auth Completed!", context);
      },
      verificationFailed: (FirebaseAuthException e) {
        //print(e);
        showSnackBarText("Auth Failed!", context);
      },
      codeSent: (String verificationId, int? resendToken) async {
        showSnackBarText("OTP Sent!", context);
        verID = verificationId;
        await SmsAutoFill().getAppSignature;
        // print(signCode);
        Navigator.pop(context);
        setState(() {
          screenState = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBarText("Timeout!", context);
      },
    );
  }

  /// Veryfy Otp And Go NextPage
  Future<void> verifyOTP(bool isSignUp) async {
    await FirebaseAuth.instance
        .signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verID,
        smsCode: otpPin,
      ),
    )
        .whenComplete(() async {
      if (isSignUp == true) {
        await sendData();
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
      }
    });
  }

  /////////////////////////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        final b = await onbackPress(context);
        return b ?? false;
      },
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
                child: SizedBox(
                    // padding: const EdgeInsets.symmetric(
                    //   horizontal: 30,
                    // ),
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                screenState == 0 ? stateRegister() : Center(child: stateOTP()),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: sendCodeSubmiteCode(context),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ))),
          ),
        ),
      ),
    );
  }

  Future<void> sendData() async {
    // String? urlDwonload = "";
    // if (pickedFiledoctor != null) {
    //   UploadTask? uploadTask;

    //   final path = "files/${pickedFiledoctor!.path.split('/').last}";
    //   final file = File(pickedFiledoctor!.path);
    //   final ref = FirebaseStorage.instance.ref().child(path);

    //   uploadTask = ref.putFile(file);

    //   final snapshot = await uploadTask.whenComplete(() {});
    //   urlDwonload = await snapshot.ref.getDownloadURL();
    // }

    ///////////

    //   List<Message> l = [];

    FirebaseFirestore.instance
        .collection("clients")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'uID': FirebaseAuth.instance.currentUser!.uid,
      "firstName": firstName.text,
      "lastName": lastName.text,
      "dateCreate": DateTime.now(),
      "dateUpdate": DateTime.now(),
      'email': FirebaseAuth.instance.currentUser!.phoneNumber,
    }).whenComplete(() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    });
  }

  bool testOthers() {
    var formdata = keydoctorSignup.currentState;
    if (formdata!.validate()) {
      if (firstName.text != "" && lastName.text != "") {
        if (agree == true) {
          return true;
        } else {
          alert(
              context, "Error", "Please accept the terms and conditions");
          return false;
        }
      } else {
        alert(context, "Error", "Complete add information");
        return false;
      }
    } else {
      Navigator.of(context).pop();
      alert(context, "Error", "Complete add information");

      return false;
    }
  }

  bool exist = false;

  Future<void> testIfExist() async {
    String nbr = countryDial + phoneController.text;
    await FirebaseFirestore.instance
        .collection("clients")
        .where("email", isEqualTo: nbr.trim())
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        exist = true;
      } else {
        exist = false;
      }
    });
  }

  /// button
  bool isSIgnUp = false;
  RawMaterialButton sendCodeSubmiteCode(BuildContext context) {
    return RawMaterialButton(
      onPressed: () async {
        FocusScope.of(context).unfocus();
        if (screenState == 0) {
          if (phoneController.text.isEmpty) {
            showSnackBarText("Le numéro de téléphone est vide !", context);
          } else {
            // sendData();
          }
          if (phoneController.text.length < 9) {
            showSnackBarText("Le numéro de téléphone est invalide", context);
          } else {
            //////////////////////////////////////////////

            if (agree == true) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                        child: CircularProgressIndicator(
                          color: secondColor,
                        ),
                      ));
              await testIfExist();
              if (widget.signIn == true) {
                // Sign in
                print(exist);
                if (exist == true) {
                  // deja Exist
                  // Navigator.pop(context);

                  verifyPhone(countryDial + phoneController.text);
                } else {
                  // deja not Exist
                  //  FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  alert(context, "Error",
                      "you do not have an account, please register");
                  widget.signIn = false;
                  setState(() {});
                }
              } else {
                // SIgn up
                if (testOthers() == true) {
                  if (exist == false) {
                    // send data
                    isSIgnUp = true;
                    verifyPhone(countryDial + phoneController.text);
                    //     await sendData();
                  } else {
                    // deja Exist
                    Navigator.pop(context);

                    alert(context, "Error", "This number is already used");
                  }
                }
              }

              //verifyPhone(countryDial + phoneController.text);

            } else {
              alert(context, "Error",
                  "Please accept the terms and conditions");
            }
          }
        } else {
          if (otpPin.length >= 6) {
            verifyOTP(isSIgnUp);
          } else {
            showSnackBarText("Entrez OTP correctement !", context);
          }
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      fillColor: secondColor,
      splashColor: Colors.white,
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            screenState == 0 ? "Envoyer le code" : "Soumettre",
            style: const TextStyle(color: Colors.white),
          )),
    );
  }
  ///////////////////

  void showSnackBarText(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: secondColor,
      ),
    );
  }

// check terms
  bool agree = false;
  Widget checkTerms() {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: Checkbox(
            value: agree,
            activeColor: secondColor,
            onChanged: (value) {
              setState(() {
                agree = value ?? false;
              });
            },
          ),
        ),
        const Text(
          "I have read and accept the terms and conditions",
          style: TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  Widget stateRegister() {
    return Column(
      children: [
        widget.signIn == false
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SignUp(
                  keySIgnup: keydoctorSignup,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  200.h,
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                          fontSize: 22,
                          color: secondColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Connect to continue exploring",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
        20.h,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: phoneTextField(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: checkTerms(),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  IntlPhoneField phoneTextField() {
    return IntlPhoneField(
      controller: phoneController,
      invalidNumberMessage: "valid number (6 59 11 11 11 or 7 .. or 5..)",
      showCountryFlag: true,
      flagsButtonPadding: const EdgeInsets.only(left: 10),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      showDropdownIcon: false,
      initialValue: countryDial,
      onCountryChanged: (country) {
        setState(() {
          countryDial = "+${country.dialCode}";
        });
      },
      decoration: InputDecoration(
        //  ErreurStyle: TextStyle(),
        hintText: "Phone number",
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
      ),
    );
  }

  void _listen() async {
    await SmsAutoFill().listenForCode();
  }

  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        400.h,
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: "We just sent a code to ",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: "$countryDial 0${phoneController.text}",
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const TextSpan(
                text: "\n Enter the code here and we can continue!",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: PinFieldAutoFill(
            codeLength: 6,
            currentCode: otpPin,
            decoration: UnderlineDecoration(
                colorBuilder: FixedColorBuilder(secondColor),
                textStyle: const TextStyle(color: Colors.black54)),
            onCodeSubmitted: (val) {
              otpPin = val;
              setState(() {});
            },
            onCodeChanged: (val) {
              otpPin = val!;
              setState(() {});
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Didn't receive the code? ",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      screenState = 0;
                    });
                  },
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      color: secondColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
