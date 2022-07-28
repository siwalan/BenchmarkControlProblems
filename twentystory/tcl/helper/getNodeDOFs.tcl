wipeAnalysis
system FullGeneral
numberer Plain
analysis Transient
integrator GimmeMCK 1. 0. 0.
analyze 1 1

foreach node [getNodeTags] {
    set nodeDOFs [nodeDOFs $node]
    puts "{$node $nodeDOFs}"
}

wipeAnalysis
