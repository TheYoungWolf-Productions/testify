import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testify/auth_storage.dart';
import 'package:testify/models/user_model_successful_login.dart';
import 'package:testify/models/user_model_unsuccessful_login.dart';
import 'package:testify/screens/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.fromWhere}) : super(key: key);

  final String fromWhere;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Data Fields:
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _isChecked = false;
  //To start animation
  bool _loaded = false;
  final _duration = const Duration(milliseconds: 450);
  var _dataPreviouslyStored = false;
  late UserModelSuccessfulLogin _successfulUser;
  late UserModelUnsuccessfulLogin _unsuccessfulUser;
  // var _successfulUser;
  // var _unsuccessfulUser;
  var _invalidUsername = false;
  var _invalidPassword = false;
  bool _isLoggingIn = false; // To start and finish CircularProgress Indicator

  //The data gets stored to local storage. Continue from there.
  AuthStorage storage = AuthStorage();

  //Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //To delete the auth file when the user logs out.
    if(widget.fromWhere == "Home") {
      storage.deleteFile();
      setState(() {
        _email = "";
        _password = "";
        _isChecked = false;
        _dataPreviouslyStored = false;
        _emailController.text = "";
        _passwordController.text = "";
      });
    }
    else {
      storage.readAuth().then((value) {
        if(value.isNotEmpty) {
          var temp = value.split(" ");
          setState(() {
            _email = temp[0];
            _password = temp[1];
            _dataPreviouslyStored = true;
            _emailController.text = temp[0];
            _passwordController.text = temp[1];
          });

        }
        else {

        }
      });
    }

    Future.delayed(const Duration(microseconds: 0), () {
      setState(() {
        _loaded = true;
      });
    });
  }

  //https://demo.pookidevs.com/auth/login
  Future<void> getUserData(BuildContext context, String email, String password) async {
    setState(() {
      _isLoggingIn = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const String apiUrl = "https://demo.pookidevs.com/auth/login";
    http.post(Uri.parse(apiUrl), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
    }, body: json.encode(
        {
          "user":
          {
            "user_email": email,
            "user_pass": password
          }
        })
    ).then((response) {
      // print(json.decode(response.body).toString());
      if(response.statusCode == 200) {
        setState(() {
          _isLoggingIn = false;
        });
        //The entered credentials are correct.
        if(json.decode(response.body).toString().substring(0,20) == "{data: {status: true") {
          final responseString = (response.body);
          var loginData = userModelSuccessfulLoginFromJson(responseString);
          final UserModelSuccessfulLogin successfulUser = loginData;
          setState(() {
            _successfulUser = successfulUser;
            _isLoggingIn = false;
          });
          //Saves Token to use later.
          prefs.setString('token', _successfulUser.data.token);
          prefs.setInt("userId", _successfulUser.data.id);
          _navigateAndDisplaySelection(context);
        }
        //Credentials are incorrect
        else if(json.decode(response.body).toString().substring(0,21) == "{data: {status: false") {
          final responseString = (response.body);
          var loginData = userModelUnsuccessfulLoginFromJson(responseString);
          final UserModelUnsuccessfulLogin unsuccessfulUser = loginData;
          setState(() {
            _unsuccessfulUser = unsuccessfulUser;
            _isLoggingIn = false;
          });
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(_unsuccessfulUser.data.message)));
          // _navigateAndDisplaySelection(context);
          var splitMessage = (_unsuccessfulUser.data.message).split(" ");
          if(splitMessage.length == 4) {
            setState(() {
              _invalidPassword = true;
              _invalidUsername = true;
            });
          }
          else if(splitMessage.length == 2) {
            setState(() {
              _invalidUsername = false;
              _invalidPassword = true;
            });
          }
        }
      } else {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }).catchError((error){
      setState(() {
        _isLoggingIn = false;
      });
      var errorSplit = error.toString().split(":");
      if(errorSplit[0].toLowerCase() == "socketexception") {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("No Internet Connection")));
      }
      // else if(errorSplit[0].toLowerCase() == "httpexception") {
      //   ScaffoldMessenger.of(context)
      //     ..removeCurrentSnackBar()
      //     ..showSnackBar(SnackBar(content: Text("Couldn't find the said thing.")));
      // }
      else if(errorSplit[0].toLowerCase() == "formatexception") {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text("Bad Response Format")));
      }
      else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.toString())));
      }
    });

  }

  //After form validation navigation to next screen.
  void _navigateAndDisplaySelection(BuildContext context) async {
    if(_successfulUser.data.status == true) {
      if(_isChecked == true) {
        storage.writeAuth(_email, _password);
        Navigator.pushNamed(context, '/home');
      }
      else {
        storage.writeAuth(_email, _password);
        storage.deleteFile();
        Navigator.pushNamed(context, '/home');
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height/926;
    var width=MediaQuery.of(context).size.width/428;
    return WillPopScope(
      onWillPop: () async {
        // ScaffoldMessenger.of(context)
        //   ..removeCurrentSnackBar()
        //   ..showSnackBar(SnackBar(content: Text("")));
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Color(0xff3F2668),//Color copied from xD=#3F2668
          body: SingleChildScrollView(
            child: Container(
              height: (MediaQuery.of(context).size.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AnimatedCrossFade(
                    crossFadeState: _loaded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: _duration,
                    firstChild: Container(
                      height: (MediaQuery.of(context).size.height) *0.3,
                      color: Colors.transparent,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image(
                          image: AssetImage("assets/Images/login_topLeftBubble_1.png"),
                        ),
                      ),
                    ),
                    secondChild: Container(
                      height: (MediaQuery.of(context).size.height) *0.3,
                      color: Colors.transparent,
                      child: Text(""),
                    ),
                  ),
                  SizedBox(height: (MediaQuery.of(context).size.height) *0.02159,),
                  AnimatedCrossFade(
                    crossFadeState: _loaded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: _duration,
                    secondChild: Text(""),
                    firstChild: Container(
                      child: Form(
                        key: _formKey,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Column(//Add extra space at the end of the container(the one that has TextFormField) so that the login button can be aligned.
                              children: [
                                    Container(//For Borders of lighter area //Main Container to add Welcome, TextFormFields and Login.
                                      //tbd: Get the color right!
                                      margin: EdgeInsets.only(top: 0, bottom: 0, left: (MediaQuery.of(context).size.width) *(31/428), right: (MediaQuery.of(context).size.width) *(31/428),),
                                      padding: EdgeInsets.only(top: 0, bottom: (MediaQuery.of(context).size.height) *0.0179, left: 0, right: 0,),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(176, 166, 194, 210),//0xffB0A6C2, rgba(176, 166, 194, 1)
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        border: Border.all(
                                          color: Color(0xff757575),
                                          width: 0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xff0000004D),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height) *0.020518, bottom: 0, left: 0, right: 0,),
                                          child: Text("Welcome!",
                                          style: TextStyle(
                                            color: Color(0xffFFFEFE),
                                            fontFamily: 'Brandon-bld',
                                            fontSize: (MediaQuery.of(context).size.height) *0.0410,//38,
                                          ),),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0,),
                                              child: Text("Don't have an account?",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(255, 255, 255, 100),
                                                  fontFamily: 'Brandon-med',
                                                  fontSize: (MediaQuery.of(context).size.height)*0.0194,
                                                ),),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0,),
                                              child: Text(" Sign Up",
                                                style: TextStyle(
                                                  color: Color(0xffFFFEFE),
                                                  fontFamily: 'Brandon-med',
                                                  fontSize: (MediaQuery.of(context).size.height)*0.0194,
                                                ),),
                                            ),
                                          ],
                                        ),
                                      SizedBox(height: (MediaQuery.of(context).size.height)*0.04535,),
                                      Container(
                                        //color: Colors.white,
                                        height: (MediaQuery.of(context).size.height)*0.055,
                                        //padding: EdgeInsets.fromLTRB(20.0, (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top)*0.0037797, 20.0, (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top)*0.0037797),
                                        margin: EdgeInsets.only(top: 0, bottom: 0, left: (MediaQuery.of(context).size.width) *(45/428), right: (MediaQuery.of(context).size.width) *(45/428),),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                            color: _invalidUsername == true ? Colors.red : Color(0xff757575),
                                            width: _invalidUsername == true ? 3 : 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xff0000004D),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: _emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            suffixIcon: _invalidUsername == true ? Text("!  ",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: (MediaQuery.of(context).size.height)*(20/926),
                                                fontFamily: 'Brandon-med',
                                              ),) : Text(""),
                                            suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                            hintText: "Username",
                                            hintStyle: TextStyle(color: _dataPreviouslyStored ? Color(0xff171616) : Color(0xffAEAEAE),
                                              fontSize: (MediaQuery.of(context).size.height)*(20/926),
                                              fontFamily: 'Brandon-med',),
                                            contentPadding: EdgeInsets.fromLTRB(20.0, (MediaQuery.of(context).size.height)*0.0037797, 20.0, (MediaQuery.of(context).size.height)*0.0037797),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0.0,
                                              ),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0.0,
                                              ),
                                            ),
                                          ),
                                          //validator: (val) => val!.isEmpty ? "Please enter a Username." : null,
                                          onChanged: (val) {
                                            setState(() {
                                              _dataPreviouslyStored == null ? val = "" :
                                              (_dataPreviouslyStored ? val = _email : _email = val);
                                              _email = val;
                                            });
                                            //_email = val;
                                          },
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: (MediaQuery.of(context).size.height)*(20/926),
                                            fontFamily: 'Brandon-med',
                                          ),
                                        ),
                                      ),
                                        SizedBox(height: (MediaQuery.of(context).size.height)*0.0226781,),
                                        Container(
                                          //color: Colors.white,
                                          height: (MediaQuery.of(context).size.height)*0.055,
                                          margin: EdgeInsets.only(top: 0, bottom: 0, left: (MediaQuery.of(context).size.width) *(45/428), right: (MediaQuery.of(context).size.width) *(45/428),),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(
                                              color: _invalidPassword == true ? Colors.red : Color(0xff757575),
                                              width: _invalidPassword == true ? 3 : 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff0000004D),
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: _passwordController,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              suffixIcon: _invalidPassword == true ? Text("!  ",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: (MediaQuery.of(context).size.height)*(20/926),
                                                  fontFamily: 'Brandon-med',
                                                ),) : Text(""),
                                              suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                              hintText: "Password",
                                              hintStyle: TextStyle(color: _dataPreviouslyStored ? Colors.black : Color(0xffAEAEAE),
                                                fontSize: (MediaQuery.of(context).size.height)*(20/926),
                                                fontFamily: 'Brandon-med',),
                                              contentPadding: EdgeInsets.fromLTRB(20.0, (MediaQuery.of(context).size.height)*0.0037797, 20.0, (MediaQuery.of(context).size.height)*0.0037797),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0.0,
                                                ),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0.0,
                                                ),
                                              ),
                                            ),
                                            //validator: (val) => val!.isEmpty ? "Please enter a Password." : null,
                                            onChanged: (val) {
                                              setState(() {
                                                // ignore: unnecessary_null_comparison
                                                setState(() {
                                                  _dataPreviouslyStored == null ? val = "" :
                                                  (_dataPreviouslyStored ? val = _password : _password = val);
                                                  _password = val;
                                                });
                                              });
                                            },
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: (MediaQuery.of(context).size.height)*(20/926),
                                              fontFamily: 'Brandon-med',
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: (MediaQuery.of(context).size.height)*0.024838,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if(_isChecked == false) {
                                                  setState(() {
                                                    _isChecked = true;
                                                  });
                                                } else if(_isChecked == true) {
                                                  setState(() {
                                                    _isChecked = false;
                                                  });
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(top: 0, bottom: 0, left: (MediaQuery.of(context).size.width) *(45/428), right: 0,),
                                                    height: (MediaQuery.of(context).size.height)*0.0167,
                                                    width: (MediaQuery.of(context).size.height)*0.0167,
                                                    color: Colors.white,
                                                      child: Transform.scale(
                                                        scale: (MediaQuery.of(context).size.height)*0.001,
                                                        child: Checkbox(
                                                          side: BorderSide(
                                                            color: Color(0xffB0A6C2),
                                                            width: 0,
                                                          ),
                                                          checkColor: Color(0xff3F2668),
                                                          activeColor: Colors.white,
                                                          value: _isChecked,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              _isChecked = value!;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 0, bottom: 0, left: (MediaQuery.of(context).size.width) *(5/428), right: 0,),
                                                    child: Text("Remember me!",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(255, 255, 255, 100),
                                                        fontFamily: 'Brandon-med',
                                                        fontSize: (MediaQuery.of(context).size.height)*0.0161987,
                                                      ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: (MediaQuery.of(context).size.width) *(45/428),),
                                              child: Text("Forgot Password?",
                                                style: TextStyle(
                                                  color: Color(0xffFFFEFE),
                                                  fontFamily: 'Brandon-med',
                                                  fontSize: (MediaQuery.of(context).size.height)*0.0161987,
                                                ),),
                                            ),
                                          ],
                                        ),
                                        _isLoggingIn ? Container() : SizedBox(height: height*80),
                                        _isLoggingIn ? SizedBox(
                                          height: height*80,
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: height*5,
                                              child: SizedBox(height: height*25,width:height*25,child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 1,))),
                                        ) : Container(),
                                  ],
                                ),
                                    ),
                                SizedBox(height: (MediaQuery.of(context).size.height) *(25/926),),
                              ],
                            ),
                            GestureDetector(
                              child: Container(//Login button
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                      "assets/Images/login.svg",
                                    height: (MediaQuery.of(context).size.height) *0.0486,
                                  ),
                                ),
                              ),
                              onTap: () {
                                if(_formKey.currentState!.validate()) {
                                  getUserData(context, _emailController.text, _passwordController.text);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    crossFadeState: _loaded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: _duration,
                    secondChild: Container(
                        height: (MediaQuery.of(context).size.height) *0.183,
                        child: Text("")),
                    firstChild: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          //alignment: Alignment.centerRight,
                          children: [
                            Positioned(
                              left: (MediaQuery.of(context).size.height) *(80/926),
                              top: (MediaQuery.of(context).size.height) *(50/926),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: SvgPicture.asset(
                                  "assets/Images/login_bottomRight.svg",
                                  height: (MediaQuery.of(context).size.height) *0.183,
                                  width: (MediaQuery.of(context).size.height) *0.183,
                                ),
                              ),
                            ),
                            Positioned(//Remove and add again
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: SvgPicture.asset(
                                    "assets/Images/login_bottomRight.svg",
                                    height: (MediaQuery.of(context).size.height) *0.183,
                                    width: (MediaQuery.of(context).size.height) *0.183,
                                    color: Colors.transparent,
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
