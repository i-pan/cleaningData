## This script assumes that the folder "UCI HAR Dataset", which is extracted
## from the .zip file obtained through the course project site for the Coursera 
## course, Getting and Cleaning Data, is your working directory. 
##
## Written by: Ian Pan
## Last updated: July 7, 2014

## Import data
X.train <- read.table('./train/X_train.txt')
Y.train <- read.table('./train/y_train.txt')
subject.train <- read.table('./train/subject_train.txt')
X.test <- read.table('./test/X_test.txt')
Y.test <- read.table('./test/y_test.txt')
subject.test <- read.table('./test/subject_test.txt')
features <- read.table('features.txt')

## Reformat features data into vector
features.name <- features[, 2] # interested in 2nd column only
features.name <- as.character(features.name) # easier to work with chars

## Merge training and test sets
mergedData <- rbind(X.test, X.train) # each column corresponds to variable

## Find out which columns mergedData correspond to the standard deviation and
## mean 
meanCol <- grep("mean()", features.name, fixed = T)
stdCol <- grep("std()", features.name, fixed = T)
meanstdCol <- sort(c(meanCol, stdCol))

## Extract measurements on mean and standard deviation for each measurement
howmanyRows <- nrow(X.test)+nrow(X.train)
parsedData <- data.frame(row.names = 1:howmanyRows)
for(eachCol in meanstdCol) {
	parsedData <- cbind(parsedData, mergedData[, eachCol])
}

## Rename columns in parsed dataset to specify what they measure
for(eachName in seq_along(colnames(parsedData))) {
	colnames(parsedData)[eachName] <- features.name[meanstdCol[eachName]]
}

## Assign descriptive labels to the activities in the data (each row)
mergedY <- rbind(Y.test, Y.train)
parsedData <- cbind(mergedY, parsedData)
activityList <- c("WALKING", "WALKING UPSTAIRS", "WALKING DOWNSTAIRS", 
	"SITTING", "STANDING", "LAYING")
index <- 1
for(eachActivity in parsedData[, 1]) {
	parsedData[, 1][index] <- activityList[eachActivity]
	index <- index+1
}
colnames(parsedData)[1] <- "ActivityPerformed"

## Assign subject numbers to each activity (each row) in the data
subject.merged <- rbind(subject.test, subject.train)
parsedData <- cbind(subject.merged, parsedData)
colnames(parsedData)[1] <- "SubjectNumber"

## Calculate means of each measurement for each subject for each activity
walking <- parsedData[, 2] == "WALKING"
walkingUp <- parsedData[, 2] == "WALKING UPSTAIRS"
walkingDown <- parsedData[, 2] == "WALKING DOWNSTAIRS"
sitting <- parsedData[, 2] == "SITTING"
standing <- parsedData[, 2] == "STANDING"
laying <- parsedData[, 2] == "LAYING"

subjectIndex <- 1:30
measureIndex <- 1:66
# each row in vMeans is subject, each column is measurement
vMeans1 <- matrix(0, nrow = 30, ncol = 66)
vMeans2 <- matrix(0, nrow = 30, ncol = 66)
vMeans3 <- matrix(0, nrow = 30, ncol = 66)
vMeans4 <- matrix(0, nrow = 30, ncol = 66)
vMeans5 <- matrix(0, nrow = 30, ncol = 66)
vMeans6 <- matrix(0, nrow = 30, ncol = 66)

for(eachSubject in subjectIndex) {
	for(eachMe in measureIndex) {
		vMeans1[eachSubject, eachMe] <- mean(parsedData[parsedData[, 1] == 
			eachSubject & walking, eachMe+2])
	}
}

for(eachSubject in subjectIndex) {
	for(eachMe in measureIndex) {
		vMeans2[eachSubject, eachMe] <- mean(parsedData[parsedData[, 1] == 
			eachSubject & walkingUp, eachMe+2])
	}
}

for(eachSubject in subjectIndex) {
	for(eachMe in measureIndex) {
		vMeans3[eachSubject, eachMe] <- mean(parsedData[parsedData[, 1] == 
			eachSubject & walkingDown, eachMe+2])
	}
}

for(eachSubject in subjectIndex) {
	for(eachMe in measureIndex) {
		vMeans4[eachSubject, eachMe] <- mean(parsedData[parsedData[, 1] == 
			eachSubject & sitting, eachMe+2])
	}
}

for(eachSubject in subjectIndex) {
	for(eachMe in measureIndex) {
		vMeans5[eachSubject, eachMe] <- mean(parsedData[parsedData[, 1] == 
			eachSubject & standing, eachMe+2])
	}
}

for(eachSubject in subjectIndex) {
	for(eachMe in measureIndex) {
		vMeans6[eachSubject, eachMe] <- mean(parsedData[parsedData[, 1] == 
			eachSubject & laying, eachMe+2])
	}
}

vMeans1 <- as.data.frame(vMeans1)
vMeans2 <- as.data.frame(vMeans2)
vMeans3 <- as.data.frame(vMeans3)
vMeans4 <- as.data.frame(vMeans4)
vMeans5 <- as.data.frame(vMeans5)
vMeans6 <- as.data.frame(vMeans6)

vNames <- colnames(parsedData)
index <- 3
for(eachName in vNames[3:68]) {
	vNames[index] <- paste(eachName, "AVERAGE")
	index <- index+1
}

vMeans1 <- cbind(subjectIndex, rep("WALKING", length=30), vMeans1)
colnames(vMeans1) <- vNames
vMeans2 <- cbind(subjectIndex, rep("WALKING UPSTAIRS", length=30), vMeans2)
colnames(vMeans2) <- vNames
vMeans3 <- cbind(subjectIndex, rep("WALKING DOWNSTAIRS", length=30), vMeans3)
colnames(vMeans3) <- vNames
vMeans4 <- cbind(subjectIndex, rep("SITTING", length=30), vMeans4)
colnames(vMeans4) <- vNames
vMeans5 <- cbind(subjectIndex, rep("STANDING", length=30), vMeans5)
colnames(vMeans5) <- vNames
vMeans6 <- cbind(subjectIndex, rep("LAYING", length=30), vMeans6)
colnames(vMeans6) <- vNames

tidyData <- rbind(vMeans1, vMeans2, vMeans3, vMeans4, vMeans5, vMeans6)
tidyData <- tidyData[order(tidyData[, 1]), ]
write.table(tidyData, "./tidyData.txt", sep="\t") # tab delimited txt file


