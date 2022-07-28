wipeAnalysis
system FullGeneral
numberer Plain
analysis Transient

integrator GimmeMCK 1. 0. 0.
analyze 1 1
printA -file "M.txt"

wipeAnalysis

system FullGeneral
numberer Plain
analysis Transient


integrator GimmeMCK 0. 1. 0.

analyze 1 1
printA -file "C.txt"

wipeAnalysis

system FullGeneral
numberer    Plain
analysis Transient

integrator GimmeMCK 0. 0. 1.

analyze 1 1
printA -file "K.txt"
