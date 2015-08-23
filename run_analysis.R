# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.# Course Project



setwd("/home/kwan/src/R/getting_cleaning")
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="Dataset.zip")

# unzip("Dataset.zip")

# print(list.files(path="."))
setwd("UCI HAR Dataset")
# print(list.files(path="."))
###############################################

###############################################
# 1. Merges the training and the test sets to create one data set.
###############################################

x_train <- read.table("train/X_train.txt")
x_test  <- read.table("test/X_test.txt")

# Row bind the x_test data to x_train, creating on mega-set
x_merged <- rbind(x_train, x_test)

subject_train <- read.table("train/subject_train.txt")
subject_test  <- read.table("test/subject_test.txt")

# Do the same with the subject datasets...
subject_merged <- rbind(subject_train, subject_test)

y_train  <- read.table("train/y_train.txt")
y_test   <- read.table("test/y_test.txt")

# ... and here too
y_merged <- rbind(y_train, y_test)


###############################################
# activity_labels contains:
# The experiments have been carried out with a group of 30 volunteers within 
# an age bracket of 19-48 years. Each person performed six activities 
# (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 


###############################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
###############################################
# foo <- grep("mean|std", features[,"V2"])  # error
# foo <- grep("(mean|std)", features[,"V2"])   # error
# foo <- grep("(mean|std)", features[,V2])  # error
# features.txt contains list of variables of each feature vector

features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Filter out only the mean/std entries as vector which will be used to select
# from x_merged

# mu_std_features <- grep("(mean|std)", features[,2])   # Won't work.. grabs meanFreq()
# std()  mean()   xxx-std()  or xxx-mean()
# (mean|std) match either mean or std
# (mean|std)\(\) 
# 

#mu_std_features <- grep("(mean|std)\(\)", features[,2])
# Error: '\(' is an unrecognized escape in character string starting ""(mean|std)\("
# https://kb.iu.edu/d/azzp

mu_std_features <- grep("(mean|std)\\(\\)", features[,2])

x_merged <- x_merged[, mu_std_features]
names(x_merged) <- features[mu_std_features, 2]


###############################################
# 3. Uses descriptive activity names to name the activities in the data set
###############################################

activity_labels <- read.table("activity_labels.txt")
# print(activity_labels)
# head(activity_labels)
activity_labels[,2] <- as.character(activity_labels[,2])
y_merged[, 1] <- activity_labels[y_merged[, 1], 2]




###############################################
# 4. Appropriately labels the data set with descriptive variable names. 
###############################################
# print(names(y_merged))
# print(names(sub_merged))

names(y_merged)    <- "activity"
names(subject_merged)  <- "subject"

###############################################
# 5. From the data set in step 4, creates a second, independent tidy data 
#    set with the average of each variable for each activity and each subject.
###############################################

# X_merged, y_merged, sub_merged 

# merge the datasets.. column bind them to create the activity, subject columns
foo <- cbind(x_merged, y_merged, subject_merged)

# library(dplyr)

# ddply(.data, .variables, .fun = NULL, ..., .progress = "none",
# .inform = FALSE, .drop = TRUE, .parallel = FALSE, .paropts = NULL)

# ddply(dfx, .(group, sex), summarize,
#      mean = round(mean(age), 2),
#      sd = round(sd(age), 2))

# print(names(foo))

goo <- ddply(foo, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(goo, "averages_data.txt", row.name=FALSE)
