import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tree.dart';

class Obstacle {
  bool isInCollision(Edge edge) {
    return false;
  }

  Widget getWidget() {
    return Text("RETURN");
  }
}

class RectangleObstacle extends Obstacle {
  double top;
  double left;
  double width;
  double height;

  // Constructor
  RectangleObstacle(
      {required this.top,
      required this.left,
      required this.width,
      required this.height});

  // Getters
  double get getTop => top;
  double get getLeft => left;
  double get getWidth => width;
  double get getHeight => height;

  // Setters
  set setTop(double newTop) => top = newTop;
  set setLeft(double newLeft) => left = newLeft;
  set setWidth(double newWidth) => width = newWidth;
  set setHeight(double newHeight) => height = newHeight;

  Widget getWidget() {
    return Positioned(
      left: left, // Adjust the horizontal position
      top: top, // Adjust the vertical position
      child: Container(
        width: width,
        height: height,
        color: Colors.black,
      ),
    );
  }

  @override
  bool isInCollision(Edge edge) {
    Node a = edge.node1;
    Node b = edge.node2;

    // Check if either point is inside the rectangle
    if (_isPointInside(a) || _isPointInside(b)) return true;

    // Check if any of the rectangle's edges intersect with the given edge
    List<Node> rectCorners = [
      Node(x: left, y: top),
      Node(x: left + width, y: top),
      Node(x: left + width, y: top + height),
      Node(x: left, y: top + height),
    ];

    for (int i = 0; i < rectCorners.length; i++) {
      Node corner1 = rectCorners[i];
      Node corner2 = rectCorners[(i + 1) % rectCorners.length];
      Edge rectEdge = Edge(node1: corner1, node2: corner2);

      if (_doEdgesIntersect(edge, rectEdge)) return true;
    }

    return false;
  }

  bool _isPointInside(Node point) {
    return point.x > left &&
        point.x < left + width &&
        point.y > top &&
        point.y < top + height;
  }

  bool _doEdgesIntersect(Edge edge1, Edge edge2) {
    double ax = edge1.node1.x;
    double ay = edge1.node1.y;
    double bx = edge1.node2.x;
    double by = edge1.node2.y;
    double cx = edge2.node1.x;
    double cy = edge2.node1.y;
    double dx = edge2.node2.x;
    double dy = edge2.node2.y;

    double det = (bx - ax) * (dy - cy) - (by - ay) * (dx - cx);

    if (det.abs() < 1e-10) return false;

    double s = ((cx - ax) * (by - ay) - (cy - ay) * (bx - ax)) / det;
    double t = ((cx - ax) * (dy - cy) - (cy - ay) * (dx - cx)) / det;

    return s >= 0 && s <= 1 && t >= 0 && t <= 1;
  }
}

class CircleObstacle extends Obstacle {
  double centerX;
  double centerY;
  double radius;

  // Constructor
  CircleObstacle(
      {required this.centerX, required this.centerY, required this.radius});

  // Getters
  double get getCenterX => centerX;
  double get getCenterY => centerY;
  double get getRadius => radius;

  // Setters
  set setCenterX(double newCenterX) => centerX = newCenterX;
  set setCenterY(double newCenterY) => centerY = newCenterY;
  set setRadius(double newRadius) => radius = newRadius;

  @override
  Widget getWidget() {
    return Positioned(
      left: centerX - radius, // Adjust the horizontal position
      top: centerY - radius, // Adjust the vertical position
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }


  @override
  bool isInCollision(Edge edge) {
    // Implement circle collision logic
    Node a = edge.node1;
    Node b = edge.node2;

    double vx = b.x - a.x;
    double vy = b.y - a.y;
    double cx = centerX - a.x;
    double cy = centerY - a.y;

    double edgeLengthSquared = vx * vx + vy * vy;
    double t = (cx * vx + cy * vy) / edgeLengthSquared;

    if (t < 0) t = 0;
    if (t > 1) t = 1;

    double closestX = a.x + t * vx;
    double closestY = a.y + t * vy;

    double dx = closestX - centerX;
    double dy = closestY - centerY;

    double distanceSquared = dx * dx + dy * dy;
    double radiusSquared = radius * radius;

    return distanceSquared <= radiusSquared;
  }
}
