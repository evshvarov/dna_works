Class APOBECNonBDNA.Setup
{

Parameter NUC = "agct";

ClassMethod Setup() As %Status
{
    d ..Chromosomes()
    d ..Triplets()
    d ..NonTypes()
}

ClassMethod Chromosomes() As %Status
{
    k ^chr
    f i=1:1:22 s ^chr("chr"_i)=""
    f i="MT","X","Y" s ^chr("chr"_i)=""
}

ClassMethod NonTypes() As %Status
{
    k ^nontype
    s ^nontype("APR")="a-phased_repeats"
    s ^nontype("DR")="direct_repeats"
    s ^nontype("GQ")="g-quadruplex_forming_repeats"
    s ^nontype("IR")="inverted_repeats"
    s ^nontype("MR")="mirror_repeats"
    s ^nontype("STR")="short_tandem_repeats"
    s ^nontype("Z")="z-dna_motifs"
}

ClassMethod Triplets() As %Status
{
    k ^triplet
        f n1=1:1:4 {
           s $E(seq,1)=$E(..#NUC,n1)
            f n2=1:1:4 {
                s $E(seq,2)=$E(..#NUC,n2)
                f n3=1:1:4 {
                    s $E(seq,3)=$E(..#NUC,n3)
                    s ^triplet(seq)=""
                }

            }
        }
}

}
