wipe
model BasicBuilder -ndm 2 -ndf 3;
source [file join [file dirname [info script]] "LibUnits.tcl"]


set LColRaw    {0 12.0 18.0 6.0 7.0 13.0 6.0 7.0 13.0 6.0 7.0 13.0 6.0 7.0 13.0}
set FloorArray {0 1    2    2   3   4    4   5   6    6   7   8     8  9   10}
set FloorSplice {0 0    0    1   0   0    1   0   0    1   0   0     1  0   0}

set LCol []
foreach  item $LColRaw {
    lappend LCol [expr $item*$ft]
}
set LBeam [expr 30*$ft];

set NStory 9;
set NBay 5;
# Node Generation ------
set regularFloor 0

set currentHeight 0
set iterator 0
foreach floorHeight $LCol {
    set currentHeight [expr $currentHeight + $floorHeight]
    set floor [lindex $FloorArray $iterator]

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
set currentHeight 0
set iterator 0
foreach floorHeight $LCol {
    if {$iterator == 0} {
        set iterator [expr $iterator + 1]
        continue
    }

    set currentHeight [expr $currentHeight + $floorHeight]
    set floor [lindex $FloorArray $iterator]

    if {$floor < 10} {
        set floorCode "0$floor"
    } else {
        set floorCode $floor
    }

    set floorSplice [lindex $FloorSplice $iterator]
    
    if {$floorSplice == 1} {
        set iterator [expr $iterator + 1]
        continue
    } else {
        set floorCode $floorCode
    }
    
    set pinConnection 2

    for {set Columns 6 } {$Columns <= $NBay+1} {incr Columns} {
        node $Columns$floorCode$pinConnection [expr ($Columns-1)*$LBeam] [expr $currentHeight]
        puts stdout "Node $Columns$floorCode$pinConnection created. X Coordinate [expr ($Columns-1)*$LBeam] Y Coordinate [expr ($currentHeight)]"
    }

    set iterator [expr $iterator + 1]
}

puts stdout "Constraint a Pinned DOF"
set iterator 0
foreach floorHeight $LCol {
    if {$iterator == 0} {
        set iterator [expr $iterator + 1]
        continue
    }

    set floor [lindex $FloorArray $iterator]

    if {$floor < 10} {
        set floorCode "0$floor"
    } else {
        set floorCode $floor
    }

    set floorSplice [lindex $FloorSplice $iterator]
    
    if {$floorSplice == 1} {
        set iterator [expr $iterator + 1]
        continue
    } 
    
    for {set Columns 6 } {$Columns <= $NBay+1} {incr Columns} {
        equalDOF $Columns$floorCode$regularFloor $Columns$floorCode$pinConnection 1 2
        puts stdout "Node $Columns$floorCode and $Columns$floorCode$pinConnection is pinned"
    }

    set iterator [expr $iterator + 1]
}

puts stdout "Fixing Columns"
for {set Columns 1 } {$Columns <= $NBay+1} {incr Columns} {
    set floor 00

    fix $Columns$floor$regularFloor 1 1 0
    puts stdout "Node $Columns$floor$regularFloor is fixed"
}

fix 1010 1 0 0
fix 6010 1 0 0

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


set colListExterior {1 1 1 1 1 1 4 4 4 5 5 5 5 6 6}
set ColumnExteriorLine {1 6}
foreach colLine $ColumnExteriorLine {
    for {set floorIterator 0} {$floorIterator < 14} {incr floorIterator} {

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
set colListInterior {2 2 2 3 3 3 1 1 1 4 4 4 5 5}
set ColumnInteriorLine {2 3 4 5}

foreach colLine $ColumnInteriorLine {
    for {set floorIterator 0} {$floorIterator < 14} {incr floorIterator} {

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

set beamList {7 7 7 8 8 8 8 9 10 11}
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
        if {$nodeJ == 6} {
            set floorCodeJ $floorCode$pinConnection
        }  else {
            set floorCodeJ $floorCode$regularFloor
        }


        element forceBeamColumn $nodeI$floorCode$regularFloor$nodeJ$floorCodeJ $nodeI$floorCode$regularFloor $nodeJ$floorCodeJ $transformationKey Lobatto $section $intPoint 

        puts "Creating Beam $nodeI$floorCode$regularFloor$nodeJ$floorCodeJ with Section $section at node $nodeI$floorCode$regularFloor to $nodeJ$floorCodeJ"
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
