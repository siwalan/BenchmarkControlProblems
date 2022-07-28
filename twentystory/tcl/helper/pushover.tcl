
wipeAnalysis

####### Recorder Stuff
# set RecorderFolder "PushoverAnalysis"
# set RecorderFolder "Result/$RecorderFolder"
# file mkdir $RecorderFolder

# recorder Node -file "$RecorderFolder/LeftColDisp.txt" -time -node 2 -dof 1 disp 
# recorder Node -file "$RecorderFolder/RightColDisp.txt" -time -node 4 -dof 1 disp 
# recorder Node -file "$RecorderFolder/LeftColForce.txt" -time -node 2 -dof 1 3 reaction 
# recorder Node -file "$RecorderFolder/RightColForce.txt" -time -node 4 -dof 1 3 reaction 
# recorder Element -file "$RecorderFolder/LeftCol.txt" -time -ele 12 section 1 fiber [expr $d/2] [expr $bf/2] stressStrain;
# recorder Element -file "$RecorderFolder/RightCol.txt" -time -ele 34 section 1 fiber [expr $d/2] [expr $bf/2] stressStrain;

set IDctrlNode 122
set IDctrlDOF 1

set LBuilding [nodeCoord 122 2]
set Dmax [expr 0.2*$LBuilding ];	
set NStep [expr 100]
set Dincr [expr $Dmax/$NStep ];	


pattern Plain 1 Linear {;
	load $IDctrlNode 1.0 0.0 0.0 
};	

constraints Transformation
numberer    Plain
test        NormDispIncr 1.0e-12 100 2
algorithm Newton       
system      ProfileSPD
integrator DisplacementControl  $IDctrlNode   $IDctrlDOF $Dincr
analysis Static

set fmt1 "%s Pushover analysis: CtrlNode %.3i, dof %.1i, Disp=%.4f %s";	# format for screen/file output of DONE/PROBLEM analysis

# if analysis fails, we try some other stuff, performance is slower inside this loop
set Dstep 0.0;
set ok 0
while {$Dstep <= 1.0 && $ok == 0} {	
	set controlDisp [nodeDisp $IDctrlNode $IDctrlDOF ]
	set Dstep [expr $controlDisp/$Dmax]
	set ok [analyze 1 ]
}

if {$ok != 0 } {
	puts [format $fmt1 "PROBLEM" $IDctrlNode $IDctrlDOF [nodeDisp $IDctrlNode $IDctrlDOF] $LunitTXT]
} else {
	puts [format $fmt1 "DONE"  $IDctrlNode $IDctrlDOF [nodeDisp $IDctrlNode $IDctrlDOF] $LunitTXT]
}   
