# BenchmarkControlProblems

This is OpenSees implementation of Ohtori et al Nonlinear Benchmark Control Problem (https://ascelibrary.org/doi/10.1061/%28ASCE%290733-9399%282004%29130%3A4%28366%29). The model has been checked and found to have a similar eigenvalues number with Ohtori simulation (and previous simulation). However, it must be noted that the OpenSees model may have little bit smaller stifness due to the usage of Fiber Section.

Ohtori Nonlinear Benchmark Control Problem are based on SAC Phase II Building Design.

## 3 Story Building Eigenvalues
From Ohtori Paper, the first 3 Natural Period is : 0.99, 3.06, and 5.83 Hz

OpenSees Eigenvalues:

T1 = 1.0097077067198548 s; F1 = 0.9903856267955097 hz;

T2 = 0.32667497129029194 s; F2 = 3.0611466683542576 hz;

T3 = 0.17080331473344545s ; F3 = 5.854687314239736 hz;

T4 = 0.14030860249371874s ; F4 = 7.1271467481458775 hz;

T5 = 0.09941529284564488s ; F5 = 10.058814608660155 hz;

T6 = 0.09053790203823787s ; F6 = 11.045097991973117 hz;

## 9 Story Building Eigenvalues
From Ohtori Paper, the first 3 Natural Period is 0.443, 1.18, 2.05, 3.09, and 4.27 Hz.

OpenSees Eigenvalues:

T1 = 2.2828241193542347 s; F1 = 0.4380538962777737 hz;

T2 = 0.8580391195210874 s; F2 = 1.1654480282415887 hz;

T3 = 0.4941623620073909s ; F3 = 2.0236263966721197 hz;

T4 = 0.32637281117134004s ; F4 = 3.063980717054943 hz;

T5 = 0.23433340427351512s ; F5 = 4.267424028171395 hz;

T6 = 0.2130554507135018s ; F6 = 4.693613782942882 hz;

T7 = 0.20825175457540232s ; F7 = 4.801880310871172 hz;

T8 = 0.20013860064375624s ; F8 = 4.996537383510467 hz;

T9 = 0.19202123573012056s ; F9 = 5.207757340992569 hz;
