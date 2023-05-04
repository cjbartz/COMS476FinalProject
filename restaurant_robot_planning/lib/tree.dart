

import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'obstacles.dart';

class Tree {
  List<Node> nodes = [];
  List<Edge> edges = [];

  // Constructor
  Tree();

  void add_node(Node new_node){
    nodes.add(new_node);
  }

  void add_edge(Edge new_edge){
    edges.add(new_edge);
  }

  List<Node> bfs(Node startNode, Node targetNode) {
    Map<Node, Node> visited = {}; // Keeps track of visited nodes and their parent
    Queue<Node> queue = Queue<Node>();

    visited[startNode] = startNode;
    queue.add(startNode);

    while (queue.isNotEmpty) {
      Node currentNode = queue.removeFirst();

      if (currentNode == targetNode) {
        return _buildPath(visited, currentNode);
      }

      for (Edge edge in edges) {
        if (edge.node1 == currentNode) {
          if (!visited.containsKey(edge.node2)) {
            visited[edge.node2] = currentNode;
            queue.add(edge.node2);
          }
        } else if (edge.node2 == currentNode) {
          if (!visited.containsKey(edge.node1)) {
            visited[edge.node1] = currentNode;
            queue.add(edge.node1);
          }
        }
      }
    }

    return [Node(x: 0, y: 0)]; // Return 0, 0 if no path is found
  }

  List<Node> _buildPath(Map<Node, Node> visited, Node currentNode) {
    List<Node> path = [];
    Node? node = currentNode;

    while (node != visited[node]) {
      path.add(node!);
      node = visited[node];
    }

    if (node != null) {
      path.add(node); // Add the start node
    }
    return path.reversed.toList();
  }

  void generateRRT(Node start, Node goal, List<Obstacle> obstacles, int maxNodes, double maxStepSize) {
    Random random = Random();

    nodes.add(start);
    bool notConnected = true;

    while(notConnected) {
      //print("Debugging this for loop: " + i.toString());
      // Generate a random point in the space
      double min_border = 0;
      double max_border_y = 600;
      double max_border_x = 410;
      double randomX = min_border + (max_border_x - min_border) * random.nextDouble();
      double randomY = min_border + (max_border_y - min_border) * random.nextDouble();
      Node randomPoint = Node(x: randomX, y: randomY);

      // Try and connect to goal
      if (random.nextInt(100) == 5){
        print("Attempting to connect to goal node");
        randomPoint = goal;
      }

      randomPoint.print_node();


      // Find the nearest point in the tree, considering both nodes and points on edges
      Node nearestPoint = start;
      double minDistance = _distance(nearestPoint, randomPoint);
      bool foundEdgeNode = false;
      Edge edgeNewPointIsOn = Edge(node1: Node(x: 0, y: 0), node2: Node(x: 0, y: 0));
      for (Edge edge in edges) {
        Node edgePoint = _nearestPointOnEdge(edge, randomPoint);
        double currentDistance = _distance(edgePoint, randomPoint);
        if (currentDistance < minDistance) {
          nearestPoint = edgePoint;
          minDistance = currentDistance;
          foundEdgeNode = true;
          edgeNewPointIsOn = edge;
        }
      }


      //Node newPoint = nearestPoint;

      // Check for collisions
      Edge newEdge = Edge(node1: nearestPoint, node2: randomPoint);
      bool collision = false;
      for (Obstacle obstacle in obstacles) {
        if (obstacle.isInCollision(newEdge)) {
          collision = true;
          print("WAS IN COLLISION");
          newEdge.node1.print_node();
          newEdge.node2.print_node();
          break;
        }
      }

      // If no collision, add the new point and edge to the tree
      if (!collision) {
        if(foundEdgeNode){
          _splitEdge(edgeNewPointIsOn, nearestPoint);
        }
        nodes.add(nearestPoint);
        edges.add(newEdge);
        if(randomPoint == goal){
          notConnected = false;
        }
      }
    }
  }

  void _splitEdge(Edge edge, Node newNode){
    edges.add(Edge(node1: edge.getNode1, node2: newNode));
    edges.add(Edge(node1: newNode, node2: edge.getNode2));
    edges.remove(edge);
  }

  Node _nearestPointOnEdge(Edge edge, Node point) {
    Node a = edge.node1;
    Node b = edge.node2;

    double vx = b.x - a.x;
    double vy = b.y - a.y;
    double px = point.x - a.x;
    double py = point.y - a.y;

    double edgeLengthSquared = vx * vx + vy * vy;
    double t = (px * vx + py * vy) / edgeLengthSquared;

    if (t < 0) t = 0;
    if (t > 1) t = 1;

    double nearestX = a.x + t * vx;
    double nearestY = a.y + t * vy;

    return Node(x: nearestX, y: nearestY);
  }


  // Using Eucliden Distance
  double _distance(Node a, Node b) {
    double dx = a.x - b.x;
    double dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }

  void printTree(Node root) {
    if (root == null) {
      print("The tree is empty.");
      return;
    }

    final visited = <Node>{};
    final queue = <Node>[];
    visited.add(root);
    queue.add(root);

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      final children = <Node>[];

      for (final edge in edges) {
        if (edge.node1 == current && !visited.contains(edge.node2)) {
          children.add(edge.node2);
          visited.add(edge.node2);
          queue.add(edge.node2);
        } else if (edge.node2 == current && !visited.contains(edge.node1)) {
          children.add(edge.node1);
          visited.add(edge.node1);
          queue.add(edge.node1);
        }
      }

      print("${current.coords()} -> ${children.map((c) => c.coords()).join(', ')}");
    }
  }


}

class Node {
  double x;
  double y;

  // Constructor
  Node({required this.x, required this.y});

  // Using this constructor example:
  // Offset myOffset = Offset(10.0, 20.0);
  // Node myNode = Node.fromOffset(myOffset);

  factory Node.fromOffset(Offset offset) {
    return Node(x: offset.dx, y: offset.dy);
  }

  // Getters
  double get getX => x;
  double get getY => y;

  // Setters
  set setX(double newX) => x = newX;
  set setY(double newY) => y = newY;

  void print_node(){
    print('' + x.toString() + ', ' + y.toString());
  }

  String coords(){
    return '(' + x.toString() + ', ' + y.toString() + ')';
  }

  Offset getOffset(){
    return Offset(x, y);
  }
}

class Edge {
  Node node1;
  Node node2;

  // Constructor
  Edge({required this.node1, required this.node2});

  // Getters
  Node get getNode1 => node1;
  Node get getNode2 => node2;

  // Setters
  set setNode1(Node new_node1) => node1 = new_node1;
  set setNode2(Node new_node2) => node2 = new_node2;
}
