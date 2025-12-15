% mode_n_TM = 1; % 绘制第n个本征模
Ez1_full = zeros(num_nodes,1);
for i = 1:num_nodes
    if ismember(i, boundary_nodes)
        Ez1_full(i) = 0; % 边界节点 Ez = 0
    else
        i_reduced = i - sum(boundary_nodes < i);
        Ez1_full(i) = Ez_modes(i_reduced, mode_n_TM);
    end
end
figure;
trisurf(msh.TRIANGLES(:,1:3), msh.POS(:,1), msh.POS(:,2), Ez1_full, 'FaceColor', 'interp', 'EdgeColor', 'none');
title(sprintf('TM Mode %d Ez Distribution', mode_n_TM));
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Ez');
colorbar; view(2);