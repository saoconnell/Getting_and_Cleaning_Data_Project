Getting and Cleaning Data Code Book
========================================================

## Step 1: Create meaningful variable names

I am not familiar with this dataset or the work that went to collecting the data so
to pick replace names for these varibales is really not within the scope of work, IMHO.

However, the current names can use significant clean for subsequet processing in R.  Specifically,
the illegal characters and confusing characters need to be removed.

The source of all the vairables was read from the "features.txt" file which contained a list of all the
variables or features, depending on your preference.

The specicial charaters "-" and "," were replaced with "." and the "(" and ")" were replaced with a null value ''.

Only the mean and standard deviate variables were selected.  This was accomplished by greping on "mean" and "std".  
These appeared to be the most likely candidates based on the original developers naming convention.  

### New Variable Names

After clean up, the following are new names for the mean and standard deviation variables

 [1] "tBodyAcc.mean.X"                   
 [2] "tBodyAcc.mean.Y"                   
 [3] "tBodyAcc.mean.Z"                   
 [4] "tBodyAcc.std.X"                    
 [5] "tBodyAcc.std.Y"                    
 [6] "tBodyAcc.std.Z"                    
 [7] "tGravityAcc.mean.X"                
 [8] "tGravityAcc.mean.Y"                
 [9] "tGravityAcc.mean.Z"                
[10] "tGravityAcc.std.X"                 
[11] "tGravityAcc.std.Y"                 
[12] "tGravityAcc.std.Z"                 
[13] "tBodyAccJerk.mean.X"               
[14] "tBodyAccJerk.mean.Y"               
[15] "tBodyAccJerk.mean.Z"               
[16] "tBodyAccJerk.std.X"                
[17] "tBodyAccJerk.std.Y"                
[18] "tBodyAccJerk.std.Z"                
[19] "tBodyGyro.mean.X"                  
[20] "tBodyGyro.mean.Y"                  
[21] "tBodyGyro.mean.Z"                  
[22] "tBodyGyro.std.X"                   
[23] "tBodyGyro.std.Y"                   
[24] "tBodyGyro.std.Z"                   
[25] "tBodyGyroJerk.mean.X"              
[26] "tBodyGyroJerk.mean.Y"              
[27] "tBodyGyroJerk.mean.Z"              
[28] "tBodyGyroJerk.std.X"               
[29] "tBodyGyroJerk.std.Y"               
[30] "tBodyGyroJerk.std.Z"               
[31] "tBodyAccMag.mean"                  
[32] "tBodyAccMag.std"                   
[33] "tGravityAccMag.mean"               
[34] "tGravityAccMag.std"                
[35] "tBodyAccJerkMag.mean"              
[36] "tBodyAccJerkMag.std"               
[37] "tBodyGyroMag.mean"                 
[38] "tBodyGyroMag.std"                  
[39] "tBodyGyroJerkMag.mean"             
[40] "tBodyGyroJerkMag.std"              
[41] "fBodyAcc.mean.X"                   
[42] "fBodyAcc.mean.Y"                   
[43] "fBodyAcc.mean.Z"                   
[44] "fBodyAcc.std.X"                    
[45] "fBodyAcc.std.Y"                    
[46] "fBodyAcc.std.Z"                    
[47] "fBodyAcc.meanFreq.X"               
[48] "fBodyAcc.meanFreq.Y"               
[49] "fBodyAcc.meanFreq.Z"               
[50] "fBodyAccJerk.mean.X"               
[51] "fBodyAccJerk.mean.Y"               
[52] "fBodyAccJerk.mean.Z"               
[53] "fBodyAccJerk.std.X"                
[54] "fBodyAccJerk.std.Y"                
[55] "fBodyAccJerk.std.Z"                
[56] "fBodyAccJerk.meanFreq.X"           
[57] "fBodyAccJerk.meanFreq.Y"           
[58] "fBodyAccJerk.meanFreq.Z"           
[59] "fBodyGyro.mean.X"                  
[60] "fBodyGyro.mean.Y"                  
[61] "fBodyGyro.mean.Z"                  
[62] "fBodyGyro.std.X"                   
[63] "fBodyGyro.std.Y"                   
[64] "fBodyGyro.std.Z"                   
[65] "fBodyGyro.meanFreq.X"              
[66] "fBodyGyro.meanFreq.Y"              
[67] "fBodyGyro.meanFreq.Z"              
[68] "fBodyAccMag.mean"                  
[69] "fBodyAccMag.std"                   
[70] "fBodyAccMag.meanFreq"              
[71] "fBodyBodyAccJerkMag.mean"          
[72] "fBodyBodyAccJerkMag.std"           
[73] "fBodyBodyAccJerkMag.meanFreq"      
[74] "fBodyBodyGyroMag.mean"             
[75] "fBodyBodyGyroMag.std"              
[76] "fBodyBodyGyroMag.meanFreq"         
[77] "fBodyBodyGyroJerkMag.mean"         
[78] "fBodyBodyGyroJerkMag.std"          
[79] "fBodyBodyGyroJerkMag.meanFreq"     
[80] "angletBodyAccMean.gravity"         
[81] "angletBodyAccJerkMean.gravityMean" 
[82] "angletBodyGyroMean.gravityMean"    
[83] "angletBodyGyroJerkMean.gravityMean"
[84] "angleX.gravityMean"     
[85] "angleY.gravityMean"                
[86] "angleZ.gravityMean"     


## Step 2:  Reading the Test and Train Datasets

I had difficultly reading the dataset straigt into a data.table.  The additional spaces in the file were causing the
load to fail.  I used a feature of fread that allows a pre-processing step to run.  In this case I ran the following on the
source file prior to reading it in as data.table:

sed 's/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g' 

This Unix command will strip out any "extra" blanks.  This code will only work on a standard unix shell or OS X bash shell
that has the program sed available.

The test and train datasets were read into an element in a pre-defined list().  This enabled the use of data.tables
feature rbindlist, which I found to be slightly faster in this case.  However, I frequently load several files at 
a time and rbind them together.  The rbindlist, is MUCH fast at binding rows together.

## Step 3:  Feature Names



