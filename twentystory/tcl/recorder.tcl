
set RecorderFolder "Result/$RecorderFolder"
file mkdir $RecorderFolder

set recorderDeltaT [expr 0.01]
recorder Node -file "$RecorderFolder/FloorDisp.txt" -time -dT $recorderDeltaT -node 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 -dof 1 disp 
recorder Node -file "$RecorderFolder/BaseShear.txt" -time -dT $recorderDeltaT -node 100 200 300 400 500 600 -dof 1 2 reaction
recorder Node -file "$RecorderFolder/LatRestraint.txt" -time -dT $recorderDeltaT -node 102 602 -dof 1 reaction 
recorder Node -file "$RecorderFolder/FloorAcceleration.txt" -time -dT $recorderDeltaT -node 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 -dof 1 accel 

set d [expr 1000*$ft]
set bf [expr 1000*$ft]

## Record all the Beam
for {set floor 2} {$floor < 23} {incr floor} {
    if {$floor < 10} {
        set floorCode "0$floor"
    } else {
        set floorCode $floor
    }

    recorder Element -file "$RecorderFolder/${floor}BeamStressStrainI.txt" -time -dT $recorderDeltaT -ele 1${floorCode}2$floorCode 2${floorCode}3$floorCode 3${floorCode}4$floorCode 4${floorCode}5$floorCode 5${floorCode}6$floorCode section 1 fiber [expr $d/2] [expr $bf/2] stressStrain;
    recorder Element -file "$RecorderFolder/${floor}BeamGlobalForce.txt" -time -dT $recorderDeltaT -ele 1${floorCode}2$floorCode 2${floorCode}3$floorCode 3${floorCode}4$floorCode 4${floorCode}5$floorCode 5${floorCode}6$floorCode  globalForce

}

## Record all the Columns
for {set colLine 1} {$colLine < 7} {incr colLine} {

    recorder Element -file "$RecorderFolder/${colLine}ColStressStrain.txt" -time -dT $recorderDeltaT -ele  ${colLine}00${colLine}01 ${colLine}01${colLine}02 ${colLine}02${colLine}03 ${colLine}03${colLine}04 ${colLine}04${colLine}05 ${colLine}05${colLine}06 ${colLine}06${colLine}07 ${colLine}07${colLine}08 ${colLine}08${colLine}09 ${colLine}09${colLine}10 ${colLine}10${colLine}11 ${colLine}11${colLine}12 ${colLine}12${colLine}13 ${colLine}13${colLine}14 ${colLine}14${colLine}15 ${colLine}15${colLine}16 ${colLine}16${colLine}17 ${colLine}17${colLine}18 ${colLine}18${colLine}19 ${colLine}19${colLine}20 ${colLine}20${colLine}21 ${colLine}21${colLine}22 section 1 fiber [expr $d/2] [expr $bf/2] stressStrain;

    recorder Element -file "$RecorderFolder/${colLine}ColGlobalForce.txt" -time -dT $recorderDeltaT -ele ${colLine}00${colLine}01 ${colLine}01${colLine}02 ${colLine}02${colLine}03 ${colLine}03${colLine}04 ${colLine}04${colLine}05 ${colLine}05${colLine}06 ${colLine}06${colLine}07 ${colLine}07${colLine}08 ${colLine}08${colLine}09 ${colLine}09${colLine}10 ${colLine}10${colLine}11 ${colLine}11${colLine}12 ${colLine}12${colLine}13 ${colLine}13${colLine}14 ${colLine}14${colLine}15 ${colLine}15${colLine}16 ${colLine}16${colLine}17 ${colLine}17${colLine}18 ${colLine}18${colLine}19 ${colLine}19${colLine}20 ${colLine}20${colLine}21 ${colLine}21${colLine}22 globalForce;
}

