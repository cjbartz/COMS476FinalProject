import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restaurant_robot_planning/obstacles.dart';
import 'tree.dart';

void main() {
  //test_bfs();
  //test_RRT();
  runApp(MyApp());
}

void test_bfs() {
  Node n1 = Node(x: 10, y: 10);
  Node n2 = Node(x: 11, y: 11);
  Node n3 = Node(x: 12, y: 12);
  Node n4 = Node(x: 13, y: 13);

  Edge e1 = Edge(node1: n1, node2: n2);
  Edge e2 = Edge(node1: n2, node2: n3);
  Edge e3 = Edge(node1: n2, node2: n4);
  Edge e4 = Edge(node1: n4, node2: n1);

  Tree myTree = Tree();
  myTree.add_node(n1);
  myTree.add_node(n2);
  myTree.add_node(n3);
  myTree.add_node(n4);

  myTree.add_edge(e1);
  myTree.add_edge(e2);
  myTree.add_edge(e3);
  myTree.add_edge(e4);

  List<Node> test = myTree.bfs(n1, n4);
  for (var node in test) {
    node.print_node();
  }
}

void test_RRT() {
  Node n1 = Node(x: 13.9, y: 17.9);
  Node n2 = Node(x: 76.2, y: 40.9);
  Tree myTree = Tree();
  print("Beginning RRT");
  myTree.generateRRT(n1, n2, [], 100, 0.1);
  myTree.printTree(n1);
  List<Node> test = myTree.bfs(n1, n2);
  for (var node in test) {
    node.print_node();
  }
  print("Ending RRT");
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
  List<Offset> _points = [Offset(10, 10)];
  List<Offset> _edgeCoordinates = [];
  List<Obstacle> _obstacles = [
    RectangleObstacle(top: 80, left: 50, width: 50, height: 50),
    RectangleObstacle(top: 80, left: 150, width: 50, height: 50),
    RectangleObstacle(top: 80, left: 250, width: 50, height: 50),
    RectangleObstacle(top: 80, left: 350, width: 50, height: 50),
    CircleObstacle(centerX: 125, centerY: 200, radius: 50),
    CircleObstacle(centerX: 275, centerY: 200, radius: 50),
    RectangleObstacle(top: 280, left: 50, width: 50, height: 50),
    RectangleObstacle(top: 280, left: 150, width: 50, height: 50),
  ];

  List<Offset> _getPath(){
    List<Offset> path = [];
    if(_points.length < 2){
      return [];
    }

    for (int i = 0; i < _points.length - 1; i++){
      Tree myTree = Tree();
      print("Printing my nodes: ");
      Node n1 = Node.fromOffset(_points[i]);
      n1.print_node();
      Node n2 = Node.fromOffset(_points[i+1]);
      n2.print_node();
      myTree.generateRRT(n1, n2, _obstacles, 100, 0.4);
      List<Node> test = myTree.bfs(n1, n2);
      for (var node in test) {
        print("Coord in Path: ");
        node.print_node();
        path.add(node.getOffset());
      }
    }
    return path;
  }

  int sortByEuclideanDistance(Offset a, Offset b) {
    Offset referencePoint = Offset(10, 10);

    double distanceA = sqrt(pow(a.dx - referencePoint.dx, 2) + pow(a.dy - referencePoint.dy, 2));
    double distanceB = sqrt(pow(b.dx - referencePoint.dx, 2) + pow(b.dy - referencePoint.dy, 2));

    if (distanceA < distanceB) {
      return -1;
    } else if (distanceA > distanceB) {
      return 1;
    } else {
      return 0;
    }
  }

  void sortByClosestPoints(List<Offset> points) {
    for (int i = 0; i < points.length - 1; i++) {
      int closestIndex = i + 1;
      double closestDistance = _euclideanDistance(points[i], points[closestIndex]);

      for (int j = i + 2; j < points.length; j++) {
        double distance = _euclideanDistance(points[i], points[j]);

        if (distance < closestDistance) {
          closestIndex = j;
          closestDistance = distance;
        }
      }

      if (closestIndex != i + 1) {
        // Swap the closest point with the point at position i + 1
        Offset temp = points[i + 1];
        points[i + 1] = points[closestIndex];
        points[closestIndex] = temp;
      }
    }
  }

  double _euclideanDistance(Offset a, Offset b) {
    return sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Robot App'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Stack(
              children: [
                GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      print(details.localPosition);
                      _points.add(details.localPosition);
                    });
                  },
                  child: CustomPaint(
                    painter: LinePainter(_edgeCoordinates),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),

                _obstacles[0].getWidget(),
                _obstacles[1].getWidget(),
                _obstacles[2].getWidget(),
                _obstacles[3].getWidget(),
                _obstacles[4].getWidget(),
                _obstacles[5].getWidget(),
                _obstacles[6].getWidget(),
                _obstacles[7].getWidget(),

                Positioned(
                  bottom: 50, // Adjust the horizontal position
                  right: 50, // Adjust the vertical position
                  child: ElevatedButton(
                    child: Text("Confirm"),
                    onPressed: () {
                      //_points.sort(sortByEuclideanDistance);
                      sortByClosestPoints(_points);

                      setState(() {
                        _edgeCoordinates = _getPath(); // Copy the _points list to _edgeCoordinates
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 50, // Adjust the horizontal position
                  left: 50, // Adjust the vertical position
                  child: ElevatedButton(
                    child: Text("Reset"),
                    onPressed: () {
                      setState(() {
                        _points = [Offset(10, 10)];
                        _edgeCoordinates = [];
                      });
                    },
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
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> coordinates;

  LinePainter(this.coordinates);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < coordinates.length - 1; i++) {
      canvas.drawLine(coordinates[i], coordinates[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.coordinates != coordinates;
  }
}

// // Black Rectangle
// Positioned(
// left: 100, // Adjust the horizontal position
// top: 100, // Adjust the vertical position
// child: Container(
// width: 100,
// height: 50,
// color: Colors.black,
// ),
// ),
// // Black Circle
// Positioned(
// left: 200, // Adjust the horizontal position
// top: 200, // Adjust the vertical position
// child: Container(
// width: 60,
// height: 60,
// decoration: BoxDecoration(
// color: Colors.black,
// shape: BoxShape.circle,
// ),
// ),
// ),
