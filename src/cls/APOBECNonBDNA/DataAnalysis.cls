Class APOBECNonBDNA.DataAnalysis
{

ClassMethod run1() As %Status
{
	k ^seq
	s ad=##class(APOBECNonBDNA.Setup).#SIDData
	s adx=##class(APOBECNonBDNA.Setup).#SIDIndex
	w "Setup data...",!
	d ##class(APOBECNonBDNA.Setup).Setup()
	d ##class(APOBECNonBDNA.Setup).LoadNonBDNA()
	
	s adcross="^cross" k @adcross
	w "Checking united diapazones...",!
	d ..CheckAllBoundaries1(adcross,ad,adx)
	s adex="^Run" k @adex
	m @adex=@ad
	w "Uniting diapazones ...",!
	d ..UniteDiapasons3(adcross,adex,ad)
	w "Analizing diapazones on triplets...",!
	d ..AnalyzeAll(adex)
	d ##class(APOBECNonBDNA.DataFacts).LoadData()
	d $System.DeepSee.BuildCube("Triplets")
}

ClassMethod run() As %Status
{
	k ^seq
	s ad=##class(APOBECNonBDNA.Setup).#SIDData
	s adx=##class(APOBECNonBDNA.Setup).#SIDIndex
	s adex=$Na(^Run)
	k @adex
	w "Setup data...",!
	d ##class(APOBECNonBDNA.Setup).Setup()
	d ##class(APOBECNonBDNA.Setup).LoadNonBDNA()
	w "Checking united diapazones...",!
	d ..CheckAllBoundaries(adex,ad,adx)
	w "Analizing diapazones on triplets...",!
	d ..AnalyzeAll(adex)
	d ##class(APOBECNonBDNA.DataFacts).LoadData()
	w "Building visualisation cubes...",!
	d $System.DeepSee.BuildCube("Triplets")
}

ClassMethod testrun1() As %Status
{
	k ^seq
	d ##class(APOBECNonBDNA.Setup).TestData("^TestData","^TestIndex")
	d ..CheckAllBoundaries(,"^TestData","^TestIndex")
}

ClassMethod testrun2() As %Status
{
	d ##class(APOBECNonBDNA.Setup).TestData("^TestData","^TestIndex")
	s ad="^TestData"
	s adx="^TestIndex"
	d ..CheckAllBoundaries("^Test",ad,adx)
	//m ^Test2=@ad
	d ..UniteDiapasons3("^Test2","^Test",ad)
}

/// go through cross to change united
ClassMethod UniteDiapasons3(cross, united, ad) As %Status
{
	do DISABLE^%SYS.NOJRN
	s nontypelist=##class(APOBECNonBDNA.Setup).NontypeList()
	s iter=0
	while $Listnext(nontypelist,iter,nontype) {
		set c=$O(@cross@(nontype,""),-1)
		while c'="" {
			set sid=@cross@(nontype,c,"SID")
			set sid2=@cross@(nontype,c,"Link")
			do ..Swaplink1($na(@cross@(nontype)),united,sid,sid2,ad)
			set c=$O(@cross@(nontype,c),-1)
		}	
	}
	do ENABLE^%SYS.NOJRN
}

ClassMethod Swaplink1(cross, united, c, c2, ad) As %Status
{
		//write "c=",c,", c2=",c2,!
		if $d(@cross@(c2)) {
		//		w "dig into ",c2,!
				do ..Swaplink1(cross,united,c2,@cross@(c2),ad)
		}
		//B "L"		
		set chr=$P(c2,"_")
		set nontype=$p(c2,"_",4)
		set c("start")=$P(c,"_",2)
		set c2("start")=$P(c2,"_",2)
		set c("seq")=@united@(nontype,chr,c)
		set c2("seq")=@united@(nontype,chr,c2)
		set newseq=$E(c("seq"),1,c2("start")-c("start"))_c2("seq")
		s @united@(nontype,chr,c)=newseq
		k @united@(nontype,chr,c2)
}

/// set ^NonBDNA(nontype,chr,seqid,"p2")=p2
/// set ^NonBDNAPos(nontype,chr,"s",p1)=seqid
ClassMethod CheckAllBoundaries1(cross = "^Test2", ad, adx) As %Status
{
	k @cross
	s nontypelist=##class(APOBECNonBDNA.Setup).NontypeList()
	s iter=0
	while $Listnext(nontypelist,iter,nontype) {
		d ..CheckBoundaries1(nontype,$na(@cross@(nontype)),ad,adx)
	}
}

/// this method goes through all sequences and stores the sequences with intersected diapasons into
/// @cross@(SID)=CrossedSID
ClassMethod CheckBoundaries1(nontype, cross, ad, adx) As %Status
{
		//w nontype,"=",^NonBDNA(nontype),!
		w nontype,!
		s chrlist=##class(APOBECNonBDNA.Setup).#ChromosomeList
		s iter=0
		while $Listnext(chrlist,iter,chr) {
			write chr,!
			s sid="" for { 
				s sid=$O(@ad@(nontype,chr,sid)) q:sid=""
				s p1=$p(sid,"_",2)
				s p2=$p(sid,"_",3)
				set pp1=$O(@adx@(nontype,chr,p1))
				if pp1'="",p2'<pp1 {
					s sid2=@adx@(nontype,chr,pp1)
					s pp2=$p(sid2,"_",3)
					if pp2>p2 {
						s @ad@(nontype,chr,sid,"link")=sid2
						s @cross@(p1,"SID")=sid
						s @cross@(p1,"Link")=sid2
						}
					}
			}
		}
}

ClassMethod CheckAllBoundaries(cross = "^Test2", ad, adx) As %Status
{
	k @cross
	m @cross=@ad
	s nontypelist=##class(APOBECNonBDNA.Setup).NontypeList()
	s iter=0
	while $Listnext(nontypelist,iter,nontype) {
		d ..CheckBoundaries(nontype,$na(@cross@(nontype)),ad,adx)
	}
}

ClassMethod CheckBoundaries(nontype, cross, ad, adx) As %Status
{
		//w nontype,"=",^NonBDNA(nontype),!
		w nontype,!
		s iter=0
		while $Listnext(##class(APOBECNonBDNA.Setup).#ChromosomeList,iter,chr) {
			write "chromosome=",chr,!
			s st1=$O(@adx@(nontype,chr,""))
			while st1'="" {
				//w "index=",st1,!
				set sid1=@adx@(nontype,chr,st1)
				set fin1=$p(sid1,"_",3)
				set st2=$O(@adx@(nontype,chr,st1))
				if st2'="",fin1'<st2 {
					set sid2=@adx@(nontype,chr,st2)
					set fin2=$p(sid2,"_",3)
					if fin2>fin1 {
						// unite diapasones
						set sidu=sid1
						set $p(sidu,"_",3)=fin2
						set seq1=@cross@(chr,sid1)
						set seq2=@cross@(chr,sid2)
						set sequ=$E(seq1,1,st2-st1)_seq2
						set @cross@(chr,sidu)=sequ
						set @adx@(nontype,chr,st1)=sidu
						k @adx@(nontype,chr,st2)
						k @cross@(chr,sid1)
						k @cross@(chr,sid2)
						#; w sid1,!
						#; w sid2,!
						#; W "united=",sidu,!	
						Continue
					}
				}
				s st1=$O(@adx@(nontype,chr,st1))
			}
		}
}

/// ad - sequences in a form of @ad@(nontype,chr,sid)
ClassMethod AnalyzeAll(ad) As %Status
{
	do DISABLE^%SYS.NOJRN
	k ^seq
	s iter=0
	while $listnext(##class(APOBECNonBDNA.Setup).#NontypesList,iter,nontype) {
		d ..Analyze(nontype,ad)
	}
	do ENABLE^%SYS.NOJRN
}

///  ID=chr1_19494_19518_APR;tracts=3;composition=9A/7C/4G/4T;sequence=aatggcctagaatccgacccaataa
ClassMethod Analyze(nontype, ad) As %Status
{
	m triplets=^triplet
	w nontype,"=",^nontype(nontype),!
	s iter=0
	while $Listnext(##class(APOBECNonBDNA.Setup).#ChromosomeList,iter,chr) {
		write chr,!
		s sid="" for {
			s sid=$O(@ad@(nontype,chr,sid)) q:sid=""
			s non=$g(@ad@(nontype,chr,sid)) 
			s trip="" for {
				s trip=$o(triplets(trip)) q:trip=""
				s occ=$L(non,trip)-1
				if occ {
					set ^seq(trip,nontype)=$g(^seq(trip,nontype))+occ
					set ^seq(trip,nontype,chr)=$g(^seq(trip,nontype,chr))+occ
				}			
			}
			
		}
	}
}

}
