import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testify/screens/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Data Fields:
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  bool _isChecked = false;

  //After form validation navigation to next screen.
  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    //Can be used to show if input is invalid.
    /*
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3F2668),//Color copied from xD=#3F2668
      body: SingleChildScrollView(
        child: Container(
          height: (MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: (MediaQuery.of(context).size.height) *0.3,
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image(
                    image: AssetImage("assets/Images/login_topLeftBubble_1.png"),
                  ),
                ),
              ),
              SizedBox(height: (MediaQuery.of(context).size.height) *0.02159,),
              Container(
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
                                      color: Color(0xff757575),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xff0000004D),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Color(0xffAEAEAE),
                                        fontSize: (MediaQuery.of(context).size.height)*0.0194,
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
                                    validator: (val) => val!.isEmpty ? "Please enter a Username." : null,
                                    onChanged: (val) {
                                      _username = val;
                                    },
                                    style: TextStyle(
                                      color: Colors.black,
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
                                        color: Color(0xff757575),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xff0000004D),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(color: Color(0xffAEAEAE),
                                          fontSize: (MediaQuery.of(context).size.height)*0.0194,
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
                                      validator: (val) => val!.isEmpty ? "Please enter a Password." : null,
                                      onChanged: (val) {
                                        setState(() {
                                          _password = val;
                                        });
                                      },
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: (MediaQuery.of(context).size.height)*0.024838,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
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
                                                  checkColor: Colors.white,
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
                                  SizedBox(height: (MediaQuery.of(context).size.height) *0.0864,),
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
                            _navigateAndDisplaySelection(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
