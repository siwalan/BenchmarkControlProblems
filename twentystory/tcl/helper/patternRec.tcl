constraints Transformation
numberer    Plain
test        NormDispIncr 1.0e-6 100 2
algorithm   Newton
system      ProfileSPD
integrator Newmark 0.5 0.25
analysis Transient


set factor [expr 1.0*$g];
set endTime [expr 30.0];
set dt [expr 0.005];
set fmt1 "%s Pushover analysis: CtrlNode %.3i, dof %.1i, Disp=%.4f %s";	# format for screen/file output of DONE/PROBLEM analysis
set IDctrlNode 13
set IDctrlDOF 1
set filePath "helper/elcentro.txt"
set accelSeries "Series -dt 0.02 -filePath $filePath -factor $factor";	# define acceleration vector from file (dt=0.01 is associated with the input file gm)
pattern UniformExcitation 1 1 -accel $accelSeries;		# define where and how (pattern tag, dof) acceleration is applied
timeSeries Constant 1 1.0
    
set t [getTime]
set ok 0
set internalTimer 1

