# Peer-graded Assignment: Getting and Cleaning Data Course Project
A Peer-graded Assignment of the Coursera course "Getting and Cleaning Data" week 4. The purpose of this project is to demonstrate ability to collect, work with, and clean a data set.

In this assignment we retrieve data for the project from the website that is a Machine Learning Repository and it represents data collected from the accelerometers from the Samsung Galaxy S II smartphone, who's needed to be rearrange in order to be tidy data set.

The code contained in the script named "run_analysis.R", can be called from inside an R session. For example, when launching a new R session and writing in the command line:

\> source("run_analysis.R")

This will read and execute the script that performs certain operations on a data set, as explained below, in order to prepare tidy data that can be used for later analysis. The final structure and content of the tidy data set is partly detailed in the file "CodeBook.md" and can be viewed with the command

\> View(Accelerometers_Mean)

written to the command line after running the script named "run_analysis.R".

The R script called run_analysis.R does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
