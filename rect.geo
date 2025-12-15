SetFactory("OpenCASCADE");
a = 0.5;
b = 1;

nx = 30; // x 方向分段数（沿线）
ny = 20; // y 方向层数（扫略）

p1 = newp; Point(p1) = {0, 0, 0, 1.0};
p2 = newp; Point(p2) = {b, 0, 0, 1.0};
l1 = newl; Line(l1) = {p1, p2};

Transfinite Line{l1} = nx Using Progression 1;

out[] = Extrude {0, a, 0} { Line{l1}; Layers{ny}; };


