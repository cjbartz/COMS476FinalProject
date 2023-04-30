import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Offset> _points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CustomPaint example'),
      ),
      body: GestureDetector(
        onTapDown: (details) {
          setState(() {
            print(details.localPosition);
            _points.add(details.localPosition);
          });
        },
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              // Black Rectangle
              Positioned(
                left: 100, // Adjust the horizontal position
                top: 100, // Adjust the vertical position
                child: Container(
                  width: 100,
                  height: 50,
                  color: Colors.black,
                ),
              ),
              // Black Circle
              Positioned(
                left: 200, // Adjust the horizontal position
                top: 200, // Adjust the vertical position
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // User drawn circles
            ]..addAll(
              _points.map(
                    (point) => Positioned(
                  left: point.dx - 5.0,
                  top: point.dy - 5.0,
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
