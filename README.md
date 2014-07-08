Getting and Cleaning Data Course Project: Guide to Ian's run_analysis.R
========================================================

This script runs assuming that you have set the "UCI HAR Dataset" folder as your working directory. This folder can be extracted from the .zip archive that is provided on the Course Project page of the Coursera course, Getting and Cleaning Data, along with the data source and other acknowledgements. 

Please have the script open and follow along. 

The script begins by loading in all the necessary data from the folder. The data in the "Inertial Signals" subfolders will not be used, so they are not involved in the script. 

An example command: 
```{r}
X.table <- read.table('./train/X_train.txt')
```

Note that the "features" variable is initially imported as a data frame with 2 columns. We are only interested in the second column, which will provide the names of the measurements. We reformat this variable as such:
```{r}
features.name <- features[,2]
features.name <- as.character[features.name]
```

We then merge the test and training sets. **Keep in mind that we append the training set to the test set, so all of the test set is before the training set.**
```{r}
mergedData <- rbind(X.test, X.train)
```

Note that there is no need to use the `merge()` command. The `rbind()` command works well because the columns of the datasets are identical. 

Our next step is to extract information pertaining only to the means and standard deviations of the measurement. A review of the variables found in `features.name` shows that "mean()" appears in all the means and "std()" appears in all the standard deviations. We can use the `grep()` command to extract the indices of each mean and standard deviation:
```{r}
meanCol <- grep("mean()", features.name, fixed=T)
```

Similar code is used for the standard deviations. We can now create a parsed dataset which will contain only these values of interest. We have the indices of the variables of interest, and they correspond to the columns in the dataset created by the script previously, `mergedData`.
```{r}
howmanyRows <- nrow(X.test)+nrow(X.train)
parsedData <- data.frame(row.names = 1:howmanyRows)
for(eachCol in meanstdCol) {
  parsedData <- cbind(parsedData, mergedData[, eachCol])
}
```

This creates a new dataset that only contains the columns from the previous dataset that were measurements of the mean or standard deviation. 

Now, we assign activity labels to the measurements. THis is where the `Y.train` and `Y.test` variables come in, which we extracted from files given to us. We can use rbind to merge them:
```{r}
mergedY <- rbind(Y.test, Y.train)
```

Remember that we must use `rbind()` in this order. The test group must precede the training group so it aligns properly with the measurement data. 

We can then bind this new vector with our dataset using `cbind()`. We can also create a vector with the activity names and then replace all the activity numbers with their corresponding string:
```{r}
activityList <- c("WALKING", "WALKING UPSTAIRS", "WALKING DOWNSTAIRS", 
  "SITTING", "STANDING", "LAYING")
index <- 1
for(eachActivity in parsedData[, 1]) {
	parsedData[, 1][index] <- activityList[eachActivity]
	index <- index+1
}
```

Using the subject variables we extracted previously, we now assign the subjects to their corresponding rows. This procedure is identical to the one used to assign activity labels. Remember to `rbind()` using the test set as the first parameter and the training set as the second. 

Now, we must take the average measurement of each of the measurements in our parsed dataset for each activity for each subject. That is, we want data that looks like:
```{r}
[SUBJECT NAME] [SUBJECT ACTIVITY] [AVERAGE MEASUREMENT 1] ... [AVERAGE MEASUREMENT N]
```

The script essentially creates a data frame for each activity, and then merges all the data frames together. 

This piece of code uses logicals to extract only rows that match both the subject number and activity for each subject and each activity. It computes the mean for each subject-activity combination separately and stores it in the data frame: 
```{r}
for(eachSubject in subjectIndex) {
  for(eachMe in measureIndex) {
		vMeans1[eachSubject, eachMe] <- mean(parsedData[parsedData[, 1] == 
			eachSubject & walking, eachMe+2])
	}
}
```

After assigning new column names and resorting, it writes out the file to a tab delimited text file. 
