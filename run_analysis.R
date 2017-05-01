# Used library
library(plyr)

# Working Directory
setwd('C:/Users/Toshiba/Documents/R/Coursera/Getting And Cleaning Data')

# Downloading and unzipping dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Merge the training and test sets to create one data set
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

# Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]

# Use descriptive activity names to name the activities in the data set
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# Correct column name
names(y_data) <- "activity"

# Correct column name
names(subject_data) <- "subject"

# Bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# Tidy data set in txt file
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "./data/UCI HAR Dataset/averages_data.txt", row.name=FALSE)