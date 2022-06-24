eigen 10

for {set mode 1} {$mode < 10} {incr mode} {
    set outfile [open "EigenVector$mode.txt" w+]
    foreach eleTags [getEleTags] {
        set nodeList [eleNodes $eleTags]
        set nodeI [lindex $nodeList 0]
        set nodeJ [lindex $nodeList 1]
    
        set nodeIx [nodeCoord $nodeI 1]
        set nodeIy [nodeCoord $nodeI 2]

        set nodeJx [nodeCoord $nodeJ 1]
        set nodeJy [nodeCoord $nodeJ 2]

        set IeigenVector1 [nodeEigenvector $nodeI $mode 1]
        set IeigenVector2 [nodeEigenvector $nodeI $mode 2]
        set IeigenVector3 [nodeEigenvector $nodeI $mode 3]

        set JeigenVector1 [nodeEigenvector $nodeJ $mode 1]
        set JeigenVector2 [nodeEigenvector $nodeJ $mode 2]
        set JeigenVector3 [nodeEigenvector $nodeJ $mode 3]

        puts $outfile "$eleTags, $nodeIx, $nodeIy, $nodeJx, $nodeJy, $IeigenVector1,$IeigenVector2,$IeigenVector3, $JeigenVector1, $JeigenVector2, $JeigenVector3"
    }
    close $outfile
}
