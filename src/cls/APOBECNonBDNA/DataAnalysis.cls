Class APOBECNonBDNA.DataAnalysis
{

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

ClassMethod AnalyzeAll() As %Status
{
	do DISABLE^%SYS.NOJRN
	k ^seq
	s nontype=$O(^nontype(""))
	while nontype'="" {
		d ..Analyze(nontype)
		s nontype=$O(^nontype(nontype))
	}
	do ENABLE^%SYS.NOJRN
}

ClassMethod Analyze(nontype) As %Status
{
	m triplets=^triplet
	w nontype,"=",^NonBDNA(nontype),!
	s chr=$O(^NonBDNA(nontype,""))
	while chr'="" {
		write chr,!
		s noni=$O(^NonBDNA(nontype,chr,""))
		while noni'="" {
			s non=$g(^NonBDNA(nontype,chr,noni)) 
			s trip=$o(triplets(""))
			while trip'="" {
				s occ=$L(non,trip)-1
				if occ set ^seq(trip,nontype)=$g(^seq(trip,nontype))+occ
				s trip=$o(triplets(trip))
			}
			s noni=$O(^NonBDNA(nontype,chr,noni))
		}
	s chr=$O(^NonBDNA(nontype,chr))
	}
}

}
