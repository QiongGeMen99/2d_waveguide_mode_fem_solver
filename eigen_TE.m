% Scalar field finite element: nable_t^2 Hz + k0^2 Hz = 0
% Unknown: Hz
% Neumann Boundary Condition: dHz/dn = 0

% num_eigenmodes_TE = 6; % 求解前6个本征模

N_TE=num_nodes; % TE 模所有节点均参与计算
A_TE = sparse(N_TE,N_TE);
B_TE = sparse(N_TE,N_TE);
% A_ij = iint grad_t N_i * grad_t N_j ds
% B_ij = iint N_i * N_j ds
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

        for j_local = 1:3
            j_global = node_ids(j_local);

            A_TE(i_global, j_global) = A_TE(i_global, j_global) + A_e(i_local, j_local);
            B_TE(i_global, j_global) = B_TE(i_global, j_global) + B_e(i_local, j_local);
        end
    end
end

% 求解广义特征值问题 A_TE * Hz = (k0^2) * B_TE * Hz
[Hz_modes, k0_TE_squared] = eigs(A_TE, B_TE, num_eigenmodes_TE+1, 'sm');

[k0_TE_squared, idx] = sort(diag(k0_TE_squared));
Hz_modes = Hz_modes(:, idx);

% 去掉第一个零特征模
Hz_modes = Hz_modes(:,2:end);
k0_TE = sqrt(k0_TE_squared(2:end));  % cutoff wavenumbers
lamda_TE = 2*pi./k0_TE;              % cutoff wavelengths
f_TE = k0_TE./(2*pi*sqrt(mu*eps));   % cutoff frequencies

fprintf('\nTE Mode cutoff parameters list (first %d eigenmodes):\n', length(k0_TE));
fprintf('%4s\t%12s\t%12s\t%12s\n', 'mode', 'k0', 'lambda(m)', 'f(Hz)');
for i = 1:length(k0_TE)
    fprintf('%4d\t%12.6e\t%12.6e\t%12.6e\n', i, k0_TE(i), lamda_TE(i), f_TE(i));
end
