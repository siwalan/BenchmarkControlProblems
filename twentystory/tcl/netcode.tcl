 

if {$argc != 1} {
    puts stdout "No Input is received, setting dt to 0.0005 second and simulation end time to 30 second. Sending Nodal Acceleration and Predefined Output Folder.";
    set dt 0.0005;
    set end_time 30;
    set RecorderFolder "Ohtori20Story"
    set SendDataType 0
    set SimulinkPort 10000
    } else {
        set argv [string map {\{ "" \} ""} $argv]
        set argv [split $argv " "]
        lassign $argv end_time dt RecorderFolder SendDataType SimulinkPort full_states
        set SendDataType 0
        puts stdout "Setting dt and end time according to input. dt $dt endtime $end_time"
        puts stdout "Output Folder is $RecorderFolder. Using Port $SimulinkPort"
        puts stdout "Full state is $full_states"
    }

###############################
source [file join [file dirname [info script]] "model.tcl"]
source [file join [file dirname [info script]] "recorder.tcl"]
source [file join [file dirname [info script]] "DOFs_data.tcl"]
###############################
set groundOut [open "$RecorderFolder/GroundAcceleration.txt" w+]

timeSeries Constant 1 -factor 0;
pattern UniformExcitation 1 1 -accel 1 -fact 1;
parameter 1 loadPattern 1 factor

proc ReadSocket {sock bytes_read} {
    return [chan read $sock $bytes_read]
}

proc WriteSocket {sock bytes_write} {
    puts -nonewline $sock $bytes_write
}

proc OpenSeesServer {sock addr port} {
    upvar 1 dt dt_Server;
    upvar 1 end_time endtime_Server;
    upvar 1 SendDataType SendDataType_Server;
    upvar 1 full_states full_states
    upvar 1 DOF_MCK DOF_MCK
    upvar 1 groundOut groundOut
    upvar 1 StateNodes StateNodes
    upvar 1 StateSize StateSize 

    puts $endtime_Server
    puts stdout "Starting OpenSeeS TCP Server";
    puts stdout "Connection accepted from $addr:$port"
    puts stdout "Server socket details: [fconfigure $sock -sockname]"
    puts stdout "Peer socket details: [fconfigure $sock -peername]"
    puts stdout "$dt_Server"

    set OpenSeeSTCPCon(addr,$sock) [list $addr $port]
    fconfigure $sock -translation binary;
    fconfigure $sock  -buffering none;
    puts stdout "[fconfigure $sock]"
    set controlNode 122;
    set controlDOF 1;
    
    set t -1
    set ok 0
    set RunAnalysisLock 1

    constraints Transformation
    numberer    Plain
    test        NormDispIncr 1.0e-6 100 2
    algorithm   Newton
    system      ProfileSPD
    integrator Newmark 0.5 0.25
    analysis Transient
    
    while {$ok == 0 && $t < $endtime_Server} {

            set RunAnalysisLock 1
            set t [getTime]
            #puts stdout "\n####### Starting New Iteration ######";
            if {$full_states == 0} {
                puts stdout "\nSending Data - Node Acceleration "
                set controlNodeAcc [nodeAccel $controlNode $controlDOF]
                set sendData [binary format QQ $t $controlNodeAcc ]
                WriteSocket $sock $sendData 
            } else {
                for {set nodeIterator 0} {$nodeIterator < $StateNodes} {incr nodeIterator} {
                    set DOF_Check1 [lindex $DOF_MCK $nodeIterator 1]
                    set DOF_Check2 [lindex $DOF_MCK $nodeIterator 2]
                    set DOF_Check3 [lindex $DOF_MCK $nodeIterator 3]

                    if {$DOF_Check1 >= 0} {
                        set node_dof1 [nodeDisp [lindex $DOF_MCK $nodeIterator 0] 1] 
                        set state_space([lindex $DOF_MCK $nodeIterator 1]) $node_dof1

                        set node_dof1 [nodeVel [lindex $DOF_MCK $nodeIterator 0] 1] 
                        set state_space([expr [lindex $DOF_MCK $nodeIterator 1]+$StateSize]) $node_dof1
                    }

                    if {$DOF_Check2 >= 0} {
                        set node_dof2 [nodeDisp [lindex $DOF_MCK $nodeIterator 0] 2] 
                        set state_space([lindex $DOF_MCK $nodeIterator 2]) $node_dof2

                        set node_dof2 [nodeVel [lindex $DOF_MCK $nodeIterator 0] 2] 
                        set state_space([expr [lindex $DOF_MCK $nodeIterator 2]+$StateSize]) $node_dof2
                    }

                    if {$DOF_Check3 >= 0} {
                        set node_dof3 [nodeDisp [lindex $DOF_MCK $nodeIterator 0] 3] 
                        set state_space([lindex $DOF_MCK $nodeIterator 3]) $node_dof3

                        set node_dof3 [nodeVel [lindex $DOF_MCK $nodeIterator 0] 3] 

                        set state_space([expr [lindex $DOF_MCK $nodeIterator 3]+$StateSize]) $node_dof3
                    }
                }
                set state_space_data [expr 1.*$state_space(0)]
                for {set iterator 1} {$iterator < [expr 2*$StateSize]} {incr iterator} {
                    lappend state_space_data [expr 1.*$state_space($iterator)]
                }
                set controlNodeAcc [nodeAccel $controlNode $controlDOF]
                set sendData [binary format Q[expr 2+2*$StateSize] [concat $t $controlNodeAcc $state_space_data]]
                WriteSocket $sock $sendData 
            }

            #binary scan $sendData QQ sendDataTime sendData
            #puts stdout "Sent Data:  $sendData;"
            #puts stdout "Current Control Node Acc:  [ nodeAccel $controlNode $controlDOF];;"
            #puts stdout "Current Control Node Disp:  [nodeDisp $controlNode $controlDOF];"

            #puts stdout "\nReceiving Data - Time and Control Force"
            
            set dataInput [ReadSocket $sock 16];
            binary scan $dataInput QQ timeVar accelerationInputTCP   
            #puts stdout "Current Simulink time is $timeVar; Current OpenSees time is $t; Acceleration command is $accelerationInputTCP"
            updateParameter 1 [expr $accelerationInputTCP]

            if {[expr abs($timeVar-$t)] > $dt_Server} {
                puts stdout "Time Mismatch!"
                break
            } else {
                puts stdout "Time is OK"
            }

            if {0} \
            {
                close $sock
                puts  stdout "Close TCPCon(addr,$sock)"
                unset OpenSeeSTCPCon(addr,$sock)
            } \
            else \
            {
                set gmGLF [getLoadFactor 1]
                puts $groundOut "$t	$gmGLF"
                set ok [analyze 1 $dt_Server]
                #puts stdout "Analysis Completed - OpenSees time advanced to $t";
            }
    }
    close $groundOut
    wipe
    puts stdout "End Server"
    close $sock
    exit
}

puts stdout "Model Preparation Complete"
global OpenSeeSTCPCon
set OpenSeeSTCPCon(main) [socket -server OpenSeesServer $SimulinkPort]
vwait forever
