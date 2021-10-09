import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:relatasapp/opportunity/opp_sliver_list.dart';
import '../utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var tcVisibility = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Padding(
            padding: EdgeInsets.all(15),
            child: ListView(
              children: <Widget>[
                Container(
                    width: 50.00,
                    height: 50.00,
                    margin: const EdgeInsets.only(top: 75.0),
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                      image: AssetImage('lib/images/logoname.png'),
                      fit: BoxFit.fitHeight,
                    ))),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      !tcVisibility
                          ? 'Enter your business email id registered with Relatas'
                          : "Enter the OTP we just sent to you on your email address",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      !tcVisibility
                          ? 'We will send you a One Time Password(OTP) on this email id'
                          : '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.normal,
                          fontSize: 14),
                    )),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Visibility(
                      visible: !tcVisibility,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email ID',
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Visibility(
                      visible: tcVisibility,
                      child: TextField(
                        obscureText: false,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter the OTP',
                        ),
                      ),
                    )),
                Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Visibility(
                      visible: !tcVisibility,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: parseColor('#ffc55b'),
                        ),
                        child: Text('Get OTP',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        onPressed: () async {
                          try {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            // var token = prefs.getString('token');

                            // print("Test token");
                            // print(token);
                          } catch (err) {}
                          if (EmailValidator.validate(nameController.text)) {
                            sendOtp(nameController.text).then((value) {
                              // var data = json.decode(value.body);
                              setState(() {
                                tcVisibility = true;
                              });
                            }).catchError((error) {
                              // print(error);
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please enter a valid email address",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity
                                    .TOP); // Also possible "TOP" and "CENTER"
                          }
                        },
                      )
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: const EdgeInsets.only(top: 00),
                    child: Visibility(
                        visible: tcVisibility,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: parseColor('#ffc55b'),
                          ),
                          child: Text('LOGIN',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          onPressed: () async {
                            if (passwordController.text.length == 6) {
                              verifyOtp(nameController.text,
                                      passwordController.text)
                                  .then((value) {
                                print('Verified');
                                var data = json.decode(value.body);

                                try {
                                  SharedPreferences.getInstance().then((prefs) {
                                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString(
                                        'token', data['userProfile']['token']);

                                    Navigator.maybePop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                        builder: (context) => new OppSliverList()),
                                    );

                                    // Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                                    // Navigator.of(context)
                                    //     .pushReplacementNamed("/home");
                                  });
                                } catch (error) {
                                  // print(error);
                                  setState(() {
                                    tcVisibility = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg:
                                          "Something went wrong. Please try again later.",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.TOP);
                                }
                              }).catchError((error) {
                                // print(error);
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please enter the six character OTP",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity
                                      .TOP); // Also possible "TOP" and "CENTER"
                            }
                          },
                        )
                    )
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 50),
                  child: Visibility(
                      visible: tcVisibility,
                      child: InkWell(
                        child: RichText(
                          text: TextSpan(
                            text: "Didn't get the OTP?",
                            style: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.normal,
                                fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Try Again',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: parseColor('#ffc55b')),
                              ),
                              // TextSpan(text: ' world!'),
                            ],
                          ),
                        ),
                        onTap: () => setState(() {
                          tcVisibility = false;
                        }),
                      )),
                ),
              ],
            )
        )
    );
  }

  Future sendOtp(emailId) async {
    return await http.get(
      Uri.parse(getBaseUrl() + "check/user/exists?emailId=" + emailId),
    );
  }

  Future verifyOtp(emailId, otp) async {
    return await http.get(
      Uri.parse(
          getBaseUrl() + "login/mobile?emailId=" + emailId + '&otp=' + otp),
    );
  }
}
