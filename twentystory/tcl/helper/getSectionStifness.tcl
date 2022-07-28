wipeAnalysis
system FullGeneral
numberer Plain
analysis Transient
integrator GimmeMCK 1. 0. 0.
analyze 1 1

foreach ele [getEleTags] {
    set eleStiff [sectionStiffness $ele 1]
    puts "{$ele $eleStiff}"
}

wipeAnalysis
