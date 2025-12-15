% 绘制 TE 模的横向电磁场分量 (Ex, Ey, Hx, Hy)
% mode_n_TE = 1; % 绘制第 n 个本征模

% TE 模所有节点均参与计算（Neumann 边界）
N_TE = num_nodes;
Ex = zeros(N_TE,1);
Ey = zeros(N_TE,1);
Hx = zeros(N_TE,1);
Hy = zeros(N_TE,1);

for e = 1:num_elements
	node_ids = elements(e).node_id;
	area = elements(e).area;

	% 提取当前模的 Hz 在该单元节点的值
	Hz_local = zeros(3,1);
	for i_local = 1:3
		i_global = node_ids(i_local);
		Hz_local(i_local) = Hz_modes(i_global, mode_n_TE);
	end

	% 单元梯度
	dHz_dx = (elements(e).b * Hz_local) / (2*area);
	dHz_dy = (elements(e).c * Hz_local) / (2*area);

	for i_local = 1:3
		i_global = node_ids(i_local);
		% TE 横向场关系：
		Ex(i_global) = (1/(1j*k0_TE(mode_n_TE)*eps)) * dHz_dy;
		Ey(i_global) = -(1/(1j*k0_TE(mode_n_TE)*eps)) * dHz_dx;
		Hx(i_global) = -(1/(1j*k0_TE(mode_n_TE)*mu)) * dHz_dx;
		Hy(i_global) = -(1/(1j*k0_TE(mode_n_TE)*mu)) * dHz_dy;
	end
end

% 绘制矢量图：电场与磁场
figure; quiver(msh.POS(:,1), msh.POS(:,2), imag(Ex), imag(Ey), 'AutoScale','on');
title(sprintf('TE Mode %d Transverse Electric Field (Ex,Ey)', mode_n_TE));
xlabel('X (m)'); ylabel('Y (m)'); axis equal; grid on;

figure; quiver(msh.POS(:,1), msh.POS(:,2), imag(Hx), imag(Hy), 'AutoScale','on');
title(sprintf('TE Mode %d Transverse Magnetic Field (Hx,Hy)', mode_n_TE));
xlabel('X (m)'); ylabel('Y (m)'); axis equal; grid on;

% 幅值分布
% E_t_mag = sqrt(abs(Ex).^2 + abs(Ey).^2);
% H_t_mag = sqrt(abs(Hx).^2 + abs(Hy).^2);
% figure;
% trisurf(msh.TRIANGLES(:,1:3), msh.POS(:,1), msh.POS(:,2), E_t_mag, 'EdgeColor','none');
% view(2); colorbar; axis equal tight;
% title(sprintf('TE 模第 %d 个本征模 |E_t|', mode_n_TE));
% xlabel('X (m)'); ylabel('Y (m)');
% figure;
% trisurf(msh.TRIANGLES(:,1:3), msh.POS(:,1), msh.POS(:,2), H_t_mag, 'EdgeColor','none');
% view(2); colorbar; axis equal tight;
% title(sprintf('TE 模第 %d 个本征模 |H_t|', mode_n_TE));
% xlabel('X (m)'); ylabel('Y (m)');


