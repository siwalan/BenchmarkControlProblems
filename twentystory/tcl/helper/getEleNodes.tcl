for {set mode 1} {$mode < 10} {incr mode} {
    set outfile [open "20storyPlot.txt" w+]
    foreach eleTags [getEleTags] {
        set nodeList [eleNodes $eleTags]
        set nodeI [lindex $nodeList 0]
        set nodeJ [lindex $nodeList 1]
    
        set nodeIx [nodeCoord $nodeI 1]
        set nodeIy [nodeCoord $nodeI 2]

        set nodeJx [nodeCoord $nodeJ 1]
        set nodeJy [nodeCoord $nodeJ 2]

        set IeigenVector1 nodeIx
        set IeigenVector2 nodeIy
        set IeigenVector3 0

        set JeigenVector1 nodeJx
        set JeigenVector2 nodeJy
        set JeigenVector3 0

        puts $outfile "$eleTags, $nodeIx, $nodeIy, $nodeJx, $nodeJy, $IeigenVector1,$IeigenVector2,$IeigenVector3, $JeigenVector1, $JeigenVector2, $JeigenVector3"
    }
    close $outfile
}