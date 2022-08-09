wipe
model BasicBuilder -ndm 2 -ndf 3;
source [file join [file dirname [info script]] "LibUnits.tcl"]

set elasticBeamColumn 1

set LColRaw {0 12.0 18.0 13.0 13.0 13.0 13.0 13.0 13.0 13.0 13.0}
set LCol []
foreach  item $LColRaw {
    lappend LCol [expr $item*$ft]
}
set LBeam [expr 30*$ft];

set NStory 9;
set NBay 5;
# Node Generation ------
set currentHeight 0
for {set floor 0} {$floor <= [expr $NStory+1]} {incr floor} {
        set currentHeight [expr $currentHeight + [lindex $LCol $floor]]
        for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
            if {$floor < 10} {
                set floorCode "0$floor"
            } else {
                set floorCode $floor
            }
            node $Columns$floorCode [expr ($Columns-1)*$LBeam] [expr $currentHeight]
            #puts stdout "Node $Columns$floorCode created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate  [expr ($currentHeight)]"
        }
    }

puts stdout "Create a Rigid Diaphragm "
for {set floor 2} {$floor <= [expr $NStory+1]} {incr floor} {

    if {$floor < 10} {
        set floorCode "0$floor"
    } else {
        set floorCode $floor
    }
    set floorCodeJ $floorCode

    for {set Columns 2 } {$Columns <= $NBay+1} {incr Columns} {
        set nodeI 1
        set nodeJ [expr $Columns]

        equalDOF $nodeI$floorCode $nodeJ$floorCodeJ 1; 

        puts "Rigid Diaphragm at node $nodeI$floorCode to $nodeJ$floorCodeJ"
    }
}


puts stdout "Fixing Columns"
for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
    set floor 0
            if {$floor < 10} {
                set floorCode "0$floor"
            } else {
                set floorCode $floor
            }
    fix $Columns$floorCode 1 1 0
    #puts stdout "Node $Columns$floor is fixed"
}

fix 101 1 0 0
fix 601 1 0 0

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

source [file join [file dirname [info script]] "sectionData.tcl"]

geomTransf Linear 1
geomTransf PDelta 2

set transformationKey 1
set intPoint 5


set colListExterior {1 1 1 1 4 4 5 5 6 6}
set ColumnExteriorLine {1 6}
foreach colLine $ColumnExteriorLine {
    for {set floor 0} {$floor <= [expr $NStory]} {incr floor} {
        set section [lindex $colListExterior $floor]
        set upperFloor [expr $floor + 1]

        if {$floor < 10} {
            set nodeI "0$floor"
        } else {
            set nodeI $floor
        }

        if {$upperFloor < 10} {
            set nodeJ "0$upperFloor"
        } else {
            set nodeJ $upperFloor
        }

        element forceBeamColumn $colLine$nodeI$colLine$nodeJ $colLine$nodeI $colLine$nodeJ $transformationKey Lobatto $section $intPoint 

        #puts "Creating Column $colLine$nodeI$colLine$nodeJ with Section $section at node $colLine$nodeI  to $colLine$nodeJ"
        }
}

set colListInterior {2 2 3 3 1 1 4 4 5 5}

set ColumnInteriorLine {2 3 4 5}
foreach colLine $ColumnInteriorLine {
    for {set floor 0} {$floor <= [expr $NStory]} {incr floor} {
        set section [lindex $colListInterior $floor]
        set upperFloor [expr $floor + 1]

        if {$floor < 10} {
            set nodeI "0$floor"
        } else {
            set nodeI $floor
        }

        if {$upperFloor < 10} {
            set nodeJ "0$upperFloor"
        } else {
            set nodeJ $upperFloor
        }

        element forceBeamColumn $colLine$nodeI$colLine$nodeJ $colLine$nodeI $colLine$nodeJ $transformationKey Lobatto $section $intPoint 

        #puts "Creating Column $colLine$nodeI$colLine$nodeJ with Section $section at node $colLine$nodeI  to $colLine$nodeJ"
        }
}


set beamList {7 7 7 8 8 8 8 9 10 11}
set floor 1
foreach beamSection $beamList {

    if {$floor < 10} {
        set floorCode "0$floor"
    } else {
        set floorCode $floor
    }
        set floorCodeJ $floorCode

    for {set Columns 1 } {$Columns <= $NBay} {incr Columns} {
        set section  $beamSection
        set nodeI $Columns
        set nodeJ [expr $nodeI + 1]
        if {$nodeJ == 6} {
           element elasticBeamColumn $nodeI$floorCode$nodeJ$floorCodeJ  $nodeI$floorCode $nodeJ$floorCodeJ $section $transformationKey -release 2;
                puts "Creating Elastic Beam with Section $section at node $nodeI$floorCode to $nodeJ$floorCodeJ"

        } else {
            element forceBeamColumn $nodeI$floorCode$nodeJ$floorCodeJ $nodeI$floorCode $nodeJ$floorCodeJ $transformationKey Lobatto $section $intPoint 
            puts "Creating Beam with Section $section at node $nodeI$floorCode to $nodeJ$floorCodeJ"

        }
    }
    set floor [expr $floor + 1]
}

set massFloorRaw {9.65 10.1 9.89 9.89 9.89 9.89 9.89 9.89 9.89 10.7}
set massFloor []
foreach  item $massFloorRaw {
    lappend massFloor [expr $item*$kg*pow(10,5)/(2*5)]
}


if {[string equal $LunitTXT "mm"]} {
    set alpha [expr pow(10,-12)]
} elseif {[string equal $LunitTXT "meter"]} {
    set alpha [expr pow(10,-6)]
}

set floor 1
set totalBuildingMass 0
foreach massAssignment $massFloor {
        if {$floor < 10} {
            set floorCode "0$floor"
        } else {
            set floorCode $floor
        }
        for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
            if {$Columns == 1 || $Columns == 6} {
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
#puts "Total building mass is $totalBuildingMass"

set massAssignment [lindex $massFloor 0]
set rotationalMass [expr pow($LBeam,2)*$alpha*$massAssignment/(210)]
mass 200 0 0  $rotationalMass
mass 300 0 0  $rotationalMass
mass 400 0 0  $rotationalMass
mass 500 0 0  $rotationalMass
set rotationalMass [expr pow($LBeam,2)*$alpha*$massAssignment/(2*210)]
mass 100 0 0  $rotationalMass
mass 600 0 0  $rotationalMass

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