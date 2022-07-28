try:
    import openseespy.opensees as ops
except:
    import opensees as ops

from LibsUnits import *
from SectionGenerator import *
from LibsUnits import *
from SectionGenerator import *

ops.wipe()
ops.model('basic', '-ndm', 2, '-ndf', 3)

LCol = [12.0, 12.0, 18.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0, 13.0]
LCol = [i * ft for i in LCol]

LBeam = 20*ft;
currentHeight = 0;
NBay = 5;
floorNumber = 0;

for floor in LCol:
    for column in range(1,NBay+2):
        ops.node(column*100+floorNumber, (column-1)*LBeam, currentHeight)
    currentHeight = currentHeight + floor
    floorNumber = floorNumber + 1
    
for column in range(1,7):
    ops.fix(column*100,1,1,0)

floorNumber = 2
for column in range(1,7):
    ops.fix(column*100+floorNumber,1,0,0)

for floorNumber in range(3,23):
    for column in range(2,7):
        ops.equalDOF(100+floorNumber,column*100+floorNumber,1,1)


FyCol = 345*MPa ;
EsCol=204000*MPa  ;
b = 0.01
ops.uniaxialMaterial('Steel01',1,FyCol,EsCol,b)

FyCol = 248*MPa ;
EsCol=204000*MPa  ;
b = 0.01
ops.uniaxialMaterial('Steel01',2,FyCol,EsCol,b)

nfdw, nftw, nfbf, nftf = [4,1,1,4]
sectionDatasCol = [[27.5*inch, 1.38*inch, 13.5*inch, 2.48*inch],[26.7*inch,1.16*inch,13.3*inch,2.09*inch],[26.0*inch,0.96*inch,13.1*inch,1.73*inch],[25.0*inch,0.705*inch,13.0*inch,1.22*inch],[24.3*inch,0.550*inch,12.8*inch,0.850*inch],[24.3*inch,0.515*inch,9.07*inch,0.875*inch]];
secIterator = 1;
for sectionData in sectionDatasCol:
    d,tw,bf,tf = sectionData
    Wsection(secIterator,1,d, bf, tf, tw,nfdw, nftw, nfbf, nftf)
    secIterator= secIterator+1

sectionDatasColBox = [[15.0*inch,15.0*inch,2.0*inch],[15.0*inch,15.0*inch,1.25*inch],[15.0*inch,15.0*inch,1.0*inch],[15.0*inch,15.0*inch,0.75*inch],[15.0*inch,15.0*inch,0.5*inch]]
for sectionData in sectionDatasColBox:
    b,h,t = sectionData
    Boxsection(secIterator, 1, b,h,t, nfdw, nftw, nfbf, nftf,  orient="Strong")
    secIterator= secIterator+1

sectionDataBeam = [[13.7*inch,0.230*inch,5.0*inch,0.335*inch],[29.7*inch,0.520*inch,10.50*inch,0.670*inch],[29.80*inch,0.545*inch,10.50*inch,0.760*inch],[26.7*inch,0.460*inch,10.99*inch,0.640*inch],[23.7*inch,0.430*inch,7.05*inch,0.590*inch],[20.8*inch,0.375*inch,6.53*inch,0.535*inch]]
for sectionData in sectionDataBeam:
    d,tw,bf,tf = sectionData
    Wsection(secIterator,2,d, bf, tf, tw,nfdw, nftw, nfbf, nftf)
    secIterator= secIterator+1


for section in range(1,secIterator+1):
    ops.beamIntegration('Lobatto',int(section),int(section),5)

ops.geomTransf('Linear', 1)
ops.geomTransf('PDelta', 2)

colListInterior = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 6]
ColumnInteriorLine = [2, 3, 4, 5]
floorNumber = 0;
for colSection in colListInterior:
    for colLine in ColumnInteriorLine:
        nodeI = colLine*100+floorNumber;
        nodeJ = colLine*100+floorNumber+1;
        ops.element('forceBeamColumn',nodeI*1000+nodeJ,nodeI,nodeJ,1,colSection)

colListExterior = [7, 7, 7, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 11, 11]
ColumnExteriorLine = [1,6]
floorNumber = 0;
for colSection in colListExterior:
    for colLine in ColumnExteriorLine:
        nodeI = colLine*100+floorNumber;
        nodeJ = colLine*100+floorNumber+1;
        ops.element('forceBeamColumn',nodeI*1000+nodeJ,nodeI,nodeJ,1,colSection)


beamList = [13, 13, 13, 13, 13, 13, 14, 14, 14, 14, 14, 14, 13, 13, 13, 13, 13, 13, 15, 15, 16, 17]
floorNumber = 1;
for beamSec in beamList:
    for column in range(1,6):
        nodeI = column*100+floorNumber;
        nodeJ = (column+1)*100+floorNumber;
        ops.element('forceBeamColumn',nodeI*1000+nodeJ,nodeI,nodeJ,1,beamSec)
    floorNumber = floorNumber +1;

massFloor = [5.31220, 5.31220, 5.63320, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.5164, 5.83760]

massFloor = [i * kg *10**5/(2*5) for i in massFloor]

floorNumber = 1;
for mass in massFloor: 
    for colLine in range(1,7):
        if (colLine == 1 or colLine == 6):
            rotationalMass = LBeam*(10**-6)*mass/(2*210);
            ops.mass(colLine*100+floorNumber,mass/2,mass/2,rotationalMass)
        else:
            rotationalMass = LBeam*(10**-6)*mass/(210);
            ops.mass(colLine*100+floorNumber,mass,mass,rotationalMass)
    floorNumber = floorNumber+1
            
Nmodes = 6 
w2 = ops.eigen(Nmodes)

# Pick your modes and damping ratios
wi = w2[0]**0.5; zetai = 0.02 # 2% in mode 1
wj = w2[5]**0.5; zetaj = 0.02 # 2% in mode 6

import numpy as np

A = np.array([[1/wi, wi],[1/wj, wj]])
b = np.array([zetai,zetaj])

x = np.linalg.solve(A,2*b)

#             M    KT  KI  Kn
ops.rayleigh(x[0],0.0,0.0,x[1])