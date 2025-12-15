num_nodes = msh.nbNod;
num_elements = size(msh.TRIANGLES,1);

nodes = msh.POS;

boundary_nodes = unique([msh.LINES(:,1); msh.LINES(:,2)]);

elements = struct;
elements(num_elements).node_id = zeros(1,3);
elements(num_elements).a = zeros(1,3);
elements(num_elements).b = zeros(1,3);
elements(num_elements).c = zeros(1,3);
elements(num_elements).area = 0;

for e = 1:num_elements
    elements(e).node_id(1) = msh.TRIANGLES(e,1);
    elements(e).node_id(2) = msh.TRIANGLES(e,2);
    elements(e).node_id(3) = msh.TRIANGLES(e,3);

    x1 = nodes(elements(e).node_id(1),1);
    y1 = nodes(elements(e).node_id(1),2);
    x2 = nodes(elements(e).node_id(2),1);
    y2 = nodes(elements(e).node_id(2),2);
    x3 = nodes(elements(e).node_id(3),1);
    y3 = nodes(elements(e).node_id(3),2);

    elements(e).a(1) = x2*y3 - x3*y2;
    elements(e).a(2) = x3*y1 - x1*y3;
    elements(e).a(3) = x1*y2 - x2*y1;

    elements(e).b(1) = y2 - y3;
    elements(e).b(2) = y3 - y1;
    elements(e).b(3) = y1 - y2;

    elements(e).c(1) = x3 - x2;
    elements(e).c(2) = x1 - x3;
    elements(e).c(3) = x2 - x1;

    elements(e).area = 0.5 * abs( elements(e).b(1)*elements(e).c(2) - elements(e).b(2)*elements(e).c(1) );
end



