wipe
model BasicBuilder -ndm 2 -ndf 3;
source [file join [file dirname [info script]] "LibUnits.tcl"]


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
            puts stdout "Node $Columns$floorCode created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate  [expr ($currentHeight)]"
        }
    }

puts stdout "Creating a Pin Connection Node"
set currentHeight 0
for {set floor 1} {$floor <= [expr $NStory+1]} {incr floor} {
    set currentHeight [expr $currentHeight + [lindex $LCol $floor]]
        for {set Columns 6 } {$Columns <= $NBay+1} {incr Columns} {
            if {$floor < 10} {
                set floorCode "0$floor"
            } else {
                set floorCode $floor
            }
            set pinConnection 0
            node $Columns$floorCode$pinConnection [expr ($Columns-1)*$LBeam] [expr $currentHeight]
            puts stdout "Node $Columns$floorCode$pinConnection created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate [expr ($currentHeight)]"
        }
    }

puts stdout "Constraint a Pinned DOF"
set currentHeight 0
for {set floor 1} {$floor <= [expr $NStory+1]} {incr floor} {
    set currentHeight [expr $currentHeight + [lindex $LCol $floor]]
        for {set Columns 6 } {$Columns <= $NBay+1} {incr Columns} {
            set pinConnection 0
            if {$floor < 10} {
                set floorCode "0$floor"
            } else {
                set floorCode $floor
            }
            equalDOF $Columns$floorCode $Columns$floorCode$pinConnection 1 2
            puts stdout "Node $Columns$floorCode and $Columns$floorCode$pinConnection is pinned"
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
    puts stdout "Node $Columns$floor is fixed"
}

fix 101 1 0 0
fix 601 1 0 0

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

        puts "Creating Column with Section $section at node $colLine$nodeI  to $colLine$nodeJ"
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

        puts "Creating Column with Section $section at node $colLine$nodeI  to $colLine$nodeJ"
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
            set floorCodeJ $floorCode$pinConnection
        }
        element forceBeamColumn $nodeI$floorCode$nodeJ$floorCodeJ $nodeI$floorCode $nodeJ$floorCodeJ $transformationKey Lobatto $section $intPoint 

        puts "Creating Beam with Section $section at node $nodeI$floorCode to $nodeJ$floorCodeJ"
    }
    set floor [expr $floor + 1]
}

set massFloorRaw {9.65 10.1 9.89 9.89 9.89 9.89 9.89 9.89 9.89 10.7}
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
