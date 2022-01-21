import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3F2668),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 2,
        centerTitle: true,
        title: const Text("Home",
          style: TextStyle(
            color: Color(0xffFFFEFE),
            fontFamily: 'Brandon-bld',
          ),
        ),
        leading: Text(""),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(context, "logout"); },
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
