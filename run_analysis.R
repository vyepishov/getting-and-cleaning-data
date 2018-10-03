#!/usr/bin/Rscript

library(dplyr)
library(stringr)

transform.names <- function(feature.names) {
    result <- str_replace_all(feature.names, "^(t)(.*)", "Time \\2")
    result <- str_replace_all(result, "^(f)(.*)", "Frequency \\2")
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

rootDataDir <- "data"

if (!file.exists(rootDataDir)) {
    dir.create(rootDataDir)
}

dirPrefix <- "./"

destFile <- paste(dirPrefix, rootDataDir, "/dataset.zip", sep = "")

if (!file.exists(destFile)) {
    fileUrl <-
        "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = destFile, method = "curl")
    dateDownloaded <- date()
    print(paste("Download date:", dateDownloaded))
}

dataDir <-
    paste(dirPrefix, rootDataDir, "/UCI HAR Dataset/", sep = "")

if (!file.exists(dataDir)) {
    unzip(destFile, exdir = rootDataDir)
}

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
    paste(file.prefix, file.part, data.type, file.suffix, sep = "")
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

add.record.id <- function(df) {
    df["Record ID"] <- 1:nrow(df)
    df2 <- df %>% select("Record ID", everything())
    df2
}

trainDf <- get.data.df("train")
testDf <- get.data.df("test")
df.1 <- rbind(trainDf, testDf)
df.1 <- add.record.id(df.1)
write.table(df.1,
            paste(dirPrefix, "df.1.txt", sep = ""),
            row.names = FALSE)
df.2 <-
    df.1 %>% select(-c(`Record ID`)) %>% group_by(`Subject ID`, Activity) %>% summarise_all("mean")
df.2 <- add.record.id(df.2)
write.table(df.2,
            paste(dirPrefix, "df.2.txt", sep = ""),
            row.names = FALSE)
