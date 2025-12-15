SetFactory("OpenCASCADE");

r = 1; 

nt = 40;  
nr = 20;  

p1 = newp; Point(p1) = {0, 0, 0};
p2 = newp; Point(p2) = {r, 0, 0};
lr = newl; Line(lr) = {p1, p2};

Transfinite Line{lr} = nr Using Progression 1;

// 小于2pi
Extrude{ {0, 0, 1}, {0, 0, 0}, 3*Pi/4 }{ Line{lr}; Layers{nt};} 



