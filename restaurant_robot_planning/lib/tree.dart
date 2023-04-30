

class Tree {
  List<Node> nodes = [];
  List<Edge> edges = [];

  // Constructor
  Tree();
}

class Node {
  double x;
  double y;

  // Constructor
  Node({required this.x, required this.y});

  // Getters
  double get getX => x;
  double get getY => y;

  // Setters
  set setX(double newX) => x = newX;
  set setY(double newY) => y = newY;
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
