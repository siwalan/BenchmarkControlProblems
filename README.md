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

T1 = 2.308495285624674 s; F1 = 0.433182604368803 hz;

T2 = 0.8663962990169478 s; F2 = 1.154206223104421 hz;

T3 = 0.5003944305086168s ; F3 = 1.9984235215878967 hz;

T4 = 0.33122636480423545s ; F4 = 3.0190833407570965 hz;

T5 = 0.238455860283037s ; F5 = 4.193648245059032 hz;

T6 = 0.21310192365457478s ; F6 = 4.692590206838954 hz;

T7 = 0.208440378354854s ; F7 = 4.7975349492869155 hz;

T8 = 0.20047370144783241s ; F8 = 4.988185446659305 hz;

T9 = 0.1921842060521685s ; F9 = 5.20334121383809 hz;
