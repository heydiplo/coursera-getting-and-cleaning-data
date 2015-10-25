library(reshape2)

all_var_names <- read.table("features.txt")$V2
var_filter <- grepl("(mean|std)\\(\\)", all_var_names)

activities_dict <- read.table("activity_labels.txt")
names(activities_dict) <- c('id', 'name')

load_dataset <- function (dataset_file, activities_file, subjects_file) {
  raw_dataset <- read.table(dataset_file)
  names(raw_dataset) <- all_var_names
  dataset <- raw_dataset[var_filter]

  activities <- read.table(activities_file)
  activities <- activities_dict[ match(activities$V1, activities_dict$id), 2 ]
  dataset$activity <- activities

  subjects <- read.table(subjects_file)$V1
  dataset$subject <- subjects

  dataset
}

train_dataset <- load_dataset("train/X_train.txt", "train/y_train.txt", "train/subject_train.txt")
test_dataset <- load_dataset("test/X_test.txt", "test/y_test.txt", "test/subject_test.txt")
merged_dataset <- rbind(train_dataset, test_dataset)

melted_dataset <- melt(merged_dataset, id = c("activity", "subject"))
averages <- dcast(melted_dataset, activity + subject ~ variable, mean)

write.table(averages, file = "", row.name = FALSE)
