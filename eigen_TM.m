% Scalar field finite element: nable_t^2 Ez + k0^2 Ez = 0
% Unknown: Ez
% Dirichlet Boundary Condition: Ez = 0

% num_eigenmodes_TM = 6; % 求解前6个本征模

% 只计算非波导壁节点
N_TM=num_nodes-length(boundary_nodes);

% A_ij = iint grad_t N_i * grad_t N_j ds
% B_ij = iint N_i * N_j ds
A_TM = sparse(N_TM,N_TM);
B_TM = sparse(N_TM,N_TM);

for e = 1:num_elements
    node_ids = elements(e).node_id;
    area = elements(e).area;

    % 局部刚度矩阵
    A_e = (1/(4*area)) * ( elements(e).b' * elements(e).b + elements(e).c' * elements(e).c );

    % 局部质量矩阵
    B_e = (area/12) * ( ones(3,3) + eye(3) );

    % 装配到全局矩阵
    for i_local = 1:3
        i_global = node_ids(i_local);
        if ismember(i_global, boundary_nodes)
            continue; % 边界节点不参与计算
        end
        i_global_reduced = i_global - sum(boundary_nodes < i_global);

        for j_local = 1:3
            j_global = node_ids(j_local);
            if ismember(j_global, boundary_nodes)
                continue; % 边界节点不参与计算
            end
            j_global_reduced = j_global - sum(boundary_nodes < j_global);

            A_TM(i_global_reduced, j_global_reduced) = A_TM(i_global_reduced, j_global_reduced) + A_e(i_local, j_local);
            B_TM(i_global_reduced, j_global_reduced) = B_TM(i_global_reduced, j_global_reduced) + B_e(i_local, j_local);
        end
    end
end

% 求解广义特征值问题 A_TM * Ez = (k0^2) * B_TM * Ez
[Ez_modes, k0_TM_squared] = eigs(A_TM, B_TM, num_eigenmodes_TM, 'sm');

[k0_TM_squared, idx] = sort(diag(k0_TM_squared));
Ez_modes = Ez_modes(:, idx);

k0_TM = sqrt(k0_TM_squared);       % cutoff wavenumbers
lamda_TM = 2*pi./k0_TM;            % cutoff wavelengths
f_TM = k0_TM./(2*pi*sqrt(mu*eps)); % cutoff frequencies

fprintf('\nTM Mode cutoff parameters list (first %d eigenmodes):\n', num_eigenmodes_TM);
fprintf('%4s\t%12s\t%12s\t%12s\n', 'mode', 'k0', 'lambda(m)', 'f(Hz)');
for i = 1:length(k0_TM)
    fprintf('%4d\t%12.6e\t%12.6e\t%12.6e\n', i, k0_TM(i), lamda_TM(i), f_TM(i));
end
