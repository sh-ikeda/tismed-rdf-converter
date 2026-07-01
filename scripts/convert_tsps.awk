BEGIN {
    FS = "\t"
    print "@prefix uniprot: <http://purl.uniprot.org/uniprot/> ."
    print "@prefix tismedo: <http://med2rdf.org/ontology/med2rdf/tismed/> ."
    print ""
}

## tissue ID
FNR==NR {
    tissue_id[$2] = $1
    next
}

## protein
FNR>=2 {
    print "uniprot:" $2 " a tismedo:ts_evaluated_protein ;"
    print "    tismedo:hasProteinExpressionSpecificity ["
    print "        a tismedo:ProteinExpressionSpecificity ;"
    print "        tismedo:isPositivelySpecificTo tismedo:" tissue_id[$1] " ;"
    print "        tismedo:meanSpmAdjustValue " $6 " ;"
    print "        tismedo:tScore " $7 " ;"
    print "        tismedo:supportDatasetCount " $8
    print "    ] ."
    print ""
}