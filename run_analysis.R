#!/usr/bin/Rscript

library(dplyr)
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
    result <- str_replace_all(result, "-X", " \\(X Direction\\)")
    result <- str_replace_all(result, "-Y", " \\(Y Direction\\)")
    result <- str_replace_all(result, "-Z", " \\(Z Direction\\)")
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
originalFeatureNames <- get.labels("features.txt")
selectedFeatureNames <-
    grep("^.*(-mean\\(\\)|-std\\(\\)).*$",
         originalFeatureNames,
         value = TRUE)
featureNames <- transform.names(selectedFeatureNames)

file.suffix <- ".txt"

get.file.name <- function(data.type, file.part) {
    file.prefix <- paste(data.type, "/", sep = "")
    paste(paste(paste(file.prefix, file.part, sep = ""), data.type, sep = ""), file.suffix, sep = "")
}

get.data.df <- function(data.type) {
    file.name <- get.file.name(data.type, "X_")
    df <- get.df(file.name)
    colnames(df) <- originalFeatureNames
    df <- df[, selectedFeatureNames]
    colnames(df) <- featureNames
    subject.name <- get.file.name(data.type, "subject_")
    subject.df <- get.df(subject.name)
    df['Subject ID'] <- subject.df[1]
    y.name <- get.file.name(data.type, "y_")
    y.df <- get.df(y.name)
    y <- lapply(y.df[1], function(x) {
        activityLabels[x]
    })
    df['Activity'] <- y
    df <- df %>% select("Subject ID", "Activity", everything())
    df
}

trainDf <- get.data.df("train")
testDf <- get.data.df("test")
df.1 <- rbind(trainDf, testDf)
write.table(df.1, paste("./data/", "df.1.txt", sep = ""))
