import 'package:flutter/material.dart';
import 'buttons.dart';
import 'package:math_expressions/math_expressions.dart';
class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var userInput = '';
  var answer = '';
  final List<String> buttons = [
    '7',
    '8',
    '9',
    '%',
    'C',
    '4',
    '5',
    '6',
    'x',
    'DEL',
    '1',
    '2',
    '3',
    '+',
    '/',
    '.',
    '0',
    '=',
    '-',

  ];
  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }
// function to calculate the input operation
  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: (MediaQuery.of(context).size.height)*(310/926),
        width: (MediaQuery.of(context).size.width)*(237/428),
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white
          ),
          child: Column(
            children: <Widget>[

                  Container(
                    width: (MediaQuery.of(context).size.width)*(237/428),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userInput,
                            style: TextStyle(
                              color: Color(0xff7F1AF1),
                              fontFamily: 'Brandon-bld',
                              fontSize: (MediaQuery.of(context).size.height) * (20 / 926),
                            ),
                          ),),
                        Spacer(),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            answer,
                            style: TextStyle(
                              color: Color(0xff7F1AF1),
                              fontFamily: 'Brandon-bld',
                              fontSize: (MediaQuery.of(context).size.height) * (29 / 926),
                              ),
                              ),
                          ),

                      ]),
                ),
              Divider(),
                  Container(
                    height: (MediaQuery.of(context).size.height)*(237/926),
                    width: (MediaQuery.of(context).size.width)*(310/428),
                    padding: EdgeInsets.all(8),
                    child: GridView.builder(itemCount: buttons.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,mainAxisExtent: 40), itemBuilder: (BuildContext context, int index) {
                      // Clear Button
                      if (index == 4) {
                        return MyButton(
                          buttontapped: () {
                            setState(() {
                              userInput = '';
                              answer = '0';
                            });
                          },
                          buttonText: buttons[index],

                        );
                      }

                      // % Button
                      else if (index == 3) {
                        return MyButton(
                          buttontapped: () {
                            setState(() {
                              userInput += buttons[index];
                            });
                          },
                          buttonText: buttons[index],

                        );
                      }
                      // Delete Button
                      else if (index == 9) {
                        return MyButton(
                          buttontapped: () {
                            setState(() {
                              userInput =
                                  userInput.substring(0, userInput.length - 1);
                            });
                          },
                          buttonText: buttons[index],

                        );}
                      // Equal_to Button
                      else if (index == 17) {
                        return MyButton(
                          buttontapped: () {
                            setState(() {
                              equalPressed();
                            });
                          },
                          buttonText: buttons[index],

                        );
                      }
                      // other buttons
                      else {
                        return MyButton(
                          buttontapped: () {
                            setState(() {
                              userInput += buttons[index];
                            });
                          },
                          buttonText: buttons[index],

                        );
                      }
                    }),
                  )

            ],
          ),
        ),
      ),
    );
 }


    }



