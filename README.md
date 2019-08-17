# dna_works

# Installation with docker

clone the repo. Open terminal in repo and run

```
# docker-compose up -d
```

# How to use
The applicatoin needs the files with nonBDNA parts. It expects it in the folder:
```
/iris/app/nonBDNA_parts/
```
For docker setup just place it in the root folder of the application near /src folder

1. Setup lists. Open terminal and call setup method
```
d ##class(APOBECNonBDNA.Setup).Setup()
```

2. Make the analysis. Run Analyze All method
```
d ##class(APOBECNonBDNA.DataAnalysis).AnalyzeAll()
```

3. Visualizing data. Setup SQL table.
```
 d ##class(APOBECNonBDNA.DataFacts).LoadData()   
```

After that the results of the calculation will be available in APOBECNonBDNA.DataFacts table via ODBC/JDBC

4. Visualize data with IRIS.
Build the cube:
```
d $System.DeepSee.BuildCube("Triplets")  
```

