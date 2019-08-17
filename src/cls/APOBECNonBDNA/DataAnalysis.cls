Class APOBECNonBDNA.DataAnalysis
{

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
				if occ {
					set ^seq(trip,nontype)=$g(^seq(trip,nontype))+occ
					set ^seq(trip,nontype,chr)=$g(^seq(trip,nontype,chr))+occ
				}			
				s trip=$o(triplets(trip))
			}
			s noni=$O(^NonBDNA(nontype,chr,noni))
		}
	s chr=$O(^NonBDNA(nontype,chr))
	}
}

}
