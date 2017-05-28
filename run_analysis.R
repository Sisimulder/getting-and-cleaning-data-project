#chooseCRANmirror() 

# 1 Merge the training and test sets to create one data set

## read the data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")

y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")

y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## combine the data
x_data <- rbind(x_train, x_test)

y_data <- rbind(y_train, y_test)

subject_data <- rbind(subject_train, subject_test)

fullData <- cbind(subject_data,y_data,x_data)

# 2 Extract only the measurements on the mean and standard deviation for each measurement
##load feature name
featureName <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)[,2]

## extract mean and std of each measurements
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
finalData <- fullData[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("subject", "activity", featureName[featureIndex])

# 3 use descriptive activity names 
## load the activity data
activityName <- read.table("UCI HAR Dataset/activity_labels.txt")
## replace 1 to 6 with activity names
finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])

# 4 Appropriately labels the data set with descriptive variable names
names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
install.packages("dplyr")
library(dplyr)
groupData <- finalData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(groupData, "UCI HAR Dataset/MeanData.txt", row.name=FALSE)

