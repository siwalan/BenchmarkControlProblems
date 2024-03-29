wipe

model BasicBuilder -ndm 2 -ndf 3;
source [file join [file dirname [info script]] "LibUnits.tcl"]


set NStory 3;
set NBay 4;
set LCol [expr 13*$ft];
set LBeam [expr 30*$ft];
# Node Generation ------
for {set floor 0} {$floor <= $NStory} {incr floor} {
        for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
            node $Columns$floor [expr ($Columns-1)*$LBeam] [expr ($floor)*$LCol]
            #puts stdout "Node $Columns$floor created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate  [expr ($floor)*$LCol]"
        }
    }

for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
    set floor 0
    fix $Columns$floor 1 1 1
    #puts stdout "Node $Columns$floor is fixed"
}

# Define Material
set Fy [expr 345*$MPa]
set Es [expr 204000*$MPa];		# Steel Young's Modulus
set hardening 0.01
set matIDhard 1
uniaxialMaterial Steel01  $matIDhard $Fy $Es $hardening
#uniaxialMaterial Steel02  $matIDhard $Fy $Es $hardening 10 0.925 0.15

set Fy [expr 248*$MPa]
set Es [expr 204000*$MPa];		# Steel Young's Modulus
set hardening 0.01
set matIDhard 2
uniaxialMaterial Steel01  $matIDhard $Fy $Es $hardening
#uniaxialMaterial Steel02  $matIDhard $Fy $Es $hardening 10 0.925 0.15

source [file join [file dirname [info script]] "sectionData.tcl"]

### Element Transformation Command

geomTransf Linear 1
geomTransf PDelta 2

#### Columns Setup
# Defined per Line

element forceBeamColumn  1011 10 11 1 Lobatto 1 5
element forceBeamColumn  1112 11 12 1 Lobatto 1 5
element forceBeamColumn  1213 12 13 1 Lobatto 1 5

element forceBeamColumn  2021 20 21 1 Lobatto 2 5
element forceBeamColumn  2112 21 22 1 Lobatto 2 5 
element forceBeamColumn  2213 22 23 1 Lobatto 2 5

element forceBeamColumn  3031 30 31 1 Lobatto 2 5
element forceBeamColumn  3132 31 32 1 Lobatto 2 5
element forceBeamColumn  3233 32 33 1 Lobatto 2 5

element forceBeamColumn  4041 40 41 1 Lobatto 3 5
element forceBeamColumn  4142 41 42 1 Lobatto 3 5
element forceBeamColumn  4243 42 43 1 Lobatto 3 5

element forceBeamColumn  5051 50 51 1 Lobatto 4 5
element forceBeamColumn  5152 51 52 1 Lobatto 4 5
element forceBeamColumn  5253 52 53 1 Lobatto 4 5

##### Beams Setup
# Defined per Floor

#First Floor, from Left to Right
element forceBeamColumn 1121 11 21 1 Lobatto 5 5
element forceBeamColumn 2131 21 31 1 Lobatto 5 5
element forceBeamColumn 3141 31 41 1 Lobatto 5 5

element forceBeamColumn 1222 12 22 1 Lobatto 6 5
element forceBeamColumn 2232 22 32 1 Lobatto 6 5
element forceBeamColumn 3242 32 42 1 Lobatto 6 5

element forceBeamColumn 1323 13 23 1 Lobatto 7 5
element forceBeamColumn 2333 23 33 1 Lobatto 7 5
element forceBeamColumn 3343 33 43 1 Lobatto 7 5

### This is the Gravity Beam using elasticBeamColumn
set W2144Area [expr 13.0*$inch*$inch]; 
set W2144xI  [expr 843*$inch*$inch*$inch*$inch];

element elasticBeamColumn 4151 41 51 $W2144Area $W2144xI [expr 204000*$MPa] 2 -release 3;
element elasticBeamColumn 4252 42 52 $W2144Area $W2144xI [expr 204000*$MPa] 2 -release 3;
element elasticBeamColumn 4353 43 53 $W2144Area $W2144xI [expr 204000*$MPa] 2 -release 3;

### Rigid DisplayPlane
equalDOF 11 21 1;
equalDOF 11 31 1;
equalDOF 11 41 1;
equalDOF 11 51 1;

equalDOF 12 22 1;
equalDOF 12 32 1;
equalDOF 12 42 1;
equalDOF 12 52 1;

equalDOF 13 23 1;
equalDOF 13 33 1;
equalDOF 13 43 1;
equalDOF 13 53 1;

set m1 11.95875
set m2 11.95875
set m3 12.94475

set massFloorRaw {$m1 $m2 $m3}
set massFloor []
foreach  item $massFloorRaw {
    lappend massFloor [expr $item*$kg*pow(10,4)]
}
set floor 1
set totalBuildingMass 0

if {[string equal $LunitTXT "mm"]} {
    set alpha [expr pow(10,-12)]
} elseif {[string equal $LunitTXT "meter"]} {
    set alpha [expr pow(10,-6)]
}

foreach massAssignment $massFloor {
        set floorCode $floor

        for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
            if {$Columns == 1 || $Columns == 5} {
                set rotationalMass [expr pow($LBeam,2)*$alpha*$massAssignment/(2*210)]
                mass $Columns$floorCode [expr $massAssignment/2] [expr $massAssignment/2]  $rotationalMass
                #puts stdout "Mass at $Columns$floorCode defined as [expr $massAssignment/2] with Rotational Mass of $rotationalMass"
                set totalBuildingMass [expr $totalBuildingMass+$massAssignment]
            } else {
                set rotationalMass [expr pow($LBeam,2)*$alpha*$massAssignment/(210)]
                mass $Columns$floorCode $massAssignment  $massAssignment $rotationalMass
                #puts stdout "Mass at $Columns$floorCode defined as $massAssignment with Rotational Mass of $rotationalMass"
                set totalBuildingMass [expr $totalBuildingMass+$massAssignment*2]
            }

        }
        set floor [expr $floor + 1]
}

# RAYLEIGH damping parameters, Where to put M/K-prop damping, switches (http://opensees.berkeley.edu/OpenSees/manuals/usermanual/1099.htm)
# D=$alphaM*M + $betaKcurr*Kcurrent + $betaKcomm*KlastCommit + $beatKinit*$Kinitial
set xDamp 0.02;     # damping ratio
set MpropSwitch 1.0;
set KcurrSwitch 0.0;
set KcommSwitch 1.0;
set KinitSwitch 0.0;
set nEigenI 1;  # mode 1
set nEigenJ 6;  # mode 6
set lambdaN [eigen -fullGenLapack 9];
set lambdaI [lindex $lambdaN [expr $nEigenI-1]];   # eigenvalue mode i
set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]];  # eigenvalue mode j
set omegaI [expr pow($lambdaI,0.5)];
set omegaJ [expr pow($lambdaJ,0.5)];
set alphaM [expr $MpropSwitch*$xDamp*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)]; # M-prop. damping; D = alphaM*M
set betaKcurr [expr $KcurrSwitch*2.*$xDamp/($omegaI+$omegaJ)];           # current-K;      +beatKcurr*KCurrent
set betaKcomm [expr $KcommSwitch*2.*$xDamp/($omegaI+$omegaJ)];     # last-committed K;   +betaKcomm*KlastCommitt
set betaKinit [expr $KinitSwitch*2.*$xDamp/($omegaI+$omegaJ)];            # initial-K;     +beatKinit*Kini
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm;     # RAYLEIGH damping