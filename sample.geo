SetFactory("OpenCASCADE");

ms = 0.05;
Point(1) = {0, 0, 0, ms};
Point(2) = {1, 0, 0, ms};
Point(3) = {1, 1, 0, ms};
Point(4) = {0.5, 1, 0, ms};
Point(5) = {0.5, 0.5, 0, ms/20};
Point(6) = {0, 0.5, 0, ms};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 1};
Curve Loop(1) = {5, 6, 1, 2, 3, 4};
Plane Surface(1) = {1};
