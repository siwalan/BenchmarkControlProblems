#### Creation of OpenSees Model
import openseespy.opensees as ops
import math
import os

def Wsection(secID, matID, d, bf, tf, tw, nfdw, nftw, nfbf, nftf,  orient="Strong"):
    
    if (orient == "Weak"):
        dw = d-2*tf
        z1 = -d/2
        z2 = -dw/2
        z3 = dw/2
        z4 = d/2
        
        y1 = bf/2
        y2 = tw/2
        y3 = -tw/2
        y4 = -bf/2
    
        ops.section('Fiber',secID)
        ops.patch('quad',matID, nfbf, nftf, *[y1,z3], *[y1,z4], *[y4,z4], *[y4,z3]);
        ops.patch('quad',matID, nfbf, nftf, *[y2,z3], *[y3,z3], *[y3,z2], *[y2,z2]);
        ops.patch('quad',matID, nfbf, nftf, *[y1,z1], *[y1,z2], *[y4,z2], *[y4,z1]);
        
    else:
        dw = d-2*tf
        y1 = -d/2
        y2 = -dw/2
        y3 = dw/2
        y4 = d/2
        
        z1 = -bf/2
        z2 = -tw/2
        z3 = tw/2
        z4 = bf/2
        
        ops.section('Fiber',secID)
        ops.patch('quad',matID, nfbf, nftf, *[y1,z4], *[y1,z1], *[y2,z1], *[y2,z4]);
        ops.patch('quad',matID, nfbf, nftf, *[y2,z3], *[y2,z2], *[y3,z2], *[y3,z3]);
        ops.patch('quad',matID, nfbf, nftf, *[y3,z4], *[y3,z1], *[y4,z1], *[y4,z4]);

ops.wipe()
ops.model('basic', '-ndm', 2, '-ndf', 3)

meter = 1;
mm = 1/1000*meter;
Newton = 1
inch = 25.4*mm;
kip = 4448.2216*Newton;
sec = 1;

# Dependent units
sq_in = inch*inch;
ksi = kip/sq_in;
ft = 12*inch;

# Constants
pi = math.acos(-1);

LCol = 13*ft;
LBeam = 30*ft;

Nstory = 3; Nbay = 4;

for floor in range(0,Nstory+1):
    for column in range(1,Nbay+2):
        ops.node(column*10+floor, (column-1)*LBeam, floor*LCol)

for column in range(1,Nbay+2):
    ops.fix(column*10, 1,1,1)
    
## Material for Column
FyCol = 345/(1000**-2)  ;
EsCol=200000/(1000**-2)  ;
nu = 0.3
b = 0.04
ops.uniaxialMaterial('Steel01',1,FyCol,EsCol,b)

## Material for Beam
FyBeam = 248/(1000**-2)  ;
EsBeam= 200000/(1000**-2)  ;
nu = 0.3
b = 0.04
ops.uniaxialMaterial('Steel01',2,FyBeam,EsBeam,b)

d = 16.4*inch; bf = 16.0*inch; tf = 1.89*inch; tw = 1.18*inch;
Wsection(1,1,d, bf, tf, tw, 16, 16, 16, 16)
d = 17.1*inch; bf = 16.2*inch; tf = 2.26*inch; tw = 1.41*inch;
Wsection(2,1,d, bf, tf, tw, 16, 16, 16, 16)
d = 16.4*inch; bf=16*inch; tf=1.89*inch;tw=1.18*inch;
Wsection(3,1,d, bf, tf, tw, 16, 16, 16, 16)
d= 14.0*inch; bf=10.0*inch;tf=0.720*inch; tw=0.415*inch;
Wsection(4,1,d, bf, tf, tw, 16, 16, 16, 16, "Weak")

d = 32.9*inch; bf = 11.5*inch; tf = 0.740*inch; tw = 0.550*inch;
Wsection(5,2,d, bf, tf, tw, 16, 16, 16, 16)
d = 30.0*inch; bf = 10.5*inch; tf = 0.850*inch; tw = 0.565*inch;
Wsection(6,2,d, bf, tf, tw, 16, 16, 16, 16)
d = 23.7*inch; bf = 8.97*inch; tf = 0.585*inch; tw = 0.415*inch;
Wsection(7,2,d, bf, tf, tw, 16, 16, 16, 16)

for section in range(1,8):
    ops.beamIntegration('Lobatto',int(section),int(section),5)
    
ops.geomTransf('PDelta', 1)
ops.geomTransf('Linear', 2)

## Columns
ops.element('forceBeamColumn', 1011, *[10, 11], 1, 1)
ops.element('forceBeamColumn', 1112, *[11, 12], 1, 1)
ops.element('forceBeamColumn', 1213, *[12, 13], 1, 1)

ops.element('forceBeamColumn', 2021, *[20, 21], 1, 2)
ops.element('forceBeamColumn', 2122, *[21, 22], 1, 2)
ops.element('forceBeamColumn', 2223, *[22, 23], 1, 2)

ops.element('forceBeamColumn', 3031, *[30, 31], 1, 2)
ops.element('forceBeamColumn', 3132, *[31, 32], 1, 2)
ops.element('forceBeamColumn', 3233, *[32, 33], 1, 2)

ops.element('forceBeamColumn', 4041, *[40, 41], 1, 3)
ops.element('forceBeamColumn', 4142, *[41, 42], 1, 3)
ops.element('forceBeamColumn', 4243, *[42, 43], 1, 3)

ops.element('forceBeamColumn', 5051, *[50, 51], 1, 4)
ops.element('forceBeamColumn', 5152, *[51, 52], 1, 4)
ops.element('forceBeamColumn', 5253, *[52, 53], 1, 4)

## Beam
ops.element('forceBeamColumn', 1121, *[11, 21], 2, 5)
ops.element('forceBeamColumn', 2131, *[21, 31], 2, 5)
ops.element('forceBeamColumn', 3141, *[31, 41], 2, 5)

ops.element('forceBeamColumn', 1222, *[12, 22], 2, 6)
ops.element('forceBeamColumn', 2232, *[22, 32], 2, 6)
ops.element('forceBeamColumn', 3242, *[32, 42], 2, 6)

ops.element('forceBeamColumn', 1323, *[13, 23], 2, 7)
ops.element('forceBeamColumn', 2333, *[23, 33], 2, 7)
ops.element('forceBeamColumn', 3343, *[33, 43], 2, 7)

W2144Area= 13.0*inch*inch; 
W2144xI = 843*inch*inch*inch*inch;
ops.element('elasticBeamColumn', 4151, *[41,51], W2144Area, EsBeam, W2144xI, 2, '-release', 3)
ops.element('elasticBeamColumn', 4252, *[42,52], W2144Area, EsBeam, W2144xI, 2, '-release', 3)
ops.element('elasticBeamColumn', 4353, *[43,53], W2144Area, EsBeam, W2144xI, 2, '-release', 3)

## Rigid Diap
ops.equalDOF(11,21,1);
ops.equalDOF(11,31,1);
ops.equalDOF(11,41,1);
ops.equalDOF(11,51,1);

ops.equalDOF(12,22,1);
ops.equalDOF(12,32,1);
ops.equalDOF(12,42,1);
ops.equalDOF(12,52,1);

ops.equalDOF(13,23,1);
ops.equalDOF(13,33,1);
ops.equalDOF(13,43,1);
ops.equalDOF(13,53,1);

mass = 0
for floor in range(1, Nstory + 1):
    if (floor <= 2):
        massUsed = (1.195875000000000e+05)
    else:
        massUsed = (1.294475000000000e+05)

    for column in range(1, Nbay + 2):
        if (column == 1 or column == 5):
            ops.mass(column * 10 + floor, massUsed / 2, massUsed / 2, 10**(-10))
            mass += massUsed / 2
        else:
            ops.mass(column * 10 + floor, massUsed, massUsed / 2 ,  10**(-10))
            mass += massUsed
            
Nmodes = 6 
w2 = ops.eigen(Nmodes)

# Pick your modes and damping ratios
wi = w2[0]**0.5; zetai = 0.02 # 5% in mode 1
wj = w2[5]**0.5; zetaj = 0.02 # 2% in mode 3

import numpy as np

A = np.array([[1/wi, wi],[1/wj, wj]])
b = np.array([zetai,zetaj])

x = np.linalg.solve(A,2*b)

#             M    KT  KI  Kn
ops.rayleigh(x[0],0.0,0.0,x[1])
