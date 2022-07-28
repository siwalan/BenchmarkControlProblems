wipe
model BasicBuilder -ndm 2 -ndf 3;
source [file join [file dirname [info script]] "LibUnits.tcl"]


set LColRaw     {0 12.0 12.0 18.0 6.0 7.0 13.0 13.0 6.0 7.0 13.0 13.0 6.0 7.0 13.0 13.0 6.0 7.0 13.0 13.0 6.0 7.0 13.0 13.0 6.0 7.0 13.0 6.0 7.0 13.0 }
set FloorArray  {0 1    2    3    3   4   5    6    6   7   8    9    9   10  11   12   12  13  14   15   15  16  17   18   18  19  20   20  21  22}
set FloorSplice {0 0    0    0    1   0   0    0    1   0   0    0    1   0   0    0    1   0   0    0    1   0   0    0    1   0   0    1   0   0}

set LCol []
foreach  item $LColRaw {
    lappend LCol [expr $item*$ft]
}
set LBeam [expr 20*$ft];

set NStory 21;
set NBay 5;
# Node Generation ------
set regularFloor 0

set currentHeight 0
set iterator 0
foreach floorHeight $LCol {
    set currentHeight [expr $currentHeight + $floorHeight]
    set floor [lindex $FloorArray $iterator]
    puts $floor
    if {$floor < 10} {
        set floorCode "0$floor"
    } else {
        set floorCode $floor
    }

    set floorSplice [lindex $FloorSplice $iterator]
    if {$floorSplice == 1} {
        set floorCode $floorCode$floorSplice
    } else {
        set floorCode $floorCode$regularFloor
    }

    for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
        node $Columns$floorCode [expr ($Columns-1)*$LBeam] [expr $currentHeight]
        puts stdout "Node $Columns$floorCode created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate  [expr ($currentHeight)]"
    }
    set iterator [expr $iterator + 1]
}

puts stdout "Creating a Pin Connection Node"
set currentHeight [expr 12.0]
set floor [expr 1]
set pinConnection 2

if {$floor < 10} {
    set floorCode "0$floor"
} else {
    set floorCode $floor
}

for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
    if {$Columns == 1} {
        set pinConnection 2
        node $Columns$floorCode$pinConnection [expr ($Columns-1)*$LBeam] [expr $currentHeight]
        puts stdout "Node $Columns$floorCode$pinConnection created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate [expr ($currentHeight)]"
    } elseif {$Columns == 6} {
        set pinConnection 3
        node $Columns$floorCode$pinConnection [expr ($Columns-1)*$LBeam] [expr $currentHeight]

        puts stdout "Node $Columns$floorCode$pinConnection created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate [expr ($currentHeight)]"
    } else {
        set pinConnection 2
        node $Columns$floorCode$pinConnection [expr ($Columns-1)*$LBeam] [expr $currentHeight]
        puts stdout "Node $Columns$floorCode$pinConnection created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate [expr ($currentHeight)]"

        set pinConnection 3
        node $Columns$floorCode$pinConnection [expr ($Columns-1)*$LBeam] [expr $currentHeight]
        puts stdout "Node $Columns$floorCode$pinConnection created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate [expr ($currentHeight)]"
    }
}


puts stdout "Constraint a Pinned DOF"
for {set Columns 1} {$Columns <= $NBay+1} {incr Columns} {
    if {$Columns == 1} {
        set pinConnection 2
        equalDOF $Columns$floorCode$regularFloor $Columns$floorCode$pinConnection 1 2
        puts stdout "Node $Columns$floorCode and $Columns$floorCode$pinConnection is pinned"
    } elseif {$Columns == 6} {
        set pinConnection 3
        equalDOF $Columns$floorCode$regularFloor $Columns$floorCode$pinConnection 1 2
        puts stdout "Node $Columns$floorCode and $Columns$floorCode$pinConnection is pinned"
    } else {
        set pinConnection 2
        equalDOF $Columns$floorCode$regularFloor $Columns$floorCode$pinConnection 1 2
        puts stdout "Node $Columns$floorCode and $Columns$floorCode$pinConnection is pinned"

        set pinConnection 3
        equalDOF $Columns$floorCode$regularFloor $Columns$floorCode$pinConnection 1 2
        puts stdout "Node $Columns$floorCode and $Columns$floorCode$pinConnection is pinned"
    }
}



puts stdout "Create a Rigid Diaphragm "
for {set floor 1} {$floor <= [expr $NStory+1]} {incr floor} {

    if {$floor == 2} {
        set floor [expr $floor + 1]
    }

    if {$floor < 10} {
        set floorCode "0$floor"
    } else {
        set floorCode $floor
    }
        set floorCodeJ $floorCode

    for {set Columns 2 } {$Columns <= $NBay+1} {incr Columns} {
        set nodeI 1
        set nodeJ [expr $Columns]

       if {$floorCode == 01} {
            set pinConnection 3
            set floorCodeJ $floorCode$pinConnection
        }  else {
            set floorCodeJ $floorCode$regularFloor
        }

        equalDOF $nodeI$floorCode$regularFloor $nodeJ$floorCodeJ 1; 

        puts "Rigid Diaphragm at node $nodeI$floorCode$regularFloor to $nodeJ$floorCodeJ"
    }
}


puts stdout "Fixing Columns"
for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
    set floor 00

    fix $Columns$floor$regularFloor 1 1 0
    puts stdout "Node $Columns$floor$regularFloor is fixed"
}

fix 1020 1 0 0
fix 6020 1 0 0

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

geomTransf Linear 1
geomTransf PDelta 2

set transformationKey 1
set intPoint 5


set colListExterior {7 7 7 7 8 8 8 8 9 9 9 9 9 9 9 9 9 9 9 9 10 10 10 10 10 10 10 11 11}
set ColumnExteriorLine {1 6}
foreach colLine $ColumnExteriorLine {
    for {set floorIterator 0} {$floorIterator < [expr [llength $LColRaw]-1]} {incr floorIterator} {

        set section [lindex $colListExterior $floorIterator]
        
        set nodeI [lindex $FloorArray $floorIterator]
        if {$nodeI < 10} {
            set nodeI "0$nodeI"
        } else {
            set nodeI $nodeI
        }

        set floorSplice [lindex $FloorSplice $floorIterator]
        if {$floorSplice == 1} {
            set nodeI $nodeI$floorSplice
        } else {
            set nodeI $nodeI$regularFloor
        }
    

        set upperFloor [expr $floorIterator + 1]

        set nodeJ [lindex $FloorArray $upperFloor]
        set floorSplice [lindex $FloorSplice $upperFloor]
        
        if {$nodeJ < 10} {
            set nodeJ "0$nodeJ"
        } else {
            set nodeJ $nodeJ
        }

        if {$floorSplice == 1} {
            set nodeJ $nodeJ$floorSplice
        } else {
            set nodeJ $nodeJ$regularFloor
        }

        element forceBeamColumn $colLine$nodeI$colLine$nodeJ $colLine$nodeI $colLine$nodeJ $transformationKey Lobatto $section $intPoint 

        puts "Creating Column $colLine$nodeI$colLine$nodeJ with Section $section at node $colLine$nodeI  to $colLine$nodeJ"
    }
}

set colListInterior {1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 6 6}
set ColumnInteriorLine {2 3 4 5}

foreach colLine $ColumnInteriorLine {
    for {set floorIterator 0} {$floorIterator < [expr [llength $LColRaw]-1]} {incr floorIterator} {

        set section [lindex $colListInterior $floorIterator]
        
        set nodeI [lindex $FloorArray $floorIterator]
        if {$nodeI < 10} {
            set nodeI "0$nodeI"
        } else {
            set nodeI $nodeI
        }

        set floorSplice [lindex $FloorSplice $floorIterator]
        if {$floorSplice == 1} {
            set nodeI $nodeI$floorSplice
        } else {
            set nodeI $nodeI$regularFloor
        }
    

        set upperFloor [expr $floorIterator + 1]

        set nodeJ [lindex $FloorArray $upperFloor]
        set floorSplice [lindex $FloorSplice $upperFloor]
        
        if {$nodeJ < 10} {
            set nodeJ "0$nodeJ"
        } else {
            set nodeJ $nodeJ
        }

        if {$floorSplice == 1} {
            set nodeJ $nodeJ$floorSplice
        } else {
            set nodeJ $nodeJ$regularFloor
        }

        element forceBeamColumn $colLine$nodeI$colLine$nodeJ $colLine$nodeI $colLine$nodeJ $transformationKey Lobatto $section $intPoint 

        puts "Creating Column $colLine$nodeI$colLine$nodeJ with Section $section at node $colLine$nodeI  to $colLine$nodeJ"
    }
}


set beamList {13 13 13 13 13 13 14 14 14 14 14 14 13 13 13 13 13 13 15 15 16 17}
set floor 1
foreach beamSection $beamList {

    if {$floor < 10} {
        set floorCode "0$floor"
    } else {
        set floorCode $floor
    }

    for {set Columns 1 } {$Columns <= $NBay} {incr Columns} {
        set section  $beamSection
        set nodeI $Columns
        set nodeJ [expr $nodeI + 1]
        
        if {$floor == 1} {
            if {$Columns == 1} {
                set pinConnection 3
                set floorCodeJ $floorCode$pinConnection

                set pinConnection 2
                set floorCodeI $floorCode$pinConnection

            } else {
                set pinConnection 3
                set floorCodeJ $floorCode$pinConnection
                set pinConnection 2
                set floorCodeI $floorCode$pinConnection
            } 
        }  else {
            set floorCodeJ $floorCode$regularFloor
            set floorCodeI $floorCode$regularFloor
        }



        element forceBeamColumn $nodeI$floorCodeI$nodeJ$floorCodeJ $nodeI$floorCodeI $nodeJ$floorCodeJ $transformationKey Lobatto $section $intPoint 

        puts "Creating Beam $nodeI$floorCodeI$nodeJ$floorCodeJ with Section $section at node $nodeI$floorCodeI to $nodeJ$floorCodeJ"
    }
    set floor [expr $floor + 1]
}

set massFloorRaw {5.31220 5.31220 5.63320 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.5164 5.83760}
set massFloor []
foreach  item $massFloorRaw {
    lappend massFloor [expr $item*$kg*pow(10,5)/(2*5)]
}

set floor 1
set totalBuildingMass 0
foreach massAssignment $massFloor {
        if {$floor < 10} {
            set floorCode "0$floor"
        } else {
            set floorCode $floor
        }

        set floorCode $floorCode$regularFloor
        
        for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
            if {$Columns == 1 || $Columns == 6} {
                set rotationalMass [expr pow($LBeam,2)*pow(10,-6)*$massAssignment/(2*210)]
                mass $Columns$floorCode [expr $massAssignment/2] [expr $massAssignment/2]  $rotationalMass
                puts stdout "Mass at $Columns$floorCode defined as $massAssignment with Rotational Mass of $rotationalMass"
                set totalBuildingMass [expr $totalBuildingMass+$massAssignment]
            } else {
                set rotationalMass [expr pow($LBeam,2)*pow(10,-6)*$massAssignment/(210)]
                mass $Columns$floorCode [expr $massAssignment]  $massAssignment  $rotationalMass
                puts stdout "Mass at $Columns$floorCode defined as $massAssignment with Rotational Mass of $rotationalMass"
                set totalBuildingMass [expr $totalBuildingMass+$massAssignment*2]
            }

        }
        set floor [expr $floor + 1]
}

puts "Total building mass is $totalBuildingMass"

set massAssignment [lindex $massFloor 1]
set rotationalMass [expr pow($LBeam,2)*pow(10,-6)*$massAssignment/(210)]
mass 2000 0 0  $rotationalMass
mass 3000 0 0  $rotationalMass
mass 4000 0 0  $rotationalMass
mass 5000 0 0  $rotationalMass
set rotationalMass [expr pow($LBeam,2)*pow(10,-6)*$massAssignment/(2*210)]
mass 1000 0 0  $rotationalMass
mass 6000 0 0  $rotationalMass

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
