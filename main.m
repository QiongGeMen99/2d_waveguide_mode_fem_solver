%% Two-Dimensional Waveguide Mode Solver
%% reference: "Theory and Computation of Electromagnetic Fields" by Jian-Ming Jin
%% Date: 2025-12-15
clc; clear all;
run("rect.m")
run("read_mesh.m")
mu = 4e-7*pi; eps = 8.854e-12;

%% Solve TM modes
num_eigenmodes_TM = 6; % Solve the first 6 eigenmodes
run("eigen_TM.m")

%% Calculate TM transverse field components
mode_n_TM = 5;
run("plot_fieldt_TM.m")

%% Plot Ez distribution
mode_n_TM = 3;
run("plot_Ez.m")

%% Solve TE modes
num_eigenmodes_TE = 6;
run("eigen_TE.m")

%% Calculate TE transverse field components
mode_n_TE = 1;
run("plot_fieldt_TE.m")

%% Plot Hz distribution
mode_n_TE = 1;
run("plot_Hz.m")
