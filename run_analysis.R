# Script run_analysis.R does the following:

# 1. Merges the training and the test sets to create one data set
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Dependency check
if (!require("reshape2")) {
  install.packages("reshape2")
  require("reshape2")
}

# Variable for store path to datafiles
dataDir <- "data"

# Function to construct path to datafile
dataFile <- function(dataName, dataSet) {
  fileName <- paste(dataName, "_", dataSet, ".txt", sep = "")
  paste(dataDir, dataSet, fileName, sep = "/")
}

# Function to load data from train and test datasets
loadData <- function(dataSet) {
  
  # Path to "X" dataset
  xFile <- dataFile("X", dataSet)
  
  # Path to "y" dataset
  yFile <- dataFile("y", dataSet)
  
  # Path to "subject" dataset
  subjFile <- dataFile("subject", dataSet)
      
  # Loading data file
  xData <- read.table(xFile)
    
  # Loading activities file
  yData <- read.table(yFile)
    
  # Loading subject file
  subjData <- read.table(subjFile)
    
  # Make one dataset 
  cbind(xData, yData, subjData)
}

# Loading column names ...
features <- read.table(paste(dataDir, "features.txt", sep = "/"))
# ... and extract only mean and std features
msFeatures <- grepl(".*mean\\(\\)|.*std\\(\\)", features[, 2])

# Loading names of activities
activity <- read.table(paste(dataDir, "activity_labels.txt", sep = "/"))

# 1. Merge the training and the test sets to create one data set
trainData <- loadData("train")
testData  <- loadData("test")

mergeData <- rbind(trainData, testData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

# Construct the set for filtering from "mean" and "std" measurements 
# with additional two columns (activities and subject data)
filterSet <- c(msFeatures, c(TRUE, TRUE))

mergeData <- mergeData[, filterSet]

# 3. Use descriptive activity names to name the activities in the data set

# Additional column with names of activities appended to the dataset
mergeData[, dim(mergeData)[2] + 1] <- 
  activity[, 2][mergeData[, dim(mergeData)[2] - 1]]

# Remove codes of activities after names was saved
mergeData[dim(mergeData)[2] - 2] <- NULL

# 4. Label the data set with descriptive variable names

measureLabels <- as.vector(features[, 2][msFeatures])

idLabels <- c("Subject", "Activity")

labels <- c(measureLabels, idLabels)

names(mergeData) <- labels

# 5. Create independent tidy data set with the average of each variable for each activity and each subject

tidyData <- recast(mergeData, 
                   Subject + Activity ~ variable,
                   mean,
                   id.var = idLabels,
                   measure.var = measureLabels)
  
write.table(tidyData, 
            file = paste(dataDir, "tidy_data.txt", sep = "/"), 
            row.names = FALSE)