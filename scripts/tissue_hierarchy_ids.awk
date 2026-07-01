BEGIN {
    FS = "\t"
}

FNR>=2 {
    for (i=1; i<=3; i++) {
        if ($i!="-" && !a[$i]++) {
            n+=1
            printf("TISMEDT_%06d\t%s\n",n,$i)
        }
    }
}