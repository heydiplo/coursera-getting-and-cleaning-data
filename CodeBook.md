# Code Book

This document describes how `run_analysys.R` works.

## Preparations

Read variable names and filter the ones which contains mean or standard deviation (contains `mean()` or `std()`).

```r
all_var_names <- read.table("features.txt")$V2
var_filter <- grepl("(mean|std)\\(\\)", all_var_names)
```

Read activities dictionary for later use.
```r
activities_dict <- read.table("activity_labels.txt")
names(activities_dict) <- c('id', 'name')
```

## Loading raw data

We'll use `load_dataset(dataset_file, activities_file, subjects_file)` function to load test and train datasets separately, each with it's own activities and subjects list.

Set proper variable names and filter only variables we need.
```r
  names(raw_dataset) <- all_var_names
  dataset <- raw_dataset[var_filter]
```

Read activities ids, replace them with proper activities names and add to the dataset.
```r
  activities <- read.table(activities_file)
  activities <- activities_dict[ match(activities$V1, activities_dict$id), 2 ]
  dataset$activity <- activities
```

Read subject ids and add to the dataset.
```r
  subjects <- read.table(subjects_file)$V1
  dataset$subject <- subjects
```

## Actually loading and merging the data

Load train and test datasets with `load_dataset` function.

```r
train_dataset <- load_dataset("train/X_train.txt", "train/y_train.txt", "train/subject_train.txt")
test_dataset <- load_dataset("test/X_test.txt", "test/y_test.txt", "test/subject_test.txt")
```

Merge them together. We do vertical merge as it's just different observations.
```r
merged_dataset <- rbind(train_dataset, test_dataset)
```

Change dataset to long-format.
```r
melted_dataset <- melt(merged_dataset, id = c("activity", "subject"))
```

Reshape dataset using `activity` and `subject` as id and variables average as value.
```r
averages <- dcast(melted_dataset, activity + subject ~ variable, mean)
```

Now it looks like this:

```r
> str(averages)
'data.frame':   180 obs. of  68 variables:
 $ activity                   : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ subject                    : int  1 2 3 4 5 6 7 8 9 10 ...
 $ tBodyAcc-mean()-X          : num  0.222 0.281 0.276 0.264 0.278 ...
 $ tBodyAcc-mean()-Y          : num  -0.0405 -0.0182 -0.019 -0.015 -0.0183 ...
 $ tBodyAcc-mean()-Z          : num  -0.113 -0.107 -0.101 -0.111 -0.108 ...
 $ tBodyAcc-std()-X           : num  -0.928 -0.974 -0.983 -0.954 -0.966 ...
 $ tBodyAcc-std()-Y           : num  -0.837 -0.98 -0.962 -0.942 -0.969 ...
 $ tBodyAcc-std()-Z           : num  -0.826 -0.984 -0.964 -0.963 -0.969 ...
 $ tGravityAcc-mean()-X       : num  -0.249 -0.51 -0.242 -0.421 -0.483 ...
 $ tGravityAcc-mean()-Y       : num  0.706 0.753 0.837 0.915 0.955 ...
 $ tGravityAcc-mean()-Z       : num  0.446 0.647 0.489 0.342 0.264 ...
 $ tGravityAcc-std()-X        : num  -0.897 -0.959 -0.983 -0.921 -0.946 ...
 $ tGravityAcc-std()-Y        : num  -0.908 -0.988 -0.981 -0.97 -0.986 ...
 $ tGravityAcc-std()-Z        : num  -0.852 -0.984 -0.965 -0.976 -0.977 ...
 ...
```

## Output

Write resulting dataset to the standard output.

```r
write.table(averages, file = "", row.name = FALSE)
```

## Variables

`all_var_names` – proper variable names.

`var_filter` - boolean vector indication whenether we should pick given variable

`activities_dict` - dictionary with proper activities names

`train_dataset` - train dataset, with proper variable names and activity and subject columns

`test_dataset` - test dataset, with proper variable names and activity and subject columns

`merged_dataset` - train and tests datasets together

`melted_dataset` - merged dataset in long format

`averages` - tidy data set with the average of each variable for each activity and each subject in merged dataset
