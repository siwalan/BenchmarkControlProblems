import openseespy.opensees as ops
import numpy as np
import scipy.linalg as slin

ops.database('File','C:\\Users\\AETL\\Documents\\GitHub\\OpenSeesScript\\Ohtori20Story\\model\\save\\20story')
ops.restore(1)

Nmodes = 6 
w2 = ops.eigen(Nmodes)

# Pick your modes and damping ratios
wi = w2[0]**0.5; zetai = 0.02 # 5% in mode 1
wj = w2[5]**0.5; zetaj = 0.02 # 2% in mode 3

A = np.array([[1/wi, wi],[1/wj, wj]])
b = np.array([zetai,zetaj])

x = np.linalg.solve(A,2*b)

#             M    KT  KI  Kn
ops.rayleigh(x[0],0.0,0.0,x[1])

ops.wipeAnalysis()
ops.system('FullGeneral')
ops.analysis('Transient')
ops.numberer('Plain')
# Mass
ops.integrator('GimmeMCK',1.0,0.0,0.0)
ops.analyze(1,0.0)
 
# Number of equations in the model
N = ops.systemSize() # Has to be done after analyze
 
M = ops.printA('-ret') # Or use ops.printA('-file','M.out')
M = np.array(M) # Convert the list to an array
M.shape = (N,N) # Make the array an NxN matrix
 
# Stiffness
ops.wipeAnalysis()
ops.system('FullGeneral')
ops.analysis('Transient')
ops.numberer('Plain')


ops.integrator('GimmeMCK',0.0,0.0,1.0)
ops.analyze(1,0.0)
K = ops.printA('-ret')
K = np.array(K)
K.shape = (N,N)
 
# Damping
ops.wipeAnalysis()
ops.system('FullGeneral')
ops.analysis('Transient')
ops.numberer('Plain')

ops.integrator('GimmeMCK',0.0,1.0,0.0)
ops.analyze(1,0.0)
C = ops.printA('-ret')
C = np.array(C)
C.shape = (N,N)

# Determine number of DOFs with mass
 
# Number of DOFs with mass
massDOFs = np.where(np.diag(M) != 0)[0]
Nmass = len(massDOFs)
 
# DOFs without mass
masslessDOFs = np.where(np.diag(M) == 0)[0]
Nmassless = len(masslessDOFs)
 
# Form matrices for D*x = -lam*B*x
B = np.zeros((2*Nmass,2*Nmass)) # = [ 0 M; M C]
D = np.zeros((2*Nmass,2*Nmass)) # = [-M 0; 0 K]
 
# Mass
B[:Nmass,:][:,Nmass:2*Nmass] =  M[massDOFs,:][:,massDOFs]
B[Nmass:2*Nmass,:][:,:Nmass] =  M[massDOFs,:][:,massDOFs]
D[:Nmass,:][:,:Nmass]        = -M[massDOFs,:][:,massDOFs]
 
# Damping
B[Nmass:2*Nmass,:][:,Nmass:2*Nmass] = C[massDOFs,:][:,massDOFs]
 
# Static condensation
Kmm = K[massDOFs,:][:,massDOFs];     Kmn = K[massDOFs,:][:,masslessDOFs]
Knm = K[masslessDOFs,:][:,massDOFs]; Knn = K[masslessDOFs,:][:,masslessDOFs]
# Kc = Kmm - Kmn*inv(Knn)*Knm
if Nmassless > 0:
    Kc = Kmm - np.dot(Kmn,np.linalg.solve(Knn,Knm))
else:
    Kc = K

np.savetxt('npM.txt',M[massDOFs,:][:,massDOFs])
np.savetxt('npC.txt',C[massDOFs,:][:,massDOFs])
np.savetxt('npK.txt',Kc)

# Stiffness at DOFs with mass
D[Nmass:2*Nmass,:][:,Nmass:2*Nmass] = Kc
