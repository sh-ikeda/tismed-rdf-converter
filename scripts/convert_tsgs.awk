BEGIN {
    FS = "\t"
    print "@prefix ensg: <http://rdf.ebi.ac.uk/resource/ensembl/> ."
    print "@prefix tismedo: <http://med2rdf.org/ontology/med2rdf/tismed/> ."
    print ""
}

## tissue ID
FNR==NR {
    tissue_id[$2] = $1
    next
}

## gene
FNR>=2 {
    if ($7 == "yes")
        protein = "true"
    else if ($7 == "no")
        protein = "false"
    else {
        print "Error: Unexpected Tissue-specific protein value: " $7 > "/dev/stderr"
        exit 1
    }
    genes_n = split($2, genes, "; ")
    for (i=1; i<=genes_n; i++) {
        print "ensg:" genes[i] " a tismedo:ts_evaluated_gene ;"
        print "    tismedo:hasGeneExpressionSpecificity ["
        print "        a tismedo:GeneExpressionSpecificity ;"
        print "        tismedo:isPositivelySpecificTo tismedo:" tissue_id[$1] " ;"
        print "        tismedo:meanSpmAdjustValue " $4 " ;"
        print "        tismedo:tScore " $5 " ;"
        print "        tismedo:supportDatasetCount " $6 " ;"
        print "        tismedo:hasTissueSpecificProtein " protein
        print "    ] ."
        print ""
    }
}