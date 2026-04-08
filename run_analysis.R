library(dplyr)

# Read files
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

# Train data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge datasets
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)

# Label columns
colnames(X) <- features$V2
colnames(Y) <- "activity"
colnames(Subject) <- "subject"

# Combine
data <- cbind(Subject, Y, X)

# Extract mean and std
data <- data %>%
  select(subject, activity, contains("mean"), contains("std"))

# Use descriptive activity names
data$activity <- factor(data$activity,
                        levels = activity_labels$V1,
                        labels = activity_labels$V2)

# Clean variable names
names(data) <- gsub("\\()", "", names(data))
names(data) <- gsub("-", "_", names(data))
names(data) <- tolower(names(data))

# Create tidy dataset with average
tidy_data <- data %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean))

# Save output
write.table(tidy_data, "tidy_dataset.txt", row.name = FALSE)