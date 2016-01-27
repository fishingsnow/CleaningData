library(dplyr)

# read raw data
x_test = read.table("test/X_test.txt");
y_test = read.table("test/Y_test.txt");
subject_test = read.table("test/subject_test.txt");
x_train = read.table("train/X_train.txt");
y_train = read.table("train/Y_train.txt");
subject_train = read.table("train/subject_train.txt");
# merge raw data
mergedData <- rbind(x_test, x_train)
# release memory
rm(x_test)
rm(x_train)



# read and process feature names
features <- read.table("features.txt")
newFeatures <- as.character(features[, 2])
newFeatures <- gsub("[^a-zA-Z]", "", newFeatures)

# get all mean and std features
reducedList <- grep('(mean|std)', newFeatures, ignore.case = TRUE)
newFeatures <- newFeatures[reducedList]

# clean merged dataset
mergedData <- mergedData[reducedList]

# rename mergedData
names(mergedData) <- newFeatures

# merge with subject and activity data
subject <- rbind(subject_test, subject_train)
names(subject) <- c("subject")
activity <- rbind(y_test, y_train)
names(activity) <- c("activity")
mergedData <- cbind(subject, activity, mergedData)

summaryData <- mergedData %>%
      group_by_(.dots = list(quote(subject), quote(activity))) %>% 
      summarize_each(funs(mean))

write.table(summaryData, "summary.txt", row.names = FALSE)
