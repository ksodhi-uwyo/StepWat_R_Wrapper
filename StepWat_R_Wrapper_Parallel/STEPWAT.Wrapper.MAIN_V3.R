#The Burke-Lauenroth Laboratory 
#STEPWAT R Wrapper
#Main R Script for STEPWAT_R_WRAPPER

#Load Required Packages
library(DBI)
library(RSQLite)
library(mail)
library(sendmailR)

#Load source files and directories in the environment

#Note: Change number of processors and output database location according to your system

#Number of cores
proc_count<-7

#Enter email id for timing statistics
#emailid<-"ksodhi@uwyo.edu"

#Source directory
source.dir<-"nopath"
source.dir<-paste(source.dir,"/", sep="")
setwd(source.dir)

#Database location
database<-paste("/home/ksodhi/","dbWeatherData_Sagebrush_KP.sqlite", sep="")

#Database (to write to) location
#output_database<-"/home/ksodhi/SoilWatOutput.sqlite" 
  
#Query script (Loads data from the database into a list)
query.file<-paste(source.dir,"RSoilWat31.Weather.Data.Query_V2.R", sep="")

#Assembly script (Assemble data with respect to years and conditions)
assemble.file<-paste(source.dir,"Weather.Assembly.Choices_V2.R", sep="")

#Markov script (To generate cov and prob files)
markov.file<-paste(source.dir,"Markov.Weather_V2.R",sep="")

#Wrapper script
wrapper.file<-paste(source.dir,"StepWat.Wrapper.Code_V3.R", sep="")

#Output script
output.file<-paste(source.dir,"SoilWatOutput.R", sep="")

#Start timing for timing statistics
tick_on<-proc.time()

site<-c(sitefolderid)#,2,3,4,5,6,7,8,9,10) 

################################ Weather Query Code ###################################



#Setup parameters for the weather aquisition (years, scenarios, timeperiod, GCMs, etc.) 
simstartyr <- 1979
endyr <- 2010
climate.ambient <- "Current"
climate.conditions <- c(climate.ambient,  "RCP45.CanESM2", "RCP45.CESM1-CAM5", "RCP45.CSIRO-Mk3-6-0", "RCP45.EC-EARTH", "RCP45.FGOALS-g2", "RCP45.FGOALS-s2", "RCP45.GFDL-CM3", "RCP45.GISS-E2-R", "RCP45.HadGEM2-CC", "RCP45.HadGEM2-ES",
                        "RCP45.inmcm4", "RCP45.IPSL-CM5A-MR", "RCP45.MIROC5", "RCP45.MIROC-ESM", "RCP45.MPI-ESM-MR", "RCP45.MRI-CGCM3", "RCP85.CanESM2", "RCP85.CESM1-CAM5", "RCP85.CSIRO-Mk3-6-0", "RCP85.EC-EARTH","RCP85.FGOALS-g2","RCP85.FGOALS-s2",
                        "RCP85.GFDL-CM3","RCP85.GISS-E2-R","RCP85.HadGEM2-CC","RCP85.HadGEM2-ES","RCP85.inmcm4","RCP85.IPSL-CM5A-MR","RCP85.MIROC5","RCP85.MIROC-ESM",
                        "RCP85.MPI-ESM-MR","RCP85.MRI-CGCM3")

# Difference between start and end year(if you want 2030-2060 use 50; if you want 2070-2100 use 90 below)
deltaFutureToSimStart_yr <- c(50,90)
# Downscaling method
downscaling.method <- c("hybrid-delta")

#Store climate conditons
#list of all future and current scenarios putting "Current" first	
temp <- climate.conditions[!grepl(climate.ambient, climate.conditions)] #make sure 'climate.ambient' is first entry
if(length(temp) > 0){
  temp <- paste0(deltaFutureToSimStart_yr, "years.", rep(temp, each=length(deltaFutureToSimStart_yr)))	#add (multiple) deltaFutureToSimStart_yr
  temp <- paste0(downscaling.method, ".", rep(temp, each=length(downscaling.method))) #add (multiple) downscaling.method
}

climate.conditions <-  c("Current",temp)
temp<-c("Current",temp)

#Vector of sites, the code needs to be run on
sites<-c(notassigned) 

# Source the code in query script
source(query.file)


############################### End Weather Query Code ################################

############################### Weather Assembly Code #################################
site<-c(sitefolderid)
# Set output directories
weather.dir<-source.dir
setwd(weather.dir)
dir.create("StepWat.Weather.Markov.Test", showWarnings = FALSE)
assembly_output<-paste(source.dir,"StepWat.Weather.Markov.Test/",sep="")

setwd(assembly_output)

#Number of sites
#S<-length(sites)

# Number of scenarios (GCM X RCP X Periods run)
H<-length(temp)


#Parameters for weather assembly script
AssemblyStartYear<-1980
# Number of years (in one section)
K<-30
# Interval Size
INT<-30
# Final number of years wanted
FIN<-30
#Resampling time
RE<-FIN/INT

#### Type ##########################################
# choose between "basic" (for 1,5,10,30 year); "back" (for 5 year non-driest back-to-back);
#         OR "drought" (for 5 year non-driest back-to-back and only once in 20 years); or "markov"
#         (for markov code output) !!!! if using Markov remember to flag it in weathersetup.in !!!!
TYPE<-"basic"


#Source the code in assembly script
source(assemble.file)


############################### End Weather Assembly Code ################################

############################# MARKOV Weather Generator Code ##############################

site<-c(sitefolderid)#,2,3,4,5,6,7,8,9,10) 

#Change directory to output directory of assemble script
setwd(assembly_output)
# number of years 
yr<-30 
#Set Type
TYPE2<-"markov"
#Source the code in markov script
source(markov.file)
############################# End MARKOV Weather Generator Code ##############################

############### Run Wrapper Code ############################################################

########### Set parameters ###############################################

site<-c(sitefolderid)#,2,3,4,5,6,7,8,9,10) 

#Directory stores working directory
directory<-source.dir

#s - select which site to run either all (say 1-10 as shown below) or only a couple '<-c(1,5)'
#Set GCM

GCM<-c("Current","CanESM2","CESM1-CAM5","CSIRO-Mk3-6-0","EC-EARTH","FGOALS-g2","FGOALS-s2","GFDL-CM3","GISS-E2-R","HadGEM2-CC","HadGEM2-ES","inmcm4", "IPSL-CM5A-MR", "MIROC5", "MIROC-ESM", "MPI-ESM-MR", "MRI-CGCM3")
#Set RCP
RCP<-c("RCP45","RCP85")
#Set Years
YEARS<-c("50years","90years")
# Disturbance Flag
dist.graz.flag<-T
# Disturbance folder
dist.directory<-paste(source.dir,"STEPWAT_DIST/",sep="")

#Distubrance freqency 
#dist.freq<-c(50,2,0) # if not using disturbance but are using grazing set 'dist.freq<-0'
dist.freq<-c(0,2,10,50) # if not using disturbance but are using grazing set 'dist.freq<-0'

#Grazing freq
#graz.freq<-c(1,0) # if only using distrubance and not grazing set 'graz.freq<-0'
graz.freq<-c(1)

#Grazing intensity
graz_intensity<-c("lowgraz")

#Soil types are specified here, in accordance with the files added to STEPWAT_DIST
soil.types<-c("soils.17sand.13clay","soils.32sand.34clay","soils.58sand.10clay")


#Source the code in wrapper script
source(wrapper.file)

################ End Wrapper Code ########################################################
#Stop timing for timing statistics
tick_off<-proc.time()-tick_on
print(tick_off)
