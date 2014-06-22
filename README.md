# Summary

Course project for "Getting and Cleaning Data" class on Coursera.

# Solution script

Script run_analysis.R does the following:

1. Merges the training and the test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Notices

* Data files for transformation must be placed in "data" subdirectory inside current work directory with script. 
* Script uses library "reshape2" to transform data on step 5 (function "recast").
* Output file is placed in "data" subdirectory with name "tidy_data.txt".
* All descriptions are placed in comments inside script body.
