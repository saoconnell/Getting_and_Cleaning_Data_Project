###--------------------------------------------------------------
###  run_analysis.R: Getting and Cleaning Data Project 
###
###     get and cleanup a UCI data set on human activity,
###        create a tidy dataset, and calcualte the means of
###        select variables
###          
###  Date          By           Notes
###  2014-05-15   saoconnell    Initial development
###--------------------------------------------------------------
## CLEANUP THE WORK SPACE
rm(list=ls())

## LOAD PACKAGES
require(data.table)
require(plyr)
require(reshape2)

## CHANGE THE WORKING DIRECTORY
setwd("/Users/oconste/Documents/workspace/coursera/Data_Science/Getting_and_Cleaning_Data/Project/Getting_and_Cleaning_Data_Project/")
getwd()

##---------------------------------------------------------------------------
## READ HEADER, AND SELECT THE MEAN AND STD COLUMNS
##---------------------------------------------------------------------------
headerRAW <- read.csv("UCI\ HAR\ Dataset/features.txt", sep=" ", header=FALSE)
names(headerRAW) <- c("colNum","colName")
headerFIX <- headerRAW

## CLEAN THE HEADER AND CREATE MEANINGFUL VARIABLE NAMES
##   REPLACE '-' & ',' WITH '.'
headerFIX$colName <- gsub("[-,]", '\\.', headerRAW$colName)
##   REPLACE '(' & ')' WITH '' (NULL, REMOVE)
headerFIX$colName <- gsub("[()]", '', headerFIX$colName)

## MEAN & STD COLUMNS TO SELECT FROM THE FULL DATASET
includeCol <- grep(".+[.]((mean)|(std))(([.]+)|$)?", tolower(headerFIX$colName))

## DATASET COLUMN NAMES
datasetHeader <- as.vector(headerFIX$colName[includeCol]) 

##---------------------------------------------------------------------------
## READ TEST AND TRAINING DATASETS INTO data.tables
##---------------------------------------------------------------------------
fileIn <- list()

### COMMAND TO REMOVED THE EXTRA ' ' IN THE DATASETS, THIS IS A PRE-PROCESSING STEP
###   IN THE fread, AND WILL ONLY WORK ON AN UNIX OR MAC PLATFORM
# sed 's/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g' 

## READ INTO A LIST
fileIn[["X.test"]] <- fread("sed 's/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g'  \"UCI\ HAR\ Dataset/test/X_test.txt\"", sep="auto", header=FALSE)
fileIn[["X.train"]] <- fread("sed 's/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g'  \"UCI\ HAR\ Dataset/train/X_train.txt\"", sep="auto", header=FALSE)


### COMBINE THE TEST AND TRAINING DATASETS
workingDS <- rbindlist(fileIn)

### INCLUDE ONLY THE MEAN AND STD COLUMNS
workingDS <- workingDS[,includeCol, with=FALSE]


##---------------------------------------------------------------------------
## READ  ACTIVITY INDICATORS (Y VALUE) AND  FOR TRAIN AND TEST
##---------------------------------------------------------------------------
## ACTIVITY (Y VALUE)
y.test <- fread("UCI\ HAR\ Dataset/test/y_test.txt", sep="auto", header=FALSE)
y.train <- fread("UCI\ HAR\ Dataset/train/y_train.txt", sep="auto", header=FALSE)

## CONCATENATE THE TEST AND TRAIN ACTIVITIES
activity <- rbind(y.test, y.train)
setnames(activity, 1, "activity")

## READ THE ACTIVTY_LABELS FILE TO CONVERT ACTIVITY NUMBER TO A LABEL
act <- read.csv("UCI\ HAR\ Dataset/activity_labels.txt", sep=" ", header=FALSE)
setnames(act, 1:2, c("actNum", "actLabel"))

## CONVERT ACTIVITY NUMBER TO ACTIVITY LABEL
activity[, actLabel:=act[activity, "actLabel"]]
activityLabel <- as.character(activity$actLabel)

##---------------------------------------------------------------------------
## READ  SUBJECT ID INFO FOR TRAIN AND TEST
##---------------------------------------------------------------------------
## READ SUBJECT ID
subject.test <- fread("UCI\ HAR\ Dataset/test/subject_test.txt", sep="auto", header=FALSE)
subject.train <- fread("UCI\ HAR\ Dataset/train/subject_train.txt", sep="auto", header=FALSE)

## CONCATENATE TEST AND TRAIN SUBJECT IDS
subjects <- rbind(subject.test, subject.train)
setnames(subjects, 1, "subjectId")


##---------------------------------------------------------------------------
##  MERGE MEAN, STD, SUBJECT AND ACTIVITY CODE
##---------------------------------------------------------------------------
##
workingData <- data.frame(workingDS[,cbind(subjects, activityLabel, workingDS)])

###  SET THE COLUMN NAMES TO TIDY VARIABLE NAMES
setnames(workingData, 1:ncol(workingData), c("subjectID","activityLabel", datasetHeader))

### CREATE THE TIDY DATA SET BY MELTING THE WORKING DATASET DOWN.
tidyData <- melt(workingData, id=c("subjectID", "activityLabel"))

## WRITE THE RESULT TO A TEXT FILE
write.table(tidyData, file="tidyData.txt", sep=" ")

##---------------------------------------------------------------------------
##  MEAN OF EACH VARIABLE BY SUBIECT ID, BY ACTIVITY
##---------------------------------------------------------------------------
##
meanBysubjectByactivity <- dcast(tidyData, subjectID + activityLabel ~ variable, mean)

tidyData_means <- melt(meanBysubjectByactivity, id=c("subjectID", "activityLabel"))

## WRITE THE RESULT TO A TEXT FILE, THE MELTED VERSION
write.table(tidyData_means, file="tidyData_means.txt", sep=" ")

## WIRTE THE WIDE TIDY DATA, 180*68 FOR SUBMISSION
write.table(meanBysubjectByactivity, file="meanBysubjectByactivity.txt", sep=" ")

dim(meanBysubjectByactivity)
options(width=30)
names(meanBysubjectByactivity)
