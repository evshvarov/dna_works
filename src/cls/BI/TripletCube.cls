Class BI.TripletCube Extends %DeepSee.CubeDefinition [ DependsOn = APOBECNonBDNA.DataFacts ]
{

Parameter DOMAIN = "TRIPLET";

/// This xml document defines the HoleFoods model.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube name="Triplets" 
caption="Triplets"
nullReplacement="Missing Value"
sourceClass="APOBECNonBDNA.DataFacts">

</cube>
}

}
