#The Burke-Lauenroth Laboratory 
#SoilWatOutput.R
#Script to rename the columns of the compiled csv files, and push them to a sqlite database.

library(plyr)
library(RSQLite)

tickon<-proc.time()

#Add output databse
output_database<-paste("/home/ksodhi/sagebrush/","WrapperOutput.sqlite",sep="")
db <- dbConnect(SQLite(), output_database)
#Add number of sites and GCMs
sites<-2
GCM<-17

source.dir<-"/home/ksodhi/sagebrush/"
setwd(source.dir)

for(s in 1:sites)
{
  directory<-paste(source.dir,"StepWat_R_Wrapper_",s,sep="")
  setwd(directory)
  for (g in 1:GCM)
  {
    setwd(paste(directory,"/Stepwat.Site.",s,".",g,"/sw_src/testing/Output",sep=""))
    temp<-data.frame(read.csv("total_dy.csv",header=TRUE, sep=","))
    dbWriteTable(db, "total_dy", temp, append=T)
    
    setwd(paste(directory,"/Stepwat.Site.",s,".",g,"/sw_src/testing/Output",sep=""))
    temp<-data.frame(read.csv("total_wk.csv",header=TRUE, sep=","))
    dbWriteTable(db, "total_wk", temp, append=T)
    
    setwd(paste(directory,"/Stepwat.Site.",s,".",g,"/sw_src/testing/Output",sep=""))
    temp<-data.frame(read.csv("total_mo.csv",header=TRUE, sep=","))
    dbWriteTable(db, "total_mo", temp, append=T)
    
    setwd(paste(directory,"/Stepwat.Site.",s,".",g,"/sw_src/testing/Output",sep=""))
    temp<-data.frame(read.csv("total_yr.csv",header=TRUE, sep=","))
    dbWriteTable(db, "total_yr", temp, append=T)
    
    setwd(paste(directory,"/Stepwat.Site.",s,".",g,"/testing.sagebrush.MT_drs/Stepwat_Inputs/Output",sep=""))
    temp<-data.frame(read.csv("total_bmass.csv",header=TRUE, sep=","))
    dbWriteTable(db, "total_bmass", temp, append=T)
    temp<-data.frame(read.csv("total_mort.csv",header=TRUE, sep=","))
    dbWriteTable(db, "total_mort", temp, append=T)
  }
  setwd(source.dir)
}

tickoff<-proc.time()-tickon
print(tickoff)

