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
    result <-
        str_replace_all(result, "-mad\\(\\)", "Median Absolute Deviation")
    result <- str_replace_all(result, "-max\\(\\)", "Maximum")
    result <- str_replace_all(result, "-min\\(\\)", "Minimum")
    result <-
        str_replace_all(result, "-sma\\(\\)", "Signal Magnitude Area")
    result <-
        str_replace_all(result, "-energy\\(\\)", "Energy Measure")
    result <-
        str_replace_all(result, "-iqr\\(\\)", "Interquartile Range")
    result <-
        str_replace_all(result, "-entropy\\(\\)", "Signal Entropy")
    result <-
        str_replace_all(result, "-arCoeff\\(\\)", "Autoregression Coefficient")
    result <-
        str_replace_all(result, "-correlation\\(\\)", "Correlation Coefficient")
    result <-
        str_replace_all(result, "-maxInds\\(\\)", "Largest Magnitude Index")
    result <-
        str_replace_all(result, "-maxInds", "Largest Magnitude Index")
    result <-
        str_replace_all(result, "-meanFreq\\(\\)", "Mean Frequency")
    result <- str_replace_all(result, "-skewness\\(\\)", "Skewness")
    result <- str_replace_all(result, "-kurtosis\\(\\)", "Kurtosis")
    result <-
        str_replace_all(result, "-bandsEnergy\\(\\)", "Frequency Interval Energy")
    result <-
        str_replace_all(result,
                        "^(angle)\\((.*),(.*)\\)$",
                        "Angle between \\2 and \\3")
    result <- str_replace_all(result, "\\)", "")
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
    print(list.files("./data/"))
    print(dateDownloaded)
}

if (!file.exists("./data/UCI HAR Dataset")) {
    unzip("./data/dataset.zip", exdir = "./data/")
}

dataDir <- "./data/UCI HAR Dataset/"
print(list.files(dataDir))

get.df <- function(fileName) {
    read.table(paste(dataDir, fileName, sep = ""), sep = " ")
}

get.labels <- function(fileName) {
    labels <- get.df(fileName)
    labels[, 2]
}

activityLabels <- get.labels("activity_labels.txt")
print(activityLabels)
featureNames <- get.labels("features.txt")
featureNames <- transform.names(featureNames)
print(featureNames)
print(length(featureNames))
