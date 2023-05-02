import 'package:flutter/material.dart';
import 'tree.dart';

void main() {
  //test_bfs();
  test_RRT();
  runApp(MyApp());
}

void test_bfs(){
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
  for(var node in test){
    node.print_node();
  }
}

void test_RRT(){
  Node n1 = Node(x: 13.9, y: 17.9);
  Node n2 = Node(x: 76.2, y: 40.9);
  Tree myTree = Tree();
  myTree.generateRRT(n1, n2, [], 100, 0.1);
  List<Node> test = myTree.bfs(n1, n2);
  for(var node in test){
    node.print_node();
  }
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
        title: Text('Restaurant Robot App'),
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
              Positioned(
                bottom: 50, // Adjust the horizontal position
                right: 50, // Adjust the vertical position
                child: ElevatedButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    //TODO
                  },
                )
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
