#Dowloaded and put the unzipt file in wd
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Merges the Training and Testing Sets into 1 data set
## test data:
XTest<- read.table("Y:/Mijn Documenten/data/test/X_test.txt")
YTest<- read.table("Y:/Mijn Documenten/data/test/Y_test.txt")
SubjectTest <-read.table("Y:/Mijn Documenten/data/test/subject_test.txt")

## train data:
XTrain<- read.table("Y:/Mijn Documenten/data/train/X_train.txt")
YTrain<- read.table("Y:/Mijn Documenten/data/train/Y_train.txt")
SubjectTrain <-read.table("Y:/Mijn Documenten/data/train/subject_train.txt")

## Merge
data.train <- data.frame(SubjectTrain, YTrain, XTrain)
data.test <- data.frame(SubjectTest, YTest, XTest)

features <- read.csv("Y:/Mijn Documenten/data/features.txt", header = FALSE, sep = ' ')
features <- as.character(features[,2])

names(data.train) <- c(c("subject", "activity"), features)
names(data.test) <- c(c("subject", "activity"), features)

data.all <- rbind(data.train, data.test)

#Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std.select <- grep('mean|std', features)
data.sub <- data.all[,c(1,2,mean_std.select + 2)]

#Uses descriptive activity names to name the activities in the data set
activity <- read.table('Y:/Mijn Documenten/data/activity_labels.txt', header = FALSE)
activity <- as.character(activity [,2])
data.sub$activity <- activity.labels[data.sub$activity]

#Appropriately labels the data set with descriptive variable names.
name.new <- names(data.sub)
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(data.sub) <- name.new

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data.tidy<- aggregate(data.sub, by = list(activity = data.sub$activity, subject = data.sub$subject), mean)
write.table(data.tidy, file = "data.tidy.txt", row.name=FALSE)

#create code book
library(memisc)
Write(codebook(data.tidy), file="data.tidy.codebook.txt")
