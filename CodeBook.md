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

Only the mean and standard deviate variables were selected.  This was accomplished by greping on "mean" and "std", excluding
the meanFreq variables

grep(".+[.]((mean)|(std))(([.]+)|$)?", tolower(headerFIX$colName)

These appeared to be the most likely candidates based on the original developers naming convention, description in the features_info.txt, and the vast forum exchange on this topic.  

### New Variable Names

After clean up, the following are new names for the mean and standard deviation variables

 [1] "subjectID"                
 [2] "activityLabel"            
 [3] "tBodyAcc.mean.X"          
 [4] "tBodyAcc.mean.Y"          
 [5] "tBodyAcc.mean.Z"          
 [6] "tBodyAcc.std.X"           
 [7] "tBodyAcc.std.Y"           
 [8] "tBodyAcc.std.Z"           
 [9] "tGravityAcc.mean.X"       
[10] "tGravityAcc.mean.Y"       
[11] "tGravityAcc.mean.Z"       
[12] "tGravityAcc.std.X"        
[13] "tGravityAcc.std.Y"        
[14] "tGravityAcc.std.Z"        
[15] "tBodyAccJerk.mean.X"      
[16] "tBodyAccJerk.mean.Y"      
[17] "tBodyAccJerk.mean.Z"      
[18] "tBodyAccJerk.std.X"       
[19] "tBodyAccJerk.std.Y"       
[20] "tBodyAccJerk.std.Z"       
[21] "tBodyGyro.mean.X"         
[22] "tBodyGyro.mean.Y"         
[23] "tBodyGyro.mean.Z"         
[24] "tBodyGyro.std.X"          
[25] "tBodyGyro.std.Y"          
[26] "tBodyGyro.std.Z"          
[27] "tBodyGyroJerk.mean.X"     
[28] "tBodyGyroJerk.mean.Y"     
[29] "tBodyGyroJerk.mean.Z"     
[30] "tBodyGyroJerk.std.X"      
[31] "tBodyGyroJerk.std.Y"      
[32] "tBodyGyroJerk.std.Z"      
[33] "tBodyAccMag.mean"         
[34] "tBodyAccMag.std"          
[35] "tGravityAccMag.mean"      
[36] "tGravityAccMag.std"       
[37] "tBodyAccJerkMag.mean"     
[38] "tBodyAccJerkMag.std"      
[39] "tBodyGyroMag.mean"        
[40] "tBodyGyroMag.std"         
[41] "tBodyGyroJerkMag.mean"    
[42] "tBodyGyroJerkMag.std"     
[43] "fBodyAcc.mean.X"          
[44] "fBodyAcc.mean.Y"          
[45] "fBodyAcc.mean.Z"          
[46] "fBodyAcc.std.X"           
[47] "fBodyAcc.std.Y"           
[48] "fBodyAcc.std.Z"           
[49] "fBodyAccJerk.mean.X"      
[50] "fBodyAccJerk.mean.Y"      
[51] "fBodyAccJerk.mean.Z"      
[52] "fBodyAccJerk.std.X"       
[53] "fBodyAccJerk.std.Y"       
[54] "fBodyAccJerk.std.Z"       
[55] "fBodyGyro.mean.X"         
[56] "fBodyGyro.mean.Y"         
[57] "fBodyGyro.mean.Z"         
[58] "fBodyGyro.std.X"          
[59] "fBodyGyro.std.Y"          
[60] "fBodyGyro.std.Z"          
[61] "fBodyAccMag.mean"         
[62] "fBodyAccMag.std"          
[63] "fBodyBodyAccJerkMag.mean" 
[64] "fBodyBodyAccJerkMag.std"  
[65] "fBodyBodyGyroMag.mean"    
[66] "fBodyBodyGyroMag.std"     
[67] "fBodyBodyGyroJerkMag.mean"
[68] "fBodyBodyGyroJerkMag.std" 

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

## Step 3:  ACTIVITY INDICATORS (Y VALUE) AND  FOR TRAIN AND TEST

The Y Labels are the activities associated with a specific set of samples.

The current Y label list was a numeric indicator for each row in the dataset.  This is not a very meaningful name.

The numeric values were replaced with their associated activity labels, greating a more meaningful name to be
associated with the measurements.

The y_test.txt and y_train.txt files were read in and the numeric value was replaced with the activity label that is located 
in the activities_label.txt file

## Step 4: Subjects

The subject_test.txt and subject_train.txt files were read in, rbind, and then associated with the working datasets created above.

## STEP 5: Merge everything together

Now that I have the working data (the select mean and std), a clean list of variable names, the activity labels cleaned up (test and train), and the subjects (test and train) I combined the together into one data.table.  

This data.table was converted to a data.frame for processing by reshape2::melt

The resulting melted dataset is written to a file, tidyData.txt for submission to Coursera.

## STEP 6

The tidayData is dcast and means of the combined data taken.

The resulting data is then written to a dataset for later processing.

## Submit Dataset

The means are calculated with the dcast function which promotes the melted dataset into a wide tidy set.
