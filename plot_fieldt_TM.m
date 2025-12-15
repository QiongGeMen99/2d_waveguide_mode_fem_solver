% 绘制 TM 模的横向电磁场分量 (Ex, Ey, Hx, Hy)
% mode_n_TM = 1; % 绘制第n个本征模

N_TM = num_nodes - length(boundary_nodes);

% 计算横向场分量（在非边界节点上）
Ex = zeros(N_TM,1);
Ey = zeros(N_TM,1);
Hx = zeros(N_TM,1);
Hy = zeros(N_TM,1);

for e = 1:num_elements
	node_ids = elements(e).node_id;
	area = elements(e).area;

	% 提取当前模的 Ez 在该单元节点的值
	Ez_local = zeros(3,1);
	for i_local = 1:3
		i_global = node_ids(i_local);
		if ismember(i_global, boundary_nodes)
			Ez_local(i_local) = 0; % 边界节点 Ez = 0
		else
			i_global_reduced = i_global - sum(boundary_nodes < i_global);
			Ez_local(i_local) = Ez_modes(i_global_reduced, mode_n_TM);
		end
	end

	dEz_dx = (elements(e).b * Ez_local) / (2*area);
	dEz_dy = (elements(e).c * Ez_local) / (2*area);

	for i_local = 1:3
		i_global = node_ids(i_local);
		if ismember(i_global, boundary_nodes)
			continue; % 边界节点不参与计算
		end
		i_global_reduced = i_global - sum(boundary_nodes < i_global);

		Ex(i_global_reduced) = (1/(1j*k0_TM(mode_n_TM)*mu)) * dEz_dy;
		Ey(i_global_reduced) = -(1/(1j*k0_TM(mode_n_TM)*mu)) * dEz_dx;
		Hx(i_global_reduced) = -(1/(1j*k0_TM(mode_n_TM)*eps)) * dEz_dx;
		Hy(i_global_reduced) = -(1/(1j*k0_TM(mode_n_TM)*eps)) * dEz_dy;
	end
end

% 映射回全局节点，边界置零
Ex_full = zeros(num_nodes,1); Ey_full = zeros(num_nodes,1);
Hx_full = zeros(num_nodes,1); Hy_full = zeros(num_nodes,1);
for i = 1:num_nodes
	if ismember(i, boundary_nodes)
		Ex_full(i) = 0; Ey_full(i) = 0;
		Hx_full(i) = 0; Hy_full(i) = 0;
	else
		i_reduced = i - sum(boundary_nodes < i);
		Ex_full(i) = Ex(i_reduced);
		Ey_full(i) = Ey(i_reduced);
		Hx_full(i) = Hx(i_reduced);
		Hy_full(i) = Hy(i_reduced);

	end
end

% 绘制矢量图：电场与磁场
figure; quiver(msh.POS(:,1), msh.POS(:,2), imag(Ex_full), imag(Ey_full), 'AutoScale','on');
title(sprintf('TM Mode %d Transverse Electric Field (Ex,Ey)', mode_n_TM));
xlabel('X (m)'); ylabel('Y (m)'); axis equal; grid on;

figure; quiver(msh.POS(:,1), msh.POS(:,2), imag(Hx_full), imag(Hy_full), 'AutoScale','on');
title(sprintf('TM Mode %d Transverse Magnetic Field (Hx,Hy)', mode_n_TM));
xlabel('X (m)'); ylabel('Y (m)'); axis equal; grid on;

% % 绘制强度分布（幅值）
% E_t_mag = sqrt(abs(Ex_full).^2 + abs(Ey_full).^2);
% H_t_mag = sqrt(abs(Hx_full).^2 + abs(Hy_full).^2);
%
% figure;
% trisurf(msh.TRIANGLES(:,1:3), msh.POS(:,1), msh.POS(:,2), E_t_mag, 'EdgeColor','none');
% view(2); colorbar; axis equal tight;
% title(sprintf('TM 模第 %d 个本征模 |E_t|', mode_n_TM));
% xlabel('X (m)'); ylabel('Y (m)');
%
% figure;
% trisurf(msh.TRIANGLES(:,1:3), msh.POS(:,1), msh.POS(:,2), H_t_mag, 'EdgeColor','none');
% view(2); colorbar; axis equal tight;
% title(sprintf('TM 模第 %d 个本征模 |H_t|', mode_n_TM));
% xlabel('X (m)'); ylabel('Y (m)');
