import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:testify/auth_storage.dart';
import 'package:testify/screens/Authentication/login.dart';
import 'package:testify/screens/Welcome/side_menu_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("Press Logout Button")));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: SideMenuBar(),
        appBar: AppBar(
          backgroundColor: Color(0xff3F2668),
          elevation: 2,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xff7F1AF1),
                      Color(0xff482384)
                    ])
            ),
          ),
          title: const Text("Home",
            style: TextStyle(
              color: Color(0xffFFFEFE),
              fontFamily: 'Brandon-bld',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login(fromWhere:"Home")),
                );
                },
              child: SvgPicture.asset(
                "assets/Images/logout.svg",
                height: (MediaQuery.of(context).size.height) *(32/926),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
