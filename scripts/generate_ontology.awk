BEGIN {
    FS = "\t"
    print "@prefix tismedo: <http://med2rdf.org/ontology/med2rdf/tismed/> ."
    print "@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> ."
    print "@prefix skos: <http://www.w3.org/2004/02/skos/core#> ."
    print "@prefix owl: <http://www.w3.org/2002/07/owl#> ."
    print "@prefix obo: <http://purl.obolibrary.org/obo/> ."
    print ""
}

## ID, label, and xref
FNR==NR {
    label2id[$2] = $1
    print "tismedo:" $1 " a owl:Class ;"
    if ($3)
        print "    skos:closeMatch obo:" gensub(":", "_", "g", $3) " ;"
    print "    rdfs:label \"" $2 "\" ."
    print ""
    next
}

FNR>=2 {
    for (i=2; i<=3; i++) {
        if (!a[$i]++ && $i != "-") {
            uri = "tismedo:" label2id[$i]
            superclass_uri = "tismedo:" label2id[$(i-1)]
            print uri " rdfs:subClassOf " superclass_uri " ."
            #if(!label2id[$i])
            #    print i, $i
        }
    }
}