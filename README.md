# 2D 均匀波导本征模 FEM 求解器（Octave）

基于标量有限元（线性三角形单元），对二维均匀波导横截面求解 TE/TM 截止本征模与对应场分布。实现参考 Jian-Ming Jin《Theory and Computation of Electromagnetic Fields》。

- TE：未知量 $H_z$，金属壁 Neumann 边界（$\frac{\partial H_z}{\partial n}=0）$。
- TM：未知量 $E_z$，金属壁 Dirichlet 边界（$E_z=0$。
- 输出：截止波数 $k_0$、截止波长 $\lambda$、截止频率 $f$，以及模态场分布（`Hz`/`Ez` 和横向 `Ex,Ey,Hx,Hy`）。

## 目录结构

- 网格（可直接运行的 .m 形式，由 Gmsh 导出）：
  - [rect.m](rect.m)、[circle.m](circle.m)、[sector.m](sector.m)、[sample.m](sample.m)
- 几何定义（Gmsh `.geo`，可自行改动后再导网格）：
  - [rect.geo](rect.geo)、[circle.geo](circle.geo)、[sector.geo](sector.geo)、[sample.geo](sample.geo)
- 核心脚本：
  - 主入口：[main.m](main.m)
  - 网格读取/预处理：[read_mesh.m](read_mesh.m)
  - 本征求解： [eigen_TE.m](eigen_TE.m)（TE），[eigen_TM.m](eigen_TM.m)（TM）
  - 绘图： [plot_Hz.m](plot_Hz.m)，[plot_Ez.m](plot_Ez.m)，[plot_fieldt_TE.m](plot_fieldt_TE.m)，[plot_fieldt_TM.m](plot_fieldt_TM.m)

## 依赖

- GNU Octave（或 MATLAB），需要稀疏广义特征值求解函数 `eigs`
- 可选：Gmsh（生成/修改几何并导出到 Octave/Matlab `.m` 网格）

## 快速开始

1. 在 Octave 中切到本目录并运行：

```bash
octave --no-gui main.m
```

2. 默认设置在 [main.m](main.m) 顶部：
   - 介质参数：`mu = 4e-7*pi; eps = 8.854e-12;`（真空）
   - 默认加载网格：`run("rect.m")`（可改成 `circle.m`/`sector.m`/`sample.m`）
   - 求解模态数：`num_eigenmodes_TM = 6; num_eigenmodes_TE = 6;`
   - 绘制的模序：`mode_n_TM` 与 `mode_n_TE`

3. 运行后将打印 TE/TM 截止参数表，并弹出对应模态场的等值面与矢量图。

## 自定义网格（使用 Gmsh）

1. 打开 `.geo`，或自行建模，二维剖分得到三角形网格。
2. 导出为 Octave/Matlab 格式（File → Export → 选择 `*.m`），变量结构需包含：
   - `msh.nbNod`、`msh.POS`、`msh.LINES`（边界线段，用于识别边界节点）、`msh.TRIANGLES`（三角单元的节点索引）
3. 将导出的 `.m` 放入项目根目录（或替换现有 `rect.m` 等），并在 [main.m](main.m) 中切换 `run("*.m")` 即可。

> 本项目附带的 [rect.m](rect.m)、[circle.m](circle.m)、[sector.m](sector.m)、[sample.m](sample.m) 均为 Gmsh 直接导出的示例网格。

## 求解流程概述

- 网格读入：[read_mesh.m](read_mesh.m)
  - 读取 `msh.POS`（节点）、`msh.TRIANGLES`（单元）、`msh.LINES`（边界），构造每个单元的系数 `a,b,c` 与面积，用于装配。
- TE 求解：[eigen_TE.m](eigen_TE.m)
  - 全量节点装配 `A_TE,B_TE`，解广义本征值问题：$A\,H_z = k_0^2\,B\,H_z$
  - 将最小特征值中的零模丢弃，得到 TE 截止 $k_0$ 与模态 $H_z$
- TM 求解：[eigen_TM.m](eigen_TM.m)
  - 识别边界节点并做缩减装配 `A_TM,B_TM`，解 $A\,E_z = k_0^2\,B\,E_z$，得到 TM 截止 $k_0$ 与模态 $E_z$
- 参数换算（均在脚本内完成）：
  - 若广义特征值为 $\lambda_{\mathrm{eig}}$，则 $k_0 = \sqrt{\lambda_{\mathrm{eig}}}$；$\lambda = \frac{2\pi}{k_0}$；$f = \frac{k_0}{2\pi\,\sqrt{\mu\,\varepsilon}}$。

## 绘图与后处理

- TM 标量场分布：[plot_Ez.m](plot_Ez.m)（`Ez` 等值面）
- TE 标量场分布：[plot_Hz.m](plot_Hz.m)（`Hz` 等值面）
- 横向场矢量：
  - TE：[plot_fieldt_TE.m](plot_fieldt_TE.m)（由 `Hz` 的横向梯度得到 `Ex,Ey,Hx,Hy`）
  - TM：[plot_fieldt_TM.m](plot_fieldt_TM.m)（由 `Ez` 的横向梯度得到 `Ex,Ey,Hx,Hy`）

## 参数与常见调整

- 更换几何：修改 [main.m](main.m) 中的 `run("rect.m")` 为其他网格脚本。
- 模态数量：`num_eigenmodes_TE / TM`
- 绘制模序：`mode_n_TE / TM`
- 介质参数：`mu, eps`（默认真空，可替换为均匀介质）

## 已知限制

- 均匀介质、PEC 边界，TE/TM 模假设适用于二维均匀波导。
- 一阶三角形单元；未包含材料分块与各向异性。
- 仅求截止本征值（横向问题），不包含传播常数与激励耦合。

## 参考

- Jian-Ming Jin, Theory and Computation of Electromagnetic Fields.

## 许可证

- 本项目采用 MIT License，见 [LICENSE](LICENSE)。
