# BenchmarkControlProblems

This is OpenSees implementation of Ohtori et al Nonlinear Benchmark Control Problem (https://ascelibrary.org/doi/10.1061/%28ASCE%290733-9399%282004%29130%3A4%28366%29). The model has been checked and found to have a similar eigenvalues number with Ohtori simulation (and previous simulation). However, it must be noted that the OpenSees model may have little bit smaller stifness due to the usage of Fiber Section.

Ohtori Nonlinear Benchmark Control Problem are based on SAC Phase II Building Design.

## 3 Story Building Eigenvalues
From Ohtori Paper, the first 3 Natural Period is : 0.99, 3.06, and 5.83 Hz

Eigenvalues:
T1 = 1.0097077067198548 s; F1 = 0.9903856267955097 hz;
T2 = 0.32667497129029194 s; F2 = 3.0611466683542576 hz;
T3 = 0.17080331473344545s ; F3 = 5.854687314239736 hz;
T4 = 0.14030860249371874s ; F4 = 7.1271467481458775 hz;
T5 = 0.09941529284564488s ; F5 = 10.058814608660155 hz;
T6 = 0.09053790203823787s ; F6 = 11.045097991973117 hz;

## 9 Story Building Eigenvalues
From Ohtori Paper, the first 3 Natural Period is 0.443, 1.18, 2.05, 3.09, and 4.27 Hz.

Eigenvalues:
T1 = 2.304761190476487 s; F1 = 0.433884431988921 hz;
T2 = 0.8653060661519121 s; F2 = 1.1556604525460952 hz;
T3 = 0.49979796514591623s ; F3 = 2.0008084660929932 hz;
T4 = 0.3309188610285402s ; F4 = 3.0218888004505575 hz;
T5 = 0.23822065895633499s ; F5 = 4.197788740829973 hz;
T6 = 0.2131066062898583s ; F6 = 4.692487095589349 hz;
T7 = 0.20844862663897565s ; F7 = 4.797345111474198 hz;
T8 = 0.2004962726946861s ; F8 = 4.98762389225455 hz;
T9 = 0.19221173690871163s ; F9 = 5.20259592927427 hz;
