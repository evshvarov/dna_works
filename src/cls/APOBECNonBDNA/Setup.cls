Class APOBECNonBDNA.Setup
{

/// Globals involved
/// ^chr - the list of chromosomes
/// ^nontype - the list of different types
/// ^triplet - the list of triplet compbinations
/// ^NonBDNA(nontype,chr,num)=nucleotids - the list of nucleotid parts of DNA
/// ^seq(triplet,nontype) - the result with triplets and its frequency in nontypes
Parameter NUC = "agct";

ClassMethod Setup() As %Status
{
    d ..Chromosomes()
    d ..Triplets()
    d ..NonTypes()
    d ..LoadNonBDNA()
}

Parameter Folder = "/iris/app/nonBDNA_parts/";

ClassMethod LoadNonBDNA() As %Status
{

	do DISABLE^%SYS.NOJRN
	k ^NonBDNA
	s nontype=$O(^nontype(""))
	while nontype'="" {
		set chr=$O(^chr(""))
		while chr'="" {
			Set stream=##class(%Stream.FileCharacter).%New()
			set filename = ..#Folder_^nontype(nontype)_"/gff/"_chr_"_"_nontype_".gff"
			Set sc=stream.LinkToFile(filename)	
			
			write filename, !
			
			Set rec=stream.ReadLine()
		
			While 'stream.AtEnd 
			{
				s seq=$p(rec,"sequence=",2)	
				if seq'="" set seq=$p(seq,";")
				set ^NonBDNA(nontype,chr,$seq(^NonBDNA(nontype)))=seq
				Set rec=stream.ReadLine()
					
			}
		set chr=$O(^chr(chr))
		}
	s nontype=$O(^nontype(nontype))
	}
	do ENABLE^%SYS.NOJRN
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
