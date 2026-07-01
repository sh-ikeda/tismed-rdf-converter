BEGIN {
    FS = "\t"
    OFS = "\t"
}

$2 ~ /^ENSG/ {
    buf = $2
    $2 = $8
    $8 = $6
    $6 = $4
    $4  = buf

    buf = $3
    $3 = $9
    $9 = $7
    $7 = $5
    $5 = buf
}
1