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

0. Run the whole set of calculations:

```
USER> zn "DNA"

DNA> d ##class(APOBECNonBDNA.DataAnalysis).run()
```

Open grafs on:
http://127.0.0.1:52774/csp/dna/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=Results/TripletsDash.dashboard

# Development
To export dfi dashboards do:
```
Import isc.dev
call

DNA> d ##class(dev.code).workdir("/iris/app/src")
DNA> d ##class(dev.code).export("*.DFI")
```