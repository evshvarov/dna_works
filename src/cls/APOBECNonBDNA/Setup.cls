Class APOBECNonBDNA.Setup
{

/// Globals involved
/// ^chr - the list of chromosomes
/// ^nontype - the list of different types
/// ^triplet - the list of triplet compbinations
/// ^NonBDNA(nontype,chr,num)=nucleotids - the list of nucleotid parts of DNA
/// ^seq(triplet,nontype) - the result with triplets and its frequency in nontypes
Parameter NUC = "agct";

Parameter SIDData = "^NonBDNA";

Parameter SIDIndex = "^NonBDNAI";

Parameter NontypesList = {$lb("APR","DR","GQ","IR","MR","STR","Z")};

Parameter ChromosomeList = {$lb("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","MT","X","Y")};

ClassMethod NontypeList() As %List
{
    Return $Listfromstring("APR,DR,GQ,IR,MR,STR,Z",",")
}

ClassMethod GetChromeList() As %List
{
    f i=1:1:22 s $p(chr,",",i)="chr"_i
    s chr=chr_",MT,X,Y"
    return $Listfromstring(chr,",")
}

ClassMethod TestData(ad, adx) As %Status
{
    s @ad@("DR","chr1","chr1_1_4_DR")="aaaa"
    s @adx@("DR","chr1",1)="chr1_1_4_DR"
    s @ad@("DR","chr1","chr1_3_6_DR")="aagg"
    s @adx@("DR","chr1",3)="chr1_3_6_DR"
    s @ad@("DR","chr1","chr1_6_8_DR")="gtt"
    s @adx@("DR","chr1",6)="chr1_6_8_DR"
    s @ad@("DR","chr1","chr1_9_10_DR")="cc"
    s @adx@("DR","chr1",9)="chr1_9_10_DR"
}

ClassMethod Setup() As %Status
{
    d ..Chromosomes()
    d ..Triplets()
    d ..NonTypes()
    d ..LoadNonBDNA()
}

Parameter Folder = "/iris/app/nonBDNA_parts/";

///  ID=chr1_19494_19518_APR;tracts=3;composition=9A/7C/4G/4T;sequence=aatggcctagaatccgacccaataa
/// ID=chr1_19494_19518_APR;
ClassMethod LoadNonBDNA() As %Status
{

	do DISABLE^%SYS.NOJRN
    k @..#SIDData
	k @..#SIDIndex
    //s chrlist=..ChromeList()
    s iter=0
	while $ListNext(..#NontypesList,iter,nontype) {
        set iter1=0
        while $ListNext(..#ChromosomeList,iter1,chr) {
			Set stream=##class(%Stream.FileCharacter).%New()
			set filename = ..#Folder_^nontype(nontype)_"/gff/"_chr_"_"_nontype_".gff"
			Set sc=stream.LinkToFile(filename)			
			write filename, !
			Set rec=stream.ReadLine()
			While 'stream.AtEnd 
			{
                s seq=$p(rec,"sequence=",2)
                if seq'="" {
                    set seq=$p(seq,";")
                    set SID=$p($p(rec,"ID=",2),";")
                    set p1=$p(SID,"_",2)
                    //set ^NonBDNA(nontype,chr,ID)=seq
                    set @..#SIDData@(nontype,chr,SID)=seq
                  set @..#SIDIndex@(nontype,chr,p1)=SID
                    }
				Set rec=stream.ReadLine()				
			}
		}
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
