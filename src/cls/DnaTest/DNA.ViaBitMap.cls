/// TODO: make macros out of chunk and chunkPos calculation in load and substring
Class DNA.ViaBitMap
{

Parameter CHUNKSIZE = 310000;

Parameter SKIPLETTER = "N";

ClassMethod loadFolder(folderPath As %String = "/home/mkazanov/HUMAN")
{
	//disable writing in journal, that should improve performance of loading
	do DISABLE^%SYS.NOJRN
	// by default in Russian installations global is created in collation Cyrillic3
	// there will be no Cyrillic characters in this global, so we can use Cache standar collation
	// to improve performance a little bit
	kill ^DNA
	write ##class(%GlobalEdit).Create(,"DNA",##class(%Collate).DisplayToLogical("Cache standard"))
	set rs = ##class(%ResultSet).%New("%File:FileSet")
	do rs.Execute(folderPath,"*") //filename pattern
	while rs.Next() {
		set filename = rs.Data("Name")
		write "Loading ", filename,!
		do ..load(filename)
	}
	do ENABLE^%SYS.NOJRN
}

ClassMethod load(filename As %String = "C:\work\dna\hs_ref_GRCh38.p2_chrY.fa")
{
	
	//chromosom is in filename between chr and .fa
	//"hs_ref_GRCh38.p2_chrY.fa" -> "Y"
	set chromosom = $Piece($Piece(filename,"chr",2),".fa",1)
	write chromosom,!
	
	open filename:"R":5
	if '$Test {
		write "unable to open file '",filename,"'",!
		quit
	}
	;set slash = $case($system.Version.GetOS(),"Windows":"\",:"/")
	;set filename = $Piece(filename,slash,*)
	
	do $system.Process.SetZEOF(1)
	use filename read x // skip first line
	set pos = 0
	for  {
		use filename read s
		quit:$zeof=-1
		//set s = $Zconvert(s, "U") // convert to upper case (not necessary in .fa files)
		for i=1:1:$Length(s) {
			set ch = $Extract(s, i)
			continue:ch=..#SKIPLETTER
			set chunk = (pos + i - 1) \ ..#CHUNKSIZE + 1 
			set chunkPos = (pos + i - 1) # ..#CHUNKSIZE + 1
			set $bit(^DNA(chromosom, ch,chunk),chunkPos) = 1
		}
		set pos = pos + $Length(s)
	}
	close filename
}

/// returns string of first subscripts order by amount of their children
ClassMethod alphabet(chromosom As %String) As %List
{
	set letter=""
	for  {
		set letter = $Order(^DNA(chromosom,letter))
		quit:letter=""
		set cnt = 0, c = ""
		for  {
			set c = $Order(^DNA(chromosom, letter, c))
			quit:c=""
			set cnt = cnt+1
		}
		//we want the most frequent ones first
		set freq(-cnt,letter) = 1
	}
	set res = "",f=""
	for  {
		set f = $Order(freq(f))
		quit:f=""
		set l = ""
		for  {
			set l = $Order(freq(f, l))
			quit:l=""
			set res = res _ $ListBuild(l)
		}
	}
	quit res
}

/// makes sense to pass letters in alphabet order by frequence, e.g. $ListBuild("A","C","G","T","R","S","W","Y").<br/>
/// <method>alphabet</method> returns in that order.
ClassMethod substring(chromosom As %String, start As %Integer, end As %Integer, alphabet As %List = {..alphabet(chromosom)}) As %String
{
	set res = ""
	
	set chunk = (start - 1) \ ..#CHUNKSIZE + 1 
	set chunkPos = (start - 1) # ..#CHUNKSIZE + 1
	
	set prevLetter = $Extract(alphabet, 1)
			
	for i=start:1:end {
		if prevLetter'=..#SKIPLETTER && $bit(^DNA(chromosom, prevLetter, chunk), chunkPos) {
			//chances are next letter in sequence is the same as previous one
			set res = res _ prevLetter
		} else {
			set found = 0
			
			set ptr=0
    		while $LISTNEXT(alphabet, ptr, letter) {
				continue:letter=prevLetter //already checked for it
				if $bit(^DNA(chromosom, letter, chunk), chunkPos) {
					set res = res _ letter
					set prevLetter = letter
					set found = 1
					quit
				}
			}
			
			if found = 0 {
				set res = res _ ..#SKIPLETTER
				set prevLetter = ..#SKIPLETTER
			}
		}
		
		if chunkPos = ..#CHUNKSIZE {
			set chunk = chunk + 1
			set chunkPos = 1
		} else {
			set chunkPos = chunkPos + 1
		}
	}
	quit res
}

ClassMethod substringBench()
{
  set z1 = $zhorolog
  set chromosom = $O(^DNA("")) // let's take first on stored
  quit:chromosom="" // if nothing is stored -- no benchmark
  set alphabet = ##class(DNA.ViaBitMap).alphabet(chromosom)
  for i=1:1:1000 {
  	set a = ##class(DNA.ViaBitMap).substring(chromosom, 23000, 25000, alphabet)
  }
  write $zhorolog - z1,!
}

}