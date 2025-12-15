% mode_n_TE = 1;
Hz1 = Hz_modes(:, mode_n_TE);
figure;
trisurf(msh.TRIANGLES(:,1:3), msh.POS(:,1), msh.POS(:,2), Hz1, 'FaceColor','interp', 'EdgeColor', 'none');
title(sprintf('TE Mode %d Hz Distribution', mode_n_TE));
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Hz');
colorbar; view(2);
