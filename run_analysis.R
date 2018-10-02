#!/usr/bin/Rscript

library(stringr)

transform.names <- function(feature.names) {
    result <- str_replace_all(feature.names, "^(t)(.*)", "Time \\2")
    result <- str_replace_all(result, "^(f)(.*)", "Frequency \\2")
    result <-
        str_replace_all(result, "^(angle\\(t)(.*)", "angle(Time \\2")
    result <- str_replace_all(result, "Acc", "Accelerometer ")
    result <- str_replace_all(result, "Gyro", "Gyroscope ")
    result <- str_replace_all(result, "Body", "Body ")
    result <- str_replace_all(result, "Jerk", "Jerk ")
    result <- str_replace_all(result, "Mag", "Magnitude ")
    result <- str_replace_all(result, "-mean\\(\\)", "Mean")
    result <-
        str_replace_all(result, "-std\\(\\)", "Standard Deviation")
    result
}

if (!file.exists("data")) {
    dir.create("data")
}

destFile <- "./data/dataset.zip"
if (!file.exists(destFile)) {
    fileUrl <-
        "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = "./data/dataset.zip", method = "curl")
    dateDownloaded <- date()
    print(paste("Download date:", dateDownloaded))
}

if (!file.exists("./data/UCI HAR Dataset")) {
    unzip("./data/dataset.zip", exdir = "data")
}

dataDir <- "./data/UCI HAR Dataset/"

get.df <- function(fileName) {
    read.table(paste(dataDir, fileName, sep = ""), sep = "")
}

get.labels <- function(fileName) {
    labels <- get.df(fileName)
    labels[, 2]
}

activityLabels <- get.labels("activity_labels.txt")
print(activityLabels)
originalFeatureNames <- get.labels("features.txt")
selectedFeatureNames <-
    grep("^.*(-mean\\(\\)|-std\\(\\)).*$",
         originalFeatureNames,
         value = TRUE)
featureNames <- transform.names(selectedFeatureNames)
print(featureNames)
print(length(featureNames))

get.data.df <- function(file.path) {
    df <- get.df(file.path)
    colnames(df) <- originalFeatureNames
    df <- df[, selectedFeatureNames]
    colnames(df) <- featureNames
    df
}

trainDf <- get.data.df("train/X_train.txt")
testDf <- get.data.df("test/X_test.txt")
