Class APOBECNonBDNA.DataFacts Extends %Persistent
{

Property Triplet As %String;

Property NonType As %String;

Property Amount As %Integer;

ClassMethod LoadData() As %Status
{
    do DISABLE^%SYS.NOJRN
    d ..%KillExtent()
    s trip=$O(^seq(""))
    while trip'="" {
        s nontype=$O(^seq(trip,""))
        while nontype'="" {
            s d=..%New()
            s d.Triplet=trip
            s d.NonType=nontype
            s d.Amount=^seq(trip,nontype)
            d d.%Save()
            s nontype=$O(^seq(trip,nontype))
            
        }
        s trip=$O(^seq(trip))
    }

    do ENABLE^%SYS.NOJRN
}

Storage Default
{
<Data name="DataFactsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Triplet</Value>
</Value>
<Value name="3">
<Value>NonType</Value>
</Value>
<Value name="4">
<Value>Amount</Value>
</Value>
</Data>
<DataLocation>^APOBECNonBDNA.DataFactsD</DataLocation>
<DefaultData>DataFactsDefaultData</DefaultData>
<IdLocation>^APOBECNonBDNA.DataFactsD</IdLocation>
<IndexLocation>^APOBECNonBDNA.DataFactsI</IndexLocation>
<StreamLocation>^APOBECNonBDNA.DataFactsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
