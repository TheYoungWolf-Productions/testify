import 'package:flutter/material.dart';

// creating Stateless Widget for buttons
class MyButton extends StatelessWidget {

// declaring variables
  final color;
  final textColor;
  final String buttonText;
  final buttontapped;

//Constructor
  MyButton({this.color, this.textColor, required this.buttonText, this.buttontapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: buttontapped,
          child: Center(
            child: Container(
               height: 35,
               width: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
               BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    color: Colors.black45//Color(0xFFF9F8F9), // background color
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
              ),

                child: Center(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Brandon-bld',
                      fontSize: (MediaQuery.of(context).size.height*(20/926)),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ),
          ),


    );
  }
}

