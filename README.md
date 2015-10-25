This is a course project for Coursera ['Getting and Cleaning Data'](https://www.coursera.org/course/getdata) course.

The goal is to process data collected from the accelerometers from the Samsung Galaxy S smartphone from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones, which is included in this repository, to

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names.
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

The only executable script is `run_analysis.R`, which assumes you already have data in the current directory and writes to the standard output. You can use it like that:

```bash
Rscript run_analysis.R > output.txt
```
