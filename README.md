# getting_cleaning_coursera
Getting and Cleaning Data 

run_analysis.R

This script does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script first downloads the Samsung data: (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

It then unzips the data and sets the working directory to the extracted folder on disk. This is something of a workaround to prevent some errors when loading the data.

The data is then loaded into six data frames (x_train, x_test, y_train, y_test, subject_train, subject_test). These are merged into three data frames (x_merged, y_merged and subject_merged).

Using the information stored in the activity_labels.txt file, a descriptive name is added to each entry.

Next, all the data is merged into one large data frame by column binding each.

Finally, the ddply function is used to generate the summary data for writing.
