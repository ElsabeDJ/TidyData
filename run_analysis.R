##########################################################################################################
## 1. Merges the training and the test sets to create one data set.
##########################################################################################################

directory <- "D:\\Personal\\DataScienceCoursera\\R_Projects\\TidyData\\UCI HAR Dataset\\"
setwd(directory)

# 1.1 Read the features data into a table

features <- read.table(file = "features.txt")  

# 1.2 Read the test data into a table and combine

directory <- "D:\\Personal\\DataScienceCoursera\\R_Projects\\TidyData\\UCI HAR Dataset\\test\\"
setwd(directory)

test_subject <- read.table(file = "subject_test.txt")
test_labels <- read.table(file = "y_test.txt")
test_set <- read.table(file = "X_test.txt")

names(test_subject) <- "ID"
names(test_labels) <- "activity"
names(test_set) <- features$V2

test_combined <- cbind(test_subject, test_labels, test_set)

# 1.3 Read the training data into a table and combine

directory <- "D:\\Personal\\DataScienceCoursera\\R_Projects\\TidyData\\UCI HAR Dataset\\train\\"
setwd(directory)

train_subject <- read.table(file = "subject_train.txt")
train_labels <- read.table(file = "y_train.txt") 
train_set <- read.table(file = "X_train.txt")

names(train_subject) <- "ID"
names(train_labels) <- "activity"
names(train_set) <- features$V2

train_combined <- cbind(train_subject, train_labels, train_set)

# 1.4 Combine the training and test datasets

train_test_combined <- rbind(test_combined, train_combined)

##########################################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
##########################################################################################################

mean_std_cols <- features[grepl("mean\\(\\)", names(combined)) | grepl("std\\(\\)", names(combined))
                          
mean_std_data <- train_test_combined[, c(1,2,mean_std_cols)]

##########################################################################################################
# 3. Uses descriptive activity names to name the activities in the data set
##########################################################################################################

directory <- "D:\\Personal\\DataScienceCoursera\\R_Projects\\TidyData\\UCI HAR Dataset\\"
setwd(directory)

activity_labels <- read.table(file = "activity_labels.txt")
mean_std_data[, 2] <- activity_labels[mean_std_data[,2], 2]

##########################################################################################################
# 4. Appropriately labels the data set with descriptive variable names.
##########################################################################################################

colnames(mean_std_data) <- c(
    'subject_id',
    'activity',
    gsub('\\-|\\(|\\)', '', as.character(mean_std_cols))
)

names(mean_std_data)<-gsub("^t", "Time", names(mean_std_data))
names(mean_std_data)<-gsub("^t", "Time", names(mean_std_data))
names(mean_std_data)<-gsub("^f", "Frequency", names(mean_std_data))
names(mean_std_data)<-gsub("mean", "Mean", names(mean_std_data))
names(mean_std_data)<-gsub("std", "STD", names(mean_std_data))


##########################################################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
#    variable for each activity and each subject.
##########################################################################################################

library(reshape2)

melted_data <- melt(mean_std_data, id=c("subject_id", "activity"))
tidy_data <- dcast(melted_data, subject_id + activity ~ variable, mean)

##########################################################################################################
# Write the tidy_data to a file
##########################################################################################################

filename <- "D:\\Personal\\DataScienceCoursera\\R_Projects\\TidyData\\UCI HAR Dataset\\tidy_data.txt"
write.table(tidy_data, file=filename, row.names=FALSE, quote=FALSE)


