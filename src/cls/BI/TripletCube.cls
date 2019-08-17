/// 
Class BI.TripletCube Extends %DeepSee.CubeDefinition [ DependsOn = APOBECNonBDNA.DataFacts ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Triplets" disabled="false" abstract="false" sourceClass="APOBECNonBDNA.DataFacts" caption="Triplets" nullReplacement="Missing Value" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="NonType" disabled="false" hasAll="false" allCaption="All NonType" allDisplayName="NonType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="NonType" disabled="false" sourceProperty="NonType" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Triplet" disabled="false" hasAll="false" allCaption="All Triplet" allDisplayName="Triplet" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Triplet" disabled="false" sourceProperty="Triplet" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Amount" disabled="false" sourceProperty="Amount" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN = "TRIPLET";

}
